import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nirogh/Screens/profile_setup.dart';
import 'package:nirogh/Screens/user_registration.dart';
import 'package:nirogh/firebase_options.dart';
import 'package:nirogh/services/auth_service.dart';
import 'package:video_player/video_player.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('lib/Assets/splash_anim.mp4')
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
          _controller.play();
        });
      })
      ..setVolume(0.0);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-1.0, 0.0),
    ).animate(_animationController);

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        _animationController.forward().then((_) async {
          bool isLoggedIn = await AuthService.isLoggedIn();
          if (isLoggedIn) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else {
            _navigateToNextScreen();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SlidableFlashScreens(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          if (_isInitialized)
            SlideTransition(
              position: _slideAnimation,
              child: Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size?.width ?? 0,
                      height: _controller.value.size?.height ?? 0,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              ),
            ),
          if (!_isInitialized)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

class FlashScreen extends StatelessWidget {
  final String imagePath;
  final String quote;
  final bool showBackwardButton;

  const FlashScreen({
    required this.imagePath,
    required this.quote,
    required this.showBackwardButton,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double quoteFontSize = screenWidth * 0.05;
    double padding = screenWidth * 0.5;

    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: padding),
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
            Padding(
              padding: EdgeInsets.symmetric(),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  quote,
                  style: TextStyle(
                    fontSize: quoteFontSize,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 20),
            if (showBackwardButton)
              IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class SlidableFlashScreens extends StatefulWidget {
  @override
  _SlidableFlashScreensState createState() => _SlidableFlashScreensState();
}

class _SlidableFlashScreensState extends State<SlidableFlashScreens> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              FlashScreen(
                imagePath: 'lib/Assets/Flash 1.png',
                quote: '24 X 7 medical support and health care is a call away from you',
                showBackwardButton: false,
              ),
              FlashScreen(
                imagePath: 'lib/Assets/Flash 2.png',
                quote: '100 percent accurate result with numerous tests under reasonable price',
                showBackwardButton: true,
              ),
              FlashScreen(
                imagePath: 'lib/Assets/Flash 3.png',
                quote: 'Find your phlebotomist at your doorstep anytime',
                showBackwardButton: true,
              ),
            ],
          ),
          Positioned(
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenWidth * 0.04,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  width: 10,
                  height: 10,
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Color(0xFF2ED6ED) : Colors.grey,
                  ),
                );
              }),
            ),
          ),
          Positioned(
            right: screenWidth * 0.04,
            bottom: screenWidth * 0.04,
            child: FloatingActionButton(
              backgroundColor: Color(0xFF2ED6ED),
              onPressed: () {
                if (_currentPage < 2) {
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                } else {
                  Navigator.of(context).pushReplacement(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          UserRegistration(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;

                        var tween =
                        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                }
              },
              child: Icon(Icons.arrow_forward),
            ),
          ),
          if (_currentPage > 0)
            Positioned(
              left: screenWidth * 0.04,
              bottom: screenWidth * 0.04,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF2ED6ED),
                onPressed: () {
                  _pageController.previousPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
                child: Icon(Icons.arrow_back),
              ),
            ),
        ],
      ),
    );
  }
}