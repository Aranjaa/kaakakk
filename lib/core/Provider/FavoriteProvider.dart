import 'package:flutter/material.dart';
import '../../services/api_service.dart'; // Correct import path
import '../model/product_model.dart';
import '../model/wishlists_model.dart';

class FavoriteProvider with ChangeNotifier {
  // Use static access for fetchWishlist
  final ApiService apiController = ApiService();

  List<Wishlists> _favoriteItems = [];

  List<Wishlists> get favoriteItems => _favoriteItems;

  // Fetch favorite items (Only fetch user's favorites, not all products)
  Future<void> fetchFavorites() async {
    try {
      // Assuming fetchWishlist is a static method in ApiService
      List<Wishlists> wishlist = await ApiService.fetchWishlist();

      _favoriteItems =
          wishlist; // Directly assigning the wishlist to the _favoriteItems list
      notifyListeners();
    } catch (e) {
      print("Дуртай зүйлсийг татахад алдаа гарлаа: $e");
    }
  }

  // Check if the product is in the wishlist
  bool isProductInWishlist(Product product) {
    return _favoriteItems.any((item) => item.product.id == product.id);
  }

  // Add to wishlist
  void addToWishlist(Product product) {
    if (!isProductInWishlist(product)) {
      // Assume you have a way to get the user (e.g., from a global state or user session)
      String user = 'current_user'; // Replace with actual user logic
      int id = _favoriteItems.length + 1; // You can generate a unique ID here
      String addedAt =
          DateTime.now().toIso8601String(); // Current time as ISO string

      _favoriteItems.add(
        Wishlists(id: id, user: user, product: product, addedAt: addedAt),
      );
      notifyListeners();
    }
  }

  // Remove from wishlist
  void removeFromWishlist(Product product) {
    _favoriteItems.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }
}

// Wishlist item model
class WishlistItem {
  final Product product;

  WishlistItem({required this.product});
}
