import 'product_model.dart';

class CartItem {
  final int id;
  final Product product;
  int quantity; // Removed final to allow modification

  CartItem({required this.id, required this.product, required this.quantity});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? 0, // id нь null бол 0 гэж авна
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : Product
              .defaultProduct(), // Хэрэв product нь null бол default бүтээгдэхүүн ашиглах
      quantity: json['quantity'] ?? 0, // quantity нь null бол 0
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'product': product.toJson(), 'quantity': quantity};
  }
}
