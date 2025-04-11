import 'cart_item_model.dart';

class Cart {
  final int id;
  final String user;
  final List<CartItem> items;
  final DateTime createdAt;

  Cart({
    required this.id,
    required this.user,
    required this.items,
    required this.createdAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      user: json['user'],
      items:
          (json['items'] as List)
              .map((item) => CartItem.fromJson(item))
              .toList(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
