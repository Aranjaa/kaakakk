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
  final List<String> color;
  final List<String> size;

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
    required this.color,
    required this.size,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0, // Fallback to 0 if 'id' is null
      name: json['name'] ?? '', // Fallback to empty string if 'name' is null
      description:
          json['description'] ??
          '', // Fallback to empty string if 'description' is null
      price: json['price'] ?? '0.0', // Fallback to '0.0' if 'price' is null
      stock: json['stock'] ?? 0, // Fallback to 0 if 'stock' is null
      image: json['image'] ?? '', // Fallback to empty string if 'image' is null
      category: Category.fromJson(
        json['category'] ?? {},
      ), // Ensure category is not null
      subcategory: Subcategory.fromJson(
        json['subcategory'] ?? {},
      ), // Ensure subcategory is not null
      rating:
          (json['rating'] != null && json['rating'] is double)
              ? json['rating'].toDouble()
              : 0.0, // Ensure rating is a valid double
      reviews: json['reviews'] ?? 0, // Fallback to 0 if 'reviews' is null
      isCheck:
          json['isCheck'] ?? false, // Fallback to false if 'isCheck' is null
      color: List<String>.from(
        json['color'] ?? [],
      ), // Fallback to empty list if 'color' is null
      size: List<String>.from(
        json['size'] ?? [],
      ), // Fallback to empty list if 'size' is null
    );
  }
}
