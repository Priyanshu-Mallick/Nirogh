import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nirogh/Screens/drawer_content.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Code to execute on button press
        },
        child: Icon(Icons.call),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.book, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.shop, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.people, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          Container(), // Home screen
          Container(), // Bookings screen
          Container(), // Call screen
          Container(), // Cart screen
          Container(), // Profile screen
        ],
      ),
    );
  }
}
