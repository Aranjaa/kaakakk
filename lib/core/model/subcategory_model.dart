class Subcategory {
  final int id;
  final String name;

  Subcategory({
    required this.id,
    required this.name,
  });

  // Default Subcategory method
  static Subcategory defaultSubcategory() {
    return Subcategory(
      id: 0,
      name: 'Unknown Subcategory',
    );
  }

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Subcategory',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
