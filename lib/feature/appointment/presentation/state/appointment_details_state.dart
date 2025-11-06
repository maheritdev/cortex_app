import 'package:cortex/feature/appointment/data/appointment_details_model.dart';

abstract class AppointmentDetailsState {}

class OnInitialAppointmentDetailsState extends AppointmentDetailsState {}

class OnLoadingAppointmentDetailsState extends AppointmentDetailsState {}

class OnLoadedAppointmentDetailsState extends AppointmentDetailsState {
  final AppointmentDetailsModel? appointmentDetailsModel; // Remove nullable operator
  OnLoadedAppointmentDetailsState({required this.appointmentDetailsModel});
}

class OnErrorAppointmentDetailsState extends AppointmentDetailsState {
  final String errorMessage;
  OnErrorAppointmentDetailsState(this.errorMessage);
}