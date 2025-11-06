import 'dart:convert';

import 'package:cortex/feature/appointment/data/appointment_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../core/const/api_const.dart';
import '../../../../core/utils/PrintCont.dart';
import '../state/appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  List<AppointmentModel> response_body = []; // Initialize as empty list, not nullable

  AppointmentCubit() : super(OnInitialAppointmentState());


  Future<void> getAppointments(int id) async {
    emit(OnLoadingAppointmentState());
    print('Fetching from: ${ApiConst.get_appointments}');

    try {
      Uri uri = Uri.parse('${ApiConst.get_appointments}$id');
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> result =
        decoded is List ? decoded : (decoded['data'] ?? []);

        PrintCont.success('Raw response received (${result.length} items)');

        final List<AppointmentModel> appointments = [];

        for (var item in result) {
          if (item == null) continue;
          if (item['doctor'] == null) {
            PrintCont.warning('Skipping appointment without doctor: ${item['appointmentId']}');
            continue;
          }
          try {
            final model = AppointmentModel.fromJson(item);
            appointments.add(model);
          } catch (e) {
            PrintCont.error('Error parsing appointment: $e');
          }
        }

        response_body = appointments;
        PrintCont.success('Total appointments loaded: ${response_body.length}');
        emit(OnLoadedAppointmentState(appointmentModel: response_body));
      } else {
        PrintCont.error('HTTP Error: ${response.statusCode}');
        emit(OnErrorAppointmentState('HTTP ${response.statusCode}'));
      }
    } catch (e) {
      PrintCont.error('Exception: $e');
      emit(OnErrorAppointmentState(e.toString()));
    }
  }
}