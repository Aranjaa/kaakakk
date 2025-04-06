import 'category_model.dart'; // Import Category model
import 'subcategory_model.dart'; // Import Subcategory model

class Product {
  final String name;
  final String description;
  final double price;
  final int stock;
  final String imageUrl;
  final Category category;
  final Subcategory subcategory;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.category,
    required this.subcategory,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? 'Unnamed', // Providing default value
      description:
          json['description'] ?? 'No description', // Providing default value
      price:
          (json['price'] as num).toDouble(), // Ensure it's treated as a double
      stock: json['stock'] ?? 0, // Default to 0 if no stock value exists
      imageUrl: json['image'] ?? '', // Fallback for image URL
      category: Category.fromJson(json['category']),
      subcategory: Subcategory.fromJson(json['subcategory']),
    );
  }
}
