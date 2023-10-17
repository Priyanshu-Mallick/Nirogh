import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nirogh/firebase_options.dart';

import 'Screens/chatbot_screen.dart';
import 'Screens/post_splash_screen.dart';
import 'Screens/phone_verify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nirogh',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: SplashScreen(),
    );
  }
}

