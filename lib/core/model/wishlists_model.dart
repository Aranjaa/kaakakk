import 'product_model.dart';

class Wishlists {
  final int id;
  final String user;
  final Product product;
  final String addedAt;

  Wishlists({
    required this.id,
    required this.user,
    required this.product,
    required this.addedAt,
  });

  factory Wishlists.fromJson(Map<String, dynamic> json) => Wishlists(
    id: json['id'],
    user: json['user'],
    product: Product.fromJson(json['product']),
    addedAt: json['added_at'],
  );
}
