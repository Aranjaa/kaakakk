import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/category_model.dart';
import '../model/subcategory_model.dart';
import '../model/add_item_model.dart';

class ApiController {
  final String baseUrl = 'http://192.168.99.163:8000/api';

  // Fetch categories
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Fetch subcategories
  Future<List<Subcategory>> fetchSubcategories() async {
    final response = await http.get(Uri.parse('$baseUrl/subcategories/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Subcategory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load subcategories');
    }
  }

  // Fetch products
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
