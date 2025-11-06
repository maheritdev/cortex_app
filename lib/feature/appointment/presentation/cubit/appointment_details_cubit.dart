import 'dart:convert';

import 'package:cortex/feature/appointment/data/appointment_details_model.dart';
import 'package:cortex/feature/appointment/data/appointment_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../core/const/api_const.dart';
import '../../../../core/utils/PrintCont.dart';
import '../state/appointment_details_state.dart';
import '../state/appointment_state.dart';

class AppointmentDetailsCubit extends Cubit<AppointmentDetailsState> {
  AppointmentDetailsModel? response_body;

  AppointmentDetailsCubit() : super(OnInitialAppointmentDetailsState());


  Future<void> getAppointmentDetails(int id) async {
    emit(OnLoadingAppointmentDetailsState());
    print('Fetching from: ${ApiConst.get_appointment_details}');

    try {
      Uri uri = Uri.parse('${ApiConst.get_appointment_details}$id');
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        response_body = AppointmentDetailsModel.fromJson(result);
        PrintCont.success('Total appointments loaded: ${response_body}');
        emit(OnLoadedAppointmentDetailsState(appointmentDetailsModel: response_body));
      } else {
        PrintCont.error('HTTP Error: ${response.statusCode}');
        emit(OnErrorAppointmentDetailsState('HTTP ${response.statusCode}'));
      }
    } catch (e) {
      PrintCont.error('Exception: $e');
      emit(OnErrorAppointmentDetailsState(e.toString()));
    }
  }
}