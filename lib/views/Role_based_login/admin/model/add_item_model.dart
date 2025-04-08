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
  final String imageUrl;
  final Category category;
  final Subcategory subcategory;
  final List<String> color; // Added color
  final List<String> size; // Added size

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.category,
    required this.subcategory,
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
      imageUrl: json['imageUrl'],
      category: Category.fromJson(json['category']),
      subcategory: Subcategory.fromJson(json['subcategory']),
      color: List<String>.from(json['color'] ?? []), // Parsing color list
      size: List<String>.from(json['size'] ?? []), // Parsing size list
    );
  }
}
