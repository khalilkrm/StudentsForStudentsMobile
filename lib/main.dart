import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:student_for_student_mobile/apis/firebase_api.dart';
import 'package:student_for_student_mobile/apis/google_map_api.dart';
import 'package:student_for_student_mobile/apis/home_api.dart';
import 'package:student_for_student_mobile/apis/horairix_api.dart';
import 'package:student_for_student_mobile/apis/request_api.dart';
import 'package:student_for_student_mobile/apis/user_api.dart';
import 'package:student_for_student_mobile/repositories/chat_repository.dart';
import 'package:student_for_student_mobile/repositories/home_repository.dart';
import 'package:student_for_student_mobile/repositories/horairix_repository.dart';
import 'package:student_for_student_mobile/repositories/request_repository.dart';
import 'package:student_for_student_mobile/repositories/user_repository.dart';
import 'package:student_for_student_mobile/stores/calendar_store.dart';
import 'package:student_for_student_mobile/stores/chat_store.dart';
import 'package:student_for_student_mobile/stores/home_store.dart';
import 'package:student_for_student_mobile/stores/map_store.dart';
import 'package:student_for_student_mobile/stores/nav_store.dart';
import 'package:student_for_student_mobile/stores/request_store.dart';
import 'package:student_for_student_mobile/stores/user_store.dart';
import 'package:student_for_student_mobile/views/pages/authentication_page.dart';
import 'package:student_for_student_mobile/views/pages/calendar_page.dart';
import 'package:student_for_student_mobile/views/pages/chat_page.dart';
import 'package:student_for_student_mobile/views/pages/home_page.dart';
import 'package:student_for_student_mobile/views/pages/profile_page.dart';
import 'package:student_for_student_mobile/views/pages/requests_page.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  HttpOverrides.global = MyHttpOverrides();

  // google oauth openid scopes
  List<String> scopes = <String>["email"];

  // apis
  final UserApi userApi = UserApi();
  final HorairixApi horairixApi = HorairixApi();
  final RequestApi requestApi = RequestApi();
  final HomeApi homeApi = HomeApi();
  final GoogleMapApi googleMapApi = GoogleMapApi();
  final FirebaseApi firebaseApi = FirebaseApi();

  // repositories
  final UserRepository userRepository = UserRepository(userApi: userApi);
  final HorairixRepository horairixRepository =
      HorairixRepository(horairixApi: horairixApi);
  final RequestRepository requestRepository =
      RequestRepository(requestApi: requestApi);
  final HomeRepository homeRepository = HomeRepository(homeApi: homeApi);
  final ChatRepository chatRepository = ChatRepository(api: firebaseApi);

  userApi.setUserRepository(userRepository);
  userApi.setHorairixRepository(horairixRepository);
  horairixApi.setUserRepository(userRepository);
  requestApi.setUserRepository(userRepository);
  homeApi.setUserRepository(userRepository);

  // stores
  final UserStore userStore = UserStore(
    userRepository: userRepository,
    googleSignIn: GoogleSignIn(scopes: scopes),
  );

  final CalendarStore calendarStore =
      CalendarStore(horairixRepository: horairixRepository);

  final NavStore navStore = NavStore();

  final RequestStore requestStore =
      RequestStore(requestRepository: requestRepository, userStore: userStore);

  final HomeStore homeStore =
      HomeStore(homeRepository: homeRepository, userStore: userStore);

  final MapStore mapStore = MapStore(api: googleMapApi);

  final ChatStore chatStore = ChatStore(repository: chatRepository);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => userStore),
      ChangeNotifierProvider(create: (_) => calendarStore),
      ChangeNotifierProvider(create: (_) => navStore),
      ChangeNotifierProvider(create: (_) => requestStore),
      ChangeNotifierProvider(create: (_) => homeStore),
      ChangeNotifierProvider(create: (_) => mapStore),
      ChangeNotifierProvider(create: (_) => chatStore),
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
