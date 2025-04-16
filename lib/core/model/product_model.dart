import 'category_model.dart';
import 'subcategory_model.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final num price;
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
  // Default Product method
  factory Product.fromJson(Map<String, dynamic> json) {
    num parsedPrice = json['price'] != null
        ? num.tryParse(json['price'].toString()) ?? 0.0
        : 0.0;

    double parsedRating = json['rating'] != null
        ? double.tryParse(json['rating'].toString()) ?? 0.0
        : 0.0;

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: parsedPrice,
      stock: json['stock'] ?? 0,
      image: json['image'] ?? '',
      category: json['category'] is Map
          ? Category.fromJson(json['category'])
          : Category(id: json['category'] ?? 0, name: ''),
      subcategory: json['subcategory'] is Map
          ? Subcategory.fromJson(json['subcategory'])
          : Subcategory(id: json['subcategory'] ?? 0, name: ''),
      rating: parsedRating,
      reviews: json['reviews'] ?? 0,
      isCheck: json['isCheck'] ?? false,
      color: List<String>.from(json['color'] ?? []),
      size: List<String>.from(json['size'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'image': image,
      'category': category.toJson(),
      'subcategory': subcategory.toJson(),
      'rating': rating,
      'reviews': reviews,
      'isCheck': isCheck,
      'color': color,
      'size': size,
    };
  }
}
