import 'dart:convert';

import 'package:cortex/feature/medicalrecord/data/MedicalRecordModel.dart';
import 'package:cortex/feature/medicalrecord/presentation/state/medical_records_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../core/const/api_const.dart';
import '../../../../core/utils/PrintCont.dart';

class MedicalRecordsCubit extends Cubit<MedicalRecordsState> {

  List<MedicalRecordModel> response_body = []; // Initialize as empty list, not nullable

  MedicalRecordsCubit() : super(OnInitialMedicalRecordsState());



  Future<void> getPatientMedicalRecords(int id) async {
    emit(OnInitialMedicalRecordsState());
    print('Fetching from: ${ApiConst.get_patients_medical_records}');

    try {
      Uri uri = Uri.parse('${ApiConst.get_patients_medical_records}$id');
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> result =
        decoded is List ? decoded : (decoded['data'] ?? []);

        PrintCont.success('Raw response received (${result.length} items)');

        final List<MedicalRecordModel> appointments = [];

        for (var item in result) {
          if (item == null) continue;
          if (item['doctor'] == null) {
            PrintCont.warning('Skipping appointment without doctor: ${item['appointmentId']}');
            continue;
          }
          try {
            final model = MedicalRecordModel.fromJson(item);
            appointments.add(model);
          } catch (e) {
            PrintCont.error('Error parsing appointment: $e');
          }
        }

        response_body = appointments;
        PrintCont.success('Total appointments loaded: ${response_body.length}');
        emit(OnLoadedMedicalRecordsState(medicalRecordModel: response_body));
      } else {
        PrintCont.error('HTTP Error: ${response.statusCode}');
        emit(OnErrorMedicalRecordsState('HTTP ${response.statusCode}'));
      }
    } catch (e) {
      PrintCont.error('Exception: $e');
      emit(OnErrorMedicalRecordsState(e.toString()));
    }
  }
}