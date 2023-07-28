import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nirogh/Screens/bookings_screen.dart';
import 'package:nirogh/Screens/cart_screen.dart';
import 'package:nirogh/Screens/chatbot_screen.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 0;

  // List of screens to navigate to based on the index
  final List<Widget> _screens = [
    BookingScreen(),
    CartScreen(),
    ChatbotScreen(),
  ];

  // Function to change the screen based on the selected index
  void _changeScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 6,
      elevation: 30,
      height: 70, // Increased the height to accommodate the text
      child: Row(
        // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          buildNavigationItem(CupertinoIcons.home, 'Home', 0),
          buildNavigationItem(CupertinoIcons.calendar, 'Book', 1),
          buildNavigationItem(CupertinoIcons.cart, 'Cart', 2),
          buildNavigationItem(CupertinoIcons.chat_bubble, 'Chat', 3),
        ],
      ),
    );
  }

  Widget buildNavigationItem(IconData iconData, String label, int index) {
    final isSelected = index == _selectedIndex;
    return InkWell(
      onTap: () {
        _changeScreen(index); // Call the function to change the screen
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 30, // Set the size of the touchable area
            height: 30, // Set the size of the touchable area
            child: Icon(
              iconData,
              color: isSelected ? Colors.cyan : Colors.black,
            ),
          ),
          Text(label, style: TextStyle(color: isSelected ? Colors.cyan : Colors.black)),
        ],
      ),
    );
  }
}