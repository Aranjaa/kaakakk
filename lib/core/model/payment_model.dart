import 'order_model.dart';

class Payment {
  final int id;
  final Order order;
  final String method;
  final bool status;
  final String transactionId;
  final String createdAt;

  Payment({
    required this.id,
    required this.order,
    required this.method,
    required this.status,
    required this.transactionId,
    required this.createdAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    id: json['id'],
    order: Order.fromJson(json['order']),
    method: json['method'],
    status: json['status'],
    transactionId: json['transaction_id'],
    createdAt: json['created_at'],
  );
}
