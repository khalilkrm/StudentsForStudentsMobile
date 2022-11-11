import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/apis/horairix_api.dart';
import 'package:student_for_student_mobile/apis/user_api.dart';
import 'package:student_for_student_mobile/repositories/horairix_repository.dart';
import 'package:student_for_student_mobile/repositories/user_repository.dart';
import 'package:student_for_student_mobile/stores/calendar_store.dart';
import 'package:student_for_student_mobile/stores/nav_store.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';
import 'package:student_for_student_mobile/views/pages/authentication_page.dart';
import 'package:student_for_student_mobile/views/pages/calendar_page.dart';
import 'package:student_for_student_mobile/views/pages/chat_page.dart';
import 'package:student_for_student_mobile/views/pages/home_page.dart';
import 'package:student_for_student_mobile/views/pages/profile_page.dart';
import 'package:student_for_student_mobile/views/pages/requests_page.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

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

  userApi.setUserRepository(userRepository);
  userApi.setHorairixRepository(horairixRepository);
  horairixApi.setUserRepository(userRepository);

  // stores
  final UserStore userStore = UserStore(
    userRepository: userRepository,
    googleSignIn: GoogleSignIn(scopes: scopes),
  );
  final CalendarStore calendarStore =
  CalendarStore(horairixRepository: horairixRepository);

  final NavStore navStore = NavStore();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => userStore),
      ChangeNotifierProvider(create: (_) => calendarStore),
      ChangeNotifierProvider(create: (_) => navStore)
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        SfGlobalLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        // ... other locales the app supports
      ],
      locale: const Locale('fr'),
      //
      title: 'Students for Students',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color(0xFF5D7052),
        ),
      ),
      home: Scaffold(body: Consumer<UserStore>(
        builder: (context, userStore, child) {
          if (userStore.user == null) {
            return AuthenticationPage();
          } else {
            return Consumer<NavStore>(
              builder: (context, navStore, child) {
                switch (navStore.currentIndex) {
                  case 0:
                    return const RequestsPage();
                  case 1:
                    return const ChatPage();
                  case 2:
                    return const HomePage();
                  case 3:
                    return const ProfilePage();
                  case 4:
                    return const CalendarPage();
                  default:
                    return const Text('Default');
                }
              },
            );
          }
        },
      )),
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
