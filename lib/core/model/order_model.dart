import 'order_item_model.dart';

class Order {
  final int id;
  final String user;
  final String status;
  final String totalPrice;
  final String createdAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.user,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'],
    user: json['user'],
    status: json['status'],
    totalPrice: json['total_price'],
    createdAt: json['created_at'],
    items:
        (json['items'] as List)
            .map((item) => OrderItem.fromJson(item))
            .toList(),
  );
}
