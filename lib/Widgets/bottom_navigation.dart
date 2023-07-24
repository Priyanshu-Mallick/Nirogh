import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
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
          buildNavigationItem(CupertinoIcons.home, 'Home'),
          // SizedBox(width: 15),
          buildNavigationItem(CupertinoIcons.calendar, 'Book'),
          const SizedBox(width: 15),
          buildNavigationItem(CupertinoIcons.cart, 'Cart'),
          // SizedBox(width: 15),
          buildNavigationItem(CupertinoIcons.chat_bubble_text, 'Chat'),
        ],
      ),
    );
  }

  Widget buildNavigationItem(IconData iconData, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 30, // Set the size of the touchable area
          height: 30, // Set the size of the touchable area
          child: IconButton(
            padding: EdgeInsets.zero, // Set the padding to zero
            icon: Icon(iconData, color: Colors.black),
            onPressed: () {},
          ),
        ),
        Text(label, style: TextStyle(color: Colors.black)),
      ],
    );
  }
}
