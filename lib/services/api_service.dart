import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

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
        _logger.i('Нэвтрэлт амжилттай');
        _logger.i('Response body: ${response.body}'); // Simplified logging

        // Decode the response to get the token
        final responseData = json.decode(response.body);
        final String token = responseData['token'];

        // Save the token to SharedPreferences for future requests
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        return response;
      } else {
        _logger.e('Нэвтрэх үед алдаа гарлаа: ${response.statusCode}');
        _logger.e('Response body: ${response.body}');
        throw Exception('Нэвтрэх үед алдаа гарлаа: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Нэвтрэх үед алдаа гарлаа: $e');
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
        _logger.i('Хэрэглэгч амжилттай бүртгүүлэв');
        _logger.i('Response body: ${response.body}'); // Simplified logging
      } else {
        _logger.e(
          'Хэрэглэгч бүртгүүлэх үед алдаа гарлаа: ${response.statusCode}',
        );
        _logger.e('Response body: ${response.body}');
        throw Exception(
          'Хэрэглэгч бүртгүүлэх үед алдаа гарлаа: ${response.statusCode}',
        );
      }

      return response;
    } catch (e) {
      _logger.e('Хэрэглэгч бүртгүүлэх үед алдаа гарлаа: $e');
      rethrow;
    }
  }

  // Function to fetch categories
  static Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${await getToken()}",
        },
      );

      if (response.statusCode == 200) {
        _logger.i('Ангилал амжилттай татагдлаа');
        final List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else if (response.statusCode == 401) {
        _logger.e('Зөвшөөрөлгүй: Токен хугацаа дууссан эсвэл хүчингүй болсон');
        throw Exception(
          'Зөвшөөрөлгүй: Токен хугацаа дууссан эсвэл хүчингүй болсон',
        );
      } else {
        _logger.e('Ангилал татахад алдаа гарлаа: ${response.statusCode}');
        _logger.e('Response body: ${response.body}');
        throw Exception('Ангилал татахад алдаа гарлаа: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('Ангилал татахад алдаа гарлаа: $e');
      rethrow;
    }
  }

  // Function to fetch subcategories
  static Future<List<Map<String, dynamic>>> fetchSubcategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/subcategories/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${await getToken()}",
        },
      );

      if (response.statusCode == 200) {
        _logger.i('Дэд ангилал амжилттай татагдлаа');
        final List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else if (response.statusCode == 401) {
        _logger.e('Зөвшөөрөлгүй: Токен хугацаа дууссан эсвэл хүчингүй болсон');
        throw Exception(
          'Зөвшөөрөлгүй: Токен хугацаа дууссан эсвэл хүчингүй болсон',
        );
      } else {
        _logger.e('Дэд ангилал татахад алдаа гарлаа: ${response.statusCode}');
        _logger.e('Response body: ${response.body}');
        throw Exception(
          'Дэд ангилал татахад алдаа гарлаа: ${response.statusCode}',
        );
      }
    } catch (e) {
      _logger.e('Дэд ангилал татахад алдаа гарлаа: $e');
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

      _logger.i('Хэрэглэгч амжилттай гарлаа');
    } catch (e) {
      _logger.e('Гарахад алдаа гарлаа: $e');
      rethrow;
    }
  }

  static Future<List<dynamic>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${await getToken()}",
        },
      );

      if (response.statusCode == 200) {
        _logger.i('Бүтээгдэхүүнүүд амжилттай татагдлаа');
        final List<dynamic> data = json.decode(response.body);
        return data; // Бүтээгдэхүүнүүдийг буцаах
      } else {
        _logger.e(
          'Бүтээгдэхүүнүүдийг татахад алдаа гарлаа: ${response.statusCode}',
        );
        throw Exception('Бүтээгдэхүүнүүдийг татахад алдаа гарлаа');
      }
    } catch (e) {
      _logger.e('Бүтээгдэхүүн татах үед алдаа гарлаа: $e');
      rethrow;
    }
  }
}
