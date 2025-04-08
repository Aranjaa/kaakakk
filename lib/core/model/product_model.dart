import 'category_model.dart';
import 'subcategory_model.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final String price;
  final int stock;
  final String image;
  final Category category;
  final Subcategory subcategory;
  final double rating;
  final int reviews;
  final bool isCheck;
  final List<String> color; // Added color
  final List<String> size; // Added size

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.image,
    required this.category,
    required this.subcategory,
    required this.rating,
    required this.reviews,
    required this.isCheck,
    required this.color, // Added color
    required this.size, // Added size
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      stock: json['stock'],
      image: json['image'],
      category: Category.fromJson(json['category']),
      subcategory: Subcategory.fromJson(json['subcategory']),
      rating: json['rating'],
      reviews: json['reviews'],
      isCheck: json['isCheck'],
      color: List<String>.from(json['color'] ?? []), // Parsing color list
      size: List<String>.from(json['size'] ?? []), // Parsing size list
    );
  }
}
