import 'dart:convert';

import 'package:cortex/feature/profile/data/profile_model.dart';
import 'package:cortex/feature/profile/presentation/state/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../core/const/api_const.dart';
import '../../../../core/utils/PrintCont.dart';
import '../../../auth/data/model/Patient_model.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileModel? response_body; // Initialize as empty list, not nullable

  ProfileCubit() : super(OnInitialProfileState());


  Future<void> getPatientsProfile(int id) async {
    emit(OnLoadingProfileState());
    print('Fetching from: ${ApiConst.get_patients_profile}');

    try {
      Uri uri = Uri.parse('${ApiConst.get_patients_profile}$id');
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        response_body = ProfileModel.fromJson(result);

        PrintCont.success('Total appointments loaded: ${response_body}');
        emit(OnLoadedProfileState(profileModel: response_body));
      } else {
        PrintCont.error('HTTP Error: ${response.statusCode}');
        emit(OnErrorProfileState('HTTP ${response.statusCode}'));
      }
    } catch (e) {
      PrintCont.error('Exception: $e');
      emit(OnErrorProfileState(e.toString()));
    }
  }
}