import 'product_model.dart';
import 'category_model.dart';
import 'subcategory_model.dart';

class CartItem {
  final int id;
  final Product product;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      quantity: json['quantity'],
      product: Product(
        id: json['product']['id'],
        name: json['product']['name'],
        description: json['product']['description'],
        price: json['product']['price'],
        stock: json['product']['stock'],
        image: json['product']['image'],
        category: Category.fromJson(
            json['product']['category']), // Create Category instance
        subcategory: Subcategory.fromJson(
            json['product']['subcategory']), // Create Subcategory instance
        rating: json['product']['rating'],
        reviews: json['product']['reviews'],
        isCheck: json['product']['isCheck'],
        color: List<String>.from(json['product']['color']),
        size: List<String>.from(json['product']['size']),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
    };
  }
}
