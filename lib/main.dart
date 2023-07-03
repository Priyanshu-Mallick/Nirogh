import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nirogh/Screens/user_registration.dart';
import 'package:nirogh/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) => SplashScreensAndLogin(context: context),
      ),
    );
  }
}

class SplashScreensAndLogin extends StatefulWidget {
  final BuildContext context;

  const SplashScreensAndLogin({Key? key, required this.context});

  @override
  _SplashScreensAndLoginState createState() => _SplashScreensAndLoginState();
}

class _SplashScreensAndLoginState extends State<SplashScreensAndLogin> {

  List<Widget> splashScreens = [
    const SlidableSplashScreen(
      color: Colors.blue,
      text: 'Splash Screen 1',
    ),
    const SlidableSplashScreen(
      color: Colors.green,
      text: 'Splash Screen 2',
    ),
    const SlidableSplashScreen(
      color: Colors.red,
      text: 'Splash Screen 3',
      isLastScreen: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: const PageScrollPhysics(parent: ClampingScrollPhysics()),
        itemCount: splashScreens.length,
        itemBuilder: (context, index) {
          return splashScreens[index];
        },
        onPageChanged: (index) {
          setState(() {
            _currentScreenIndex = index;
          });
        },
      ),
    );
  }
}

class SlidableSplashScreen extends StatelessWidget {
  final Color color;
  final String text;
  final bool isLastScreen;

  const SlidableSplashScreen({
    Key? key,
    required this.color,
    required this.text,
    this.isLastScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ],
            ),
          ),
          if (isLastScreen)
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserRegistration()),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Continue'),
              ),
            ),
        ],
      ),
    );
  }
}

