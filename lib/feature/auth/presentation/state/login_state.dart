import '../../data/model/Patient_model.dart';

abstract class LoginState {}

class OnInitialLoginState extends LoginState {}

class OnLoadingLoginState extends LoginState {}

class OnLoadedLoginState extends LoginState {
  PatientModel patientModel;
  OnLoadedLoginState({required this.patientModel});
}

class OnErrorLoginState extends LoginState {
  final String errorMessage;

  OnErrorLoginState(this.errorMessage);
}