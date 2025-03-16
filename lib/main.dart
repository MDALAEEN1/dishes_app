import 'package:calaroiscount/auth/loginPage.dart';
import 'package:calaroiscount/auth/user_info_page.dart';
import 'package:calaroiscount/firebase_options.dart';
import 'package:calaroiscount/frontend/screens/account/helppage.dart';
import 'package:calaroiscount/frontend/screens/account/notificationspage.dart';
import 'package:calaroiscount/frontend/screens/account/privacypage.dart';
import 'package:calaroiscount/frontend/screens/account/profilepage.dart';

import 'package:calaroiscount/frontend/screens/splash/welcomepage.dart';
import 'package:calaroiscount/frontend/widgets/bottompar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'frontend/screens/searchpages/searchfood.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'CustomFont', // تحديد الخط المخصص للتطبيق بالكامل
        ),
        home: WelcomePage(),
        routes: {
          '/Profile-page': (context) => ProfilePage(),
          '/Notifications-page': (context) => NotificationsPage(),
          '/Privacy-page': (context) => PrivacyPage(),
          '/Help-page': (context) => HelpPage(),
          '/login-page': (context) => LoginPage(),
        });
  }
}
