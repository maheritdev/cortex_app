import 'dart:convert';

import 'package:cortex/core/utils/PrintCont.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../../../core/const/api_const.dart';
import '../../../../core/utils/shared_preferences_helper.dart';
import '../../data/model/Patient_model.dart';
import '../state/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  PatientModel? response_body;

  LoginCubit() : super(OnInitialLoginState());
  _initializeApp() async {
    await SharedPreferencesHelper.init();
  }

  void _saveData(
      int patientID,
      String Name,
      String contactNumber,
      String email,
      String address,
      String token,bool isLoggedIn) async {
    await SharedPreferencesHelper.setInt("patientID", patientID);
    await SharedPreferencesHelper.setString("user_name", Name);
    await SharedPreferencesHelper.setString("contactNumber", contactNumber);
    await SharedPreferencesHelper.setString("email", email);
    await SharedPreferencesHelper.setString("address", address);
    await SharedPreferencesHelper.setString("address", token);
    await SharedPreferencesHelper.setBool("isLoggedIn", isLoggedIn);
  }
  Future<void> login({required String username, required String password}) async {
    _initializeApp();

    emit(OnLoadingLoginState());
    print(ApiConst.Login);
    try {
      final body = {"username": username, "password": password};
      final response = await http.post(
        Uri.parse(ApiConst.Login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        response_body = PatientModel.fromJson(result);

        PrintCont.network(response.statusCode);

        String? token = response_body!.token;
        int? patientID = response_body!.patient.patientID;
        String? userName = "${response_body!.patient.firstName} ${response_body!.patient.lastName}";
        String? email = response_body!.patient.email;
        String? address = response_body!.patient.address;
        String? contactNumber = response_body!.patient.contactNumber;
        PrintCont.success(token);
        _saveData(patientID,userName,contactNumber,email,address,token,true);
        var x= await SharedPreferencesHelper.getBool("isLoggedIn");
        PrintCont.success("Logged in $x");
        emit(OnLoadedLoginState(patientModel: response_body!));
      } else {
        PrintCont.error(response.statusCode.toString());

        emit(OnErrorLoginState(response.statusCode.toString()));
      }
    } catch (e) {
      print(e.toString());
      PrintCont.error(e.toString());
      emit(OnErrorLoginState(e.toString()));
    }
  }
}
