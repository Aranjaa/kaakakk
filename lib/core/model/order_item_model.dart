import 'product_model.dart';

class OrderItem {
  final int id;
  final Product product;
  final int quantity;
  final String price;

  OrderItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json['id'],
    product: Product.fromJson(json['product']),
    quantity: json['quantity'],
    price: json['price'],
  );
}
