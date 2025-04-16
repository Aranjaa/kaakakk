class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  // Default Category method
  static Category defaultCategory() {
    return Category(
      id: 0,
      name: 'Unknown Category',
    );
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return defaultCategory();
    }

    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Category',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
