
import 'package:cortex/feature/appointment/data/appointment_model.dart';
import 'package:cortex/feature/profile/data/profile_model.dart';

abstract class ProfileState {}

class OnInitialProfileState extends ProfileState {}

class OnLoadingProfileState extends ProfileState {}

class OnLoadedProfileState extends ProfileState {
  final ProfileModel? profileModel; // Remove nullable operator
  OnLoadedProfileState({required this.profileModel});
}

class OnErrorProfileState extends ProfileState {
  final String errorMessage;
  OnErrorProfileState(this.errorMessage);
}