import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      shape: CircularNotchedRectangle(),
      notchMargin: 6,
      elevation: 30,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(CupertinoIcons.home, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(CupertinoIcons.calendar, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(CupertinoIcons.cart, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(CupertinoIcons.chat_bubble_text, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
