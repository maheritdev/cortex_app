import 'dart:convert';

import 'package:cortex/feature/pharmacy/presentation/state/inventory_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../core/const/api_const.dart';
import '../../../../core/utils/PrintCont.dart';
import '../../data/Inventory.dart';

class InventoryCubit extends Cubit<InventoryState>{
  List<Inventory> response_body = []; // Initialize as empty list, not nullable

  InventoryCubit() : super(OnInitialInventoryState());



  Future<void> getInventory() async {
    emit(OnInitialInventoryState());
    print('Fetching from: ${ApiConst.get_inventory}');

    try {
      Uri uri = Uri.parse('${ApiConst.get_inventory}');
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> result =
        decoded is List ? decoded : (decoded['data'] ?? []);

        PrintCont.success('Raw response received (${result.length} items)');

        final List<Inventory> appointments = [];

        for (var item in result) {
          if (item == null) continue;
          /*if (item['rooms'] == null) {
            PrintCont.warning('Skipping rooms without room: ${item['roomId']}');
            continue;
          }*/
          try {
            final model = Inventory.fromJson(item);
            appointments.add(model);
          } catch (e) {
            PrintCont.error('Error parsing appointment: $e');
          }
        }

        response_body = appointments;
        PrintCont.success('Total appointments loaded: ${response_body.length}');
        emit(OnLoadedInventoryState(InventoryList: response_body));
      } else {
        PrintCont.error('HTTP Error: ${response.statusCode}');
        emit(OnErrorInventoryState('HTTP ${response.statusCode}'));
      }
    } catch (e) {
      PrintCont.error('Exception: $e');
      emit(OnErrorInventoryState(e.toString()));
    }
  }
}