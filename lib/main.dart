import 'package:flutter/material.dart';
import 'package:map_meters_marker/cubits/history_cubit/cubit/history_cubit_cubit.dart';
import 'package:map_meters_marker/cubits/map_cubit.dart';
import 'package:map_meters_marker/models/DataBase.dart';
import 'package:map_meters_marker/view/history_view.dart';
import 'package:map_meters_marker/view/login_view.dart';
import 'package:map_meters_marker/view/map_view.dart';
import 'package:map_meters_marker/view/signup_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.createDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MapCubit(),
        ),
        BlocProvider(
          create: (context) => HistoryCubit(),
        ),
      ],
      child: MaterialApp(
        // initialRoute: SharedPreferencesHelper.getBoolValue(key: "LOGIN") == true
        //   ? MapView.route
        // : LoginView.route,
        initialRoute: LoginView.route,
        routes: {
          MapView.route: (context) => MapView(),
          SignupView.route: (context) => SignupView(),
          LoginView.route: (context) => LoginView(),
          HistoryView.route: (context) => HistoryView(),
        },
      ),
    );
  }
}
