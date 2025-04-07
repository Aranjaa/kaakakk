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

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.image,
    required this.category,
    required this.subcategory,
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
    );
  }
}
