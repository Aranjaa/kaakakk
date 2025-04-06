import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart'; // Importing logger

class ApiService {
  static const String baseUrl =
      'http://192.168.99.163:8000/api'; // Local IP for Android device
  static final Logger _logger = Logger(); // Logger instance for logging

  // Login function
  static Future<http.Response> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        _logger.i('Login successful');
        _logger.i('Response body: ${utf8.decode(response.bodyBytes)}');

        // Decode the response to get the token
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        final String token = responseData['token'];

        // Save the token to SharedPreferences for future requests
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        return response;
      } else {
        _logger.e('Login failed: ${response.statusCode}');
        _logger.e('Response body: ${utf8.decode(response.bodyBytes)}');
      }

      return response;
    } catch (e) {
      _logger.e('Login error: $e');
      rethrow;
    }
  }

  // Register function
  static Future<http.Response> register(
    String email,
    String username,
    String firstName,
    String lastName,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "username": username,
          "first_name": firstName,
          "last_name": lastName,
          "password": password,
        }),
      );

      // Check if the response is successful
      if (response.statusCode == 201) {
        _logger.i('Registration successful');
        _logger.i('Response body: ${utf8.decode(response.bodyBytes)}');
      } else {
        _logger.e('Registration failed: ${response.statusCode}');
        _logger.e('Response body: ${utf8.decode(response.bodyBytes)}');
      }

      return response;
    } catch (e) {
      _logger.e('Registration error: $e');
      rethrow;
    }
  }

  // Function to retrieve the token from SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Function to check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Logout function
  static Future<void> logout() async {
    try {
      // Remove the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');

      _logger.i('User successfully logged out');
    } catch (e) {
      _logger.e('Logout error: $e');
      rethrow;
    }
  }

  // Function to fetch products
  static Future<List<Map<String, dynamic>>> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        _logger.i('Products fetched successfully');
        final List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        _logger.e('Failed to fetch products: ${response.statusCode}');
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      _logger.e('Error fetching products: $e');
      rethrow;
    }
  }
}

void getProducts() async {
  try {
    final products = await ApiService.fetchProducts();
    for (var product in products) {
      ApiService._logger.i('Product name: ${product['name']}');
    }
  } catch (e) {
    ApiService._logger.e('Error fetching products: $e');
  }
}
