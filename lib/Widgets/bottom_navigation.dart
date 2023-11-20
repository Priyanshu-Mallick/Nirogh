import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nirogh/Screens/bookings_screen.dart';
import 'package:nirogh/Screens/cart_screen.dart';
import 'package:nirogh/Screens/chatbot_screen.dart';
import 'package:nirogh/Screens/home_screen.dart';

import '../services/manage_cart.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  final int initialIndex; // Add this variable

  // final List<CartItem> cartItems = [];

  BottomNavigationBarWidget({required this.initialIndex}); // Provide a default value
  @override
  _BottomNavigationBarWidgetState createState() =>
      _BottomNavigationBarWidgetState(initialIndex: initialIndex);
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex=0; // Add this variable
  // Constructor
  _BottomNavigationBarWidgetState({required int initialIndex}) {
    _selectedIndex = initialIndex;
  }
  // List of screens to navigate to based on the index
  final List<Widget> _screens = [
    HomeScreen(),
    BookingScreen(),
    CartScreen(),
    ChatbotScreen(),
  ];


  // Function to change the screen based on the selected index
  void _changeScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => _screens[index],
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Slide from right
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30.0), // Adjust the radius as needed
        topRight: Radius.circular(30.0), // Adjust the radius as needed
      ),
      child: BottomAppBar(
        color: Colors.cyan,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        elevation: 30,
        height: 65, // Increased the height to accommodate the text
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
      ),
    );
  }

  Widget buildNavigationItem(IconData iconData, String label, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        if (!isSelected) {
          _changeScreen(index); // Call the function to change the screen only if it's not already selected
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 70, // Set the size of the touchable area
            height: 30, // Set the size of the touchable area
            child: Icon(
              iconData,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
        ],
      ),
    );
  }
}
