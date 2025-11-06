import 'package:cortex/feature/appointment/presentation/cubit/appointment_cubit.dart';
import 'package:cortex/feature/appointment/presentation/cubit/appointment_details_cubit.dart';
import 'package:cortex/feature/billing/presentation/cubit/billing_cubit.dart';
import 'package:cortex/feature/medicalrecord/presentation/cubit/medical_records_cubit.dart';
import 'package:cortex/feature/pharmacy/presentation/cubit/inventory_cubit.dart';
import 'package:cortex/feature/profile/presentation/cubit/profile_cubit.dart';
import 'package:cortex/feature/rooms/presentation/cubit/room_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/utils/PrintCont.dart';
import 'core/utils/shared_preferences_helper.dart';
import 'feature/auth/presentation/cubit/login_cubit.dart';
import 'feature/auth/presentation/view/login/login_screen.dart';
import 'feature/btm_navigation/bottom_navigation_screen.dart';
import 'feature/laborders/presentation/cubit/lab_orders_cubit.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  await SharedPreferencesHelper.init();
  final isLoggedIn = await SharedPreferencesHelper.isLoggedIn;
  var x= await SharedPreferencesHelper.getBool("isLoggedIn");
  PrintCont.success("Logged in main $x");
  runApp(MyApp(isLoggedIn : isLoggedIn,));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key,required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
            create: (context) => LoginCubit()
        ),BlocProvider<AppointmentCubit>(
            create: (context) => AppointmentCubit()
        ),BlocProvider<AppointmentDetailsCubit>(
            create: (context) => AppointmentDetailsCubit()
        ),BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit()
        ),BlocProvider<MedicalRecordsCubit>(
            create: (context) => MedicalRecordsCubit()
        ),BlocProvider<RoomCubit>(
            create: (context) => RoomCubit()
        ),BlocProvider<BillingCubit>(
            create: (context) => BillingCubit()
        ),BlocProvider<LabOrdersCubit>(
            create: (context) => LabOrdersCubit()
        ),BlocProvider<InventoryCubit>(
            create: (context) => InventoryCubit()
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        ),
        home: isLoggedIn ? BottomNavigationScreen() : LoginScreen(),
      ),
    );
  }

}