import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/apis/user_api.dart';
import 'package:student_for_student_mobile/repositories/user_repository.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';
import 'package:student_for_student_mobile/views/pages/authentication_page.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();

  // google oaauth openid scopes
  List<String> scopes = <String>["email"];

  // apis
  final UserApi userApi = UserApi();

  // repositories
  final UserRepository userRepository = UserRepository(userApi: userApi);

  // stores
  final UserStore userStore = UserStore(
    userRepository: userRepository,
    googleSignIn: GoogleSignIn(scopes: scopes),
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => userStore,
      )
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(body: AuthenticationPage()),
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
