
import 'package:cortex/feature/appointment/data/appointment_model.dart';

abstract class AppointmentState {}

class OnInitialAppointmentState extends AppointmentState {}

class OnLoadingAppointmentState extends AppointmentState {}

class OnLoadedAppointmentState extends AppointmentState {
  final List<AppointmentModel> appointmentModel; // Remove nullable operator
  OnLoadedAppointmentState({required this.appointmentModel});
}

class OnErrorAppointmentState extends AppointmentState {
  final String errorMessage;
  OnErrorAppointmentState(this.errorMessage);
}