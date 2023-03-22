import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:miniq/Screens/UserScreens/FeedScreen/FeedPage.dart';
import 'package:miniq/Screens/UserScreens/LoginScreen/splash_screen.dart';
import 'package:miniq/Screens/test_page.dart';
import 'package:miniq/test.dart';
import 'Screens/UserScreens/CmpltRegistration/complaint_list.dart';
import 'Screens/UserScreens/LoginScreen/login_screen.dart';
import 'Screens/UserScreens/ProfileScreen/dashboard_profile.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: LoginScreen(),
      // home: TestDemo(),
      home: SplashScreen(),
      // home: BottomNavigation(),
    );
  }
}
