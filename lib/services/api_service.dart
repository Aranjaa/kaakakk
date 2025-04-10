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
        // UTF-8 кодчилол ашиглаж текст задлах
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
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
        // UTF-8 кодчилол ашиглаж текст задлах
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
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
        // UTF-8 кодчилол ашиглаж текст задлах
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
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

  static Future<List<dynamic>> searchProducts(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${await getToken()}",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));

        // Нэрээр хайж шүүх
        final List<dynamic> filtered =
            data.where((product) {
              final productName =
                  product['name']?.toString().toLowerCase() ?? '';
              return productName.contains(query.toLowerCase());
            }).toList();

        return filtered;
      } else {
        _logger.e('Хайлтын үед алдаа гарлаа: ${response.statusCode}');
        throw Exception('Хайлтын үед алдаа гарлаа');
      }
    } catch (e) {
      _logger.e('Хайлтын үед алдаа гарлаа: $e');
      rethrow;
    }
  }

  static Future<List<dynamic>> fetchUserProfile() async {
    try {
      final token =
          await getToken(); // Make sure this gets the correct token for the logged-in user
      final url =
          '$baseUrl/profiles/'; // Make sure this endpoint returns the current logged-in user profile

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Ensure you're sending the token
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        _logger.i(
          "Fetched profile data: $data",
        ); // Log the fetched data for debugging
        return data; // Return the profile data
      } else {
        // Log the error and the URL for debugging
        _logger.e(
          "Профайл татахад алдаа гарлаа: ${response.statusCode}, URL: $url",
        );
        throw Exception("Профайл татахад алдаа гарлаа: ${response.statusCode}");
      }
    } catch (e) {
      _logger.e("Профайл татах үед алдаа: $e");
      rethrow;
    }
  }
}
