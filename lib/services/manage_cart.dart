import 'package:flutter/cupertino.dart';

import 'cart_item_class.dart';

class CartModel extends ChangeNotifier {
  List<CartItem> cartItems = [];

  void addCartItem(String testName, double testPrice) {
    cartItems.add(CartItem(testName, testPrice, isAdded: true));
    notifyListeners();
  }
}
