import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nirogh/Screens/cart_screen.dart';
import 'package:nirogh/Screens/home_screen.dart';
import 'package:nirogh/Screens/paid-booking-confirmation.dart';
import 'package:nirogh/firebase_options.dart';

import 'Screens/booking-confirmed.dart';
import 'Screens/chatbot_screen.dart';
import 'Screens/post_splash_screen.dart';
import 'Screens/phone_verify.dart';
import 'Screens/razorpay-screen.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
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
      // home: SplashScreen(),
      home: HomeScreen(),
    );
  }
}

