import '../../data/MedicalRecordModel.dart';

class MedicalRecordsState {}

class OnInitialMedicalRecordsState extends MedicalRecordsState {}

class OnLoadingMedicalRecordsState extends MedicalRecordsState {}

class OnLoadedMedicalRecordsState extends MedicalRecordsState {
  final List<MedicalRecordModel> medicalRecordModel ; // Remove nullable operator
  OnLoadedMedicalRecordsState({required this.medicalRecordModel});
}

class OnErrorMedicalRecordsState extends MedicalRecordsState {
  final String errorMessage;
  OnErrorMedicalRecordsState(this.errorMessage);
}