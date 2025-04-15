import 'package:flutter/material.dart';
import '../model/product_model.dart'; // Your Product model
import '../../views/Role_based_login/user/Screen/items_detail_screen/screen/cart_item.dart'; // Your CartItem model

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Add product to cart
  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(
        CartItem(product: product, quantity: 1),
      ); // Ensure quantity starts from 1
    }
    notifyListeners();
  }

  // Remove product from cart
  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  // Get total number of items in the cart
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  // Get total price of items in the cart
  double get totalPrice {
    return _items.fold(0.0, (sum, item) {
      return sum + item.product.price * item.quantity;
    });
  }
}
