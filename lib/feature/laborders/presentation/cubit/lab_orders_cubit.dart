import 'dart:convert';

import 'package:cortex/feature/laborders/data/lab_orders.dart';
import 'package:cortex/feature/laborders/presentation/state/lab_orders_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../core/const/api_const.dart';
import '../../../../core/utils/PrintCont.dart';

class LabOrdersCubit extends Cubit<LabOrdersState>{

  List<LabOrders> response_body = []; // Initialize as empty list, not nullable

  LabOrdersCubit() : super(OnInitialLabOrdersState());



  Future<void> getLabOrders(int id) async {
    emit(OnInitialLabOrdersState());
    print('Fetching from: ${ApiConst.get_patients_Lab_orders}');

    try {
      Uri uri = Uri.parse('${ApiConst.get_patients_Lab_orders}$id');
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> result =
        decoded is List ? decoded : (decoded['data'] ?? []);

        PrintCont.success('Raw response received (${result.length} items)');

        final List<LabOrders> appointments = [];

        for (var item in result) {
          if (item == null) continue;
          /*if (item['rooms'] == null) {
            PrintCont.warning('Skipping rooms without room: ${item['roomId']}');
            continue;
          }*/
          try {
            final model = LabOrders.fromJson(item);
            appointments.add(model);
          } catch (e) {
            PrintCont.error('Error parsing appointment: $e');
          }
        }

        response_body = appointments;
        PrintCont.success('Total appointments loaded: ${response_body.length}');
        emit(OnLoadedLabOrdersState(labOrders: response_body));
      } else {
        PrintCont.error('HTTP Error: ${response.statusCode}');
        emit(OnErrorLabOrdersState('HTTP ${response.statusCode}'));
      }
    } catch (e) {
      PrintCont.error('Exception: $e');
      emit(OnErrorLabOrdersState(e.toString()));
    }
  }
}
