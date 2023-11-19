import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Screens/cart_screen.dart';
import '../Widgets/popular_test.dart';
import 'manage_cart.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<CartItem> cartItems = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PageView(
          children: [
            PopularTestsWidget(
              onBookNowClick: (testName, testPrice) {
                setState(() {
                  cartItems.add(CartItem(testName, testPrice));
                });
              },
            ),
            CartScreen(cartItems: cartItems),
          ],
        ),
      ),
    );
  }
}
