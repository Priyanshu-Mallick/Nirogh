import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nirogh/Screens/home_screen.dart';

import '../Widgets/bottom_navigation.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int _selectedIndex = 2; // Set the default selected index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaations'),
        backgroundColor: Colors.cyan[300],
        leading: IconButton(
          icon: Icon(CupertinoIcons.arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/Assets/bell.png',
              width: 150, // Adjust the width as needed
              height: 150, // Adjust the height as needed
            ),
            SizedBox(height: 20),
            Text(
              'It\'s a bit lonely around here!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
            ),
            SizedBox(height: 15),
            Text(
              'The notifications you receive will appear in this section',
              style: TextStyle(fontSize: 14, color: CupertinoColors.inactiveGray),
            ),
          ],
        ),
      ),
    );
  }
}
