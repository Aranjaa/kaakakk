import 'package:flutter/material.dart';
import '../../core/model/product_model.dart'; // Таны бүтээгдэхүүний model

class FavoriteProvider with ChangeNotifier {
  List<Product> _favoriteItems = []; // Таалагдсан бүтээгдэхүүнүүдийн жагсаалт

  List<Product> get favoriteItems => _favoriteItems;

  // Бүтээгдэхүүн таалагдсан гэж тэмдэглэх
  void addToFavorites(Product product) {
    if (!_favoriteItems.contains(product)) {
      _favoriteItems.add(product);
      notifyListeners();
    }
  }

  // Бүтээгдэхүүн таалагдсан гэж тэмдэглэх
  void removeFromFavorites(Product product) {
    _favoriteItems.remove(product);
    notifyListeners();
  }
}
