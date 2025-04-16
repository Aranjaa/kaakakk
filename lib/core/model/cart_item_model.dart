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
    // Check if the product key is present and not null
    var productJson = json['product'];
    if (productJson == null) {
      throw Exception("Product data is missing from cart item");
    }

    return CartItem(
      id: json['id'] ?? 0, // Default to 0 if id is null
      quantity: json['quantity'] ?? 1, // Default to 1 if quantity is null
      product: Product(
        id: productJson['id'] ?? 0, // Default to 0 if product id is null
        name:
            productJson['name'] ?? 'Unknown Product', // Default if name is null
        description: productJson['description'] ?? '', // Default empty string
        price: productJson['price'] ?? 0.0, // Default to 0.0 if price is null
        stock: productJson['stock'] ?? 0, // Default to 0 if stock is null
        image:
            productJson['image'] ?? '', // Default empty string if image is null
        category: productJson['category'] != null
            ? Category.fromJson(productJson['category'])
            : Category(id: 0, name: 'Unknown'), // Safely handle category null
        subcategory: productJson['subcategory'] != null
            ? Subcategory.fromJson(productJson['subcategory'])
            : Subcategory(
                id: 0, name: 'Unknown'), // Safely handle subcategory null
        rating: productJson['rating'] ?? 0.0, // Default to 0 if rating is null
        reviews:
            productJson['reviews'] ?? 0, // Default to 0 if reviews are null
        isCheck: productJson['isCheck'] ??
            false, // Default to false if isCheck is null
        color: (productJson['color'] != null && productJson['color'] is List)
            ? List<String>.from(productJson['color'])
            : [], // Ensure color is a list, fallback to empty list if not
        size: (productJson['size'] != null && productJson['size'] is List)
            ? List<String>.from(productJson['size'])
            : [], // Ensure size is a list, fallback to empty list if not
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
