class CartItem {
  final String itemName;
  final double itemPrice;
  bool isAdded;

  CartItem(this.itemName, this.itemPrice, {this.isAdded = false});
}
