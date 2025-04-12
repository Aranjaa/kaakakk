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

  factory Product.fromJson(Map<String, dynamic> json) {
    num parsedPrice;
    // Хэрэв price талбар нь null бол 0.0
    if (json['price'] == null) {
      parsedPrice = 0.0;
    } else if (json['price'] is String) {
      // Хэрэв "price" string хэлбэртэй бол хөрвүүлнэ
      parsedPrice = num.tryParse(json['price']) ?? 0.0;
    } else if (json['price'] is num) {
      // Хэрэв харьцангуй тоон утга бол шууд авна
      parsedPrice = json['price'];
    } else {
      parsedPrice = 0.0;
    }

    // rating талбарын хувьд ижил арга хэрэглэж болно, хэрэв шаардлагатай бол
    double parsedRating;
    if (json['rating'] == null) {
      parsedRating = 0.0;
    } else if (json['rating'] is String) {
      parsedRating = double.tryParse(json['rating']) ?? 0.0;
    } else if (json['rating'] is num) {
      parsedRating = (json['rating'] as num).toDouble();
    } else {
      parsedRating = 0.0;
    }

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: parsedPrice,
      stock: json['stock'] ?? 0,
      image: json['image'] ?? '',
      category: Category.fromJson(json['category'] ?? {}),
      subcategory: Subcategory.fromJson(json['subcategory'] ?? {}),
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
