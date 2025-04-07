class Category {
  final int id;
  final String name;
  final String description;

  Category({required this.id, required this.name, required this.description});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0, // Default to 0 if 'id' is null
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }
}

class Subcategory {
  final int id;
  final int categoryId;
  final String name;
  final String description;

  Subcategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'] ?? 0, // Default to 0 if 'id' is null
      categoryId: json['category'] ?? 0, // Default to 0 if 'category' is null
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': categoryId, // Sending category ID instead of full category
      'name': name,
      'description': description,
    };
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String imageUrl; // Updated field name to 'imageUrl'
  final String createdAt;
  final Category category;
  final Subcategory subcategory;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.createdAt,
    required this.category,
    required this.subcategory,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price:
          double.tryParse(json['price'].toString()) ??
          0.0, // Safe price parsing
      stock: json['stock'] ?? 0,
      imageUrl: json['image'] ?? '', // Corrected to 'imageUrl'
      createdAt: json['created_at'] ?? '',
      category: Category.fromJson(json['category'] ?? {}),
      subcategory: Subcategory.fromJson(json['subcategory'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'image': imageUrl, // Corrected to 'imageUrl'
      'created_at': createdAt,
      'category': category.toJson(),
      'subcategory': subcategory.toJson(),
    };
  }
}
