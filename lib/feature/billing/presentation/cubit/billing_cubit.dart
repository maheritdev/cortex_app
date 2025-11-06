import 'dart:convert';

import 'package:cortex/feature/billing/data/billing_model.dart';
import 'package:cortex/feature/billing/presentation/state/billing_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../core/const/api_const.dart';
import '../../../../core/utils/PrintCont.dart';

class BillingCubit extends Cubit<BillingState> {
  List<BillingModel> response_body =
      []; // Initialize as empty list, not nullable

  BillingCubit() : super(OnInitialBillingState());

  Future<void> getPatientBilling(int id) async {
    emit(OnInitialBillingState());
    print('Fetching from: ${ApiConst.get_patients_billing}');

    try {
      Uri uri = Uri.parse('${ApiConst.get_patients_billing}$id');
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> result = decoded is List
            ? decoded
            : (decoded['data'] ?? []);

        PrintCont.success('Raw response received (${result.length} items)');

        final List<BillingModel> billings = [];

        for (var item in result) {
          if (item == null) continue;
          /*if (item['doctor'] == null) {
            PrintCont.warning(
              'Skipping appointment without doctor: ${item['appointmentId']}',
            );
            continue;
          }*/
          try {
            final model = BillingModel.fromJson(item);
            billings.add(model);
          } catch (e) {
            PrintCont.error('Error parsing appointment: $e');
          }
        }

        response_body = billings;
        PrintCont.success('Total appointments loaded: ${response_body.length}');
        emit(OnLoadedBillingState(billingsModel: response_body));
      } else {
        PrintCont.error('HTTP Error: ${response.statusCode}');
        emit(OnErrorBillingState('HTTP ${response.statusCode}'));
      }
    } catch (e) {
      PrintCont.error('Exception: $e');
      emit(OnErrorBillingState(e.toString()));
    }
  }
}
