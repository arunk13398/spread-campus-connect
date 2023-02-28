import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:miniq/Screens/UserScreens/FeedScreen/FeedPage.dart';
import 'package:miniq/Screens/UserScreens/LoginScreen/splash_screen.dart';
import 'package:miniq/Screens/test_page.dart';
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
      // home: FeedPage(),
      // home: TestPage(),
      home: SplashScreen(),
      // home: BottomNavigation(),
    );
  }
}
