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
      id: json['id'],
      categoryId: json['category'],
      name: json['name'],
      description: json['description'] ?? '',
    );
  }
}
