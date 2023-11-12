import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nirogh/Screens/drawer_content.dart';
import 'package:nirogh/Widgets/bottom_navigation.dart';
import 'package:nirogh/Widgets/horizontal_card1.dart';
import 'package:nirogh/Widgets/popular_lab.dart';
import 'package:nirogh/Widgets/popular_test.dart';

import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  double? lat;
  double? long;
  String address = '';
  String sAdd = '';
  String? userName = "";

  @override
  void initState() {
    super.initState();
    getLatLong();
    _fetchUserData();
  }

  String _getGreetingMessage() {
    final currentTime = DateTime.now();
    String greeting = 'Good ';

    if (currentTime.hour >= 0 && currentTime.hour < 12) {
      greeting += 'Morning';
    } else if (currentTime.hour >= 12 && currentTime.hour < 17) {
      greeting += 'Afternoon';
    } else {
      greeting += 'Evening';
    }

    return greeting;
  }


  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('user').doc(user.uid);
      final userSnapshot = await userRef.get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.data();
        setState(() {
          userName = userData?['fullName'] ?? '';
        });
      }
    }
  }
  void getLatLong() async {
    Position position;
    try {
      position = await _determinePosition();
      setState(() {
        lat = position.latitude;
        long = position.longitude;
      });
      updateText();
    } catch (error) {
      print("Error $error");
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied, we cannot request permissions.';
      }

      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  void updateText() async {
    if (lat != null && long != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat!, long!);
      setState(() {
        address =
        '${placemarks[0].street}, ${placemarks[0].subLocality}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}, ${placemarks[0].postalCode}';
        sAdd = '${placemarks[0].locality}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.cyan));

    int notificationCount = 5; // Replace this with the actual number of notifications

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(CupertinoIcons.square_grid_2x2),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            sAdd.isNotEmpty ? sAdd : 'Home', // Show location if available, otherwise show 'Home'
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (sAdd.isNotEmpty)
                            const Padding(
                              padding: EdgeInsets.only(left: 1.0),
                              child: Icon(CupertinoIcons.location_solid),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(CupertinoIcons.bell_fill),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => Notifications(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      if (notificationCount > 0)
                        Positioned(
                          top: 8,
                          right: 12,
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            child: Text(
                              notificationCount.toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName != null
                        ? 'Hi ${userName?.split(' ').first}!'
                        : 'Welcome!',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      _getGreetingMessage(),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey[300],
                ),
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(CupertinoIcons.search),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 5, // Replace this with the actual number of elements you want to add (10 + 1 for the HorizontalCard)
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // The first item in the list
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                      child: HorizontalCard(),
                    );
                  } else if (index == 1) {
                    // The second item in the list (Popular Labs section)
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                      child: PopularLabsWidget(),
                    );
                  } else if (index == 2) {
                    // The thired item in the list (Popular Tests section)
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                      child: PopularTestsWidget(),
                    );
                  }
                  else {
                    // The rest of the list items
                    return ListTile(
                      title: Text('Item ${index}'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      drawer: const Drawer(
        child: DrawerContent(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Code to execute on button press
        },
        elevation: 10,
        backgroundColor: Colors.black,
        child: const Icon(Icons.call,color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBarWidget(initialIndex: _selectedIndex),
    );
  }
}
