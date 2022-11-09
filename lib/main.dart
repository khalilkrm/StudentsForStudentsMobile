import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/apis/horairix_api.dart';
import 'package:student_for_student_mobile/apis/user_api.dart';
import 'package:student_for_student_mobile/repositories/horairix_repository.dart';
import 'package:student_for_student_mobile/repositories/user_repository.dart';
import 'package:student_for_student_mobile/stores/calendar_store.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';
import 'package:student_for_student_mobile/views/pages/calendar_page.dart';

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();

  // google oauth openid scopes
  List<String> scopes = <String>["email"];

  // apis
  final UserApi userApi = UserApi();
  final HorairixApi horairixApi = HorairixApi();

  // repositories
  final UserRepository userRepository = UserRepository(userApi: userApi);
  final HorairixRepository horairixRepository =
      HorairixRepository(horairixApi: horairixApi);

  // stores
  final UserStore userStore = UserStore(
    userRepository: userRepository,
    googleSignIn: GoogleSignIn(scopes: scopes),
  );
  final CalendarStore calendarStore =
      CalendarStore(horairixRepository: horairixRepository);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => userStore),
      ChangeNotifierProvider(create: (_) => calendarStore)
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Scaffold(body: CalendarPage()),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
