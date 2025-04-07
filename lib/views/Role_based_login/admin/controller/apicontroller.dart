import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/add_item_model.dart';

class ApiController {
  final String baseUrl = 'http://192.168.99.163:8000/api';

  // Fetch categories
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return data.map((json) => Category.fromJson(json)).toList();
        } else {
          throw Exception('No categories found');
        }
      } else {
        throw Exception(
          'Failed to load categories, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Fetch subcategories
  Future<List<Subcategory>> fetchSubcategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/subcategories/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return data.map((json) => Subcategory.fromJson(json)).toList();
        } else {
          throw Exception('No subcategories found');
        }
      } else {
        throw Exception(
          'Failed to load subcategories, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching subcategories: $e');
    }
  }

  // Fetch products
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return data.map((json) => Product.fromJson(json)).toList();
        } else {
          throw Exception('No products found');
        }
      } else {
        throw Exception(
          'Failed to load products, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // Add a product (POST)
  Future<bool> addProduct(Product product) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': product.name,
          'category': product.category.id,
          'subcategory': product.subcategory.id,
          'price': product.price,
          'description': product.description,
          'stock': product.stock,
          'image_url': product.imageUrl,
        }),
      );

      if (response.statusCode == 201) {
        return true; // Product added successfully
      } else {
        throw Exception(
          'Failed to add product, status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }
}
