import 'category_model.dart'; // Import the Category model

class Subcategory {
  final int id;
  final String name;
  final int categoryId;
  final Category category; // Reference to Category model

  Subcategory({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.category,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'],
      name: json['name'],
      categoryId:
          json['category'], // categoryId can reference the category's ID
      category: Category.fromJson(
        json['category_data'],
      ), // Assuming category data is nested under 'category_data'
    );
  }
}
