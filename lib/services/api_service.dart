import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../core/model/product_model.dart';
import '../core/model/wishlists_model.dart';
import '../core/model/StatusReport.dart';

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

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return data.map((json) => Product.fromJson(json)).toList();
        } else {
          throw Exception('Бүтээгдэхүүнүүдийг татахад алдаа гарлаа');
        }
      } else {
        throw Exception('Бүтээгдэхүүнүүдийг татахад алдаа гарлаа');
      }
    } catch (e) {
      throw Exception('Бүтээгдэхүүн татах үед алдаа гарлаа: $e');
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

  Future<bool> editProduct(Product product) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/products/${product.id}/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': product.name,
          'category': product.category.id,
          'subcategory': product.subcategory.id,
          'price': product.price,
          'description': product.description,
          'stock': product.stock,
          'color': product.color,
          'size': product.size,
          'imageUrl': product.image,
        }),
      );

      if (response.statusCode == 200) {
        return true; // Product updated successfully
      } else {
        throw Exception(
          'Бүтээгдэхүүн, статус код засах боломжгүй: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Бүтээгдэхүүн засах: $e');
    }
  }

  // Delete a product (DELETE)
  static Future<bool> deleteProduct(String productId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/products/$productId/'),
      );

      if (response.statusCode == 204) {
        return true; // Product deleted successfully
      } else {
        throw Exception(
          'Бүтээгдэхүүн устгах боломжгүй, статус код: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Бүтээгдэхүүн устгах: $e');
    }
  }

  static Future<bool> addToCart(int productId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cart/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${await getToken()}",
        },
        body: jsonEncode({"product_id": productId, "quantity": quantity}),
      );

      if (response.statusCode == 201) {
        _logger.i('Сагсанд амжилттай нэмэгдлээ');
        return true;
      } else {
        _logger.e('Сагсанд нэмэх үед алдаа: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _logger.e('Сагсанд нэмэх үед алдаа: $e');
      return false;
    }
  }

  static Future<List<dynamic>> fetchCartItems() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cart/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${await getToken()}",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        _logger.i('Сагсны мэдээлэл татагдлаа');
        return data;
      } else {
        _logger.e('Сагс татахад алдаа: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      _logger.e('Сагс татахад алдаа: $e');
      return [];
    }
  }

  static Future<bool> removeCartItem(int cartItemId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/cart/$cartItemId/'),
        headers: {"Authorization": "Bearer ${await getToken()}"},
      );

      if (response.statusCode == 204) {
        _logger.i('Сагснаас амжилттай устгагдлаа');
        return true;
      } else {
        _logger.e('Сагснаас устгах үед алдаа: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _logger.e('Сагснаас устгах үед алдаа: $e');
      return false;
    }
  }

  static Future<bool> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${await getToken()}",
        },
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        _logger.i('Захиалга амжилттай хийгдлээ');
        return true;
      } else {
        _logger.e('Захиалга хийхэд алдаа: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _logger.e('Захиалга хийхэд алдаа: $e');
      return false;
    }
  }

  static Future<List<dynamic>> fetchOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${await getToken()}",
        },
      );

      if (response.statusCode == 200) {
        _logger.i('Захиалгууд татагдлаа');
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        _logger.e('Захиалга татахад алдаа: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      _logger.e('Захиалга татахад алдаа: $e');
      return [];
    }
  }

  static Future<bool> makePayment(int orderId, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/payments/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${await getToken()}",
        },
        body: jsonEncode({"order_id": orderId, "amount": amount}),
      );

      if (response.statusCode == 201) {
        _logger.i('Төлбөр амжилттай');
        return true;
      } else {
        _logger.e('Төлбөр хийхэд алдаа: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _logger.e('Төлбөр хийхэд алдаа: $e');
      return false;
    }
  }

  static Future<bool> addToWishlist(int productId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/wishlist/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${await getToken()}",
        },
        body: jsonEncode({"product": productId}),
      );

      if (response.statusCode == 201) {
        _logger.i('Бүтээгдэхүүн таалагдсан зүйлд орсон-д нэмэгдлээ');
        return true;
      } else {
        _logger.e('таалагдсан зүйлд нэмэхэд алдаа: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      _logger.e('таалагдсан зүйлд нэмэх үед алдаа: $e');
      return false;
    }
  }

  static Future<List<Wishlists>> fetchWishlist() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/wishlist/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${await getToken()}",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => Wishlists.fromJson(json)).toList();
      } else {
        throw Exception('Wishlist fetching failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> removeFromWishlist(int wishlistId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/wishlist/$wishlistId/'),
        headers: {"Authorization": "Bearer ${await getToken()}"},
      );

      if (response.statusCode == 204) {
        _logger.i('Таалагдсан зүйлээс амжилттай устгагдлаа');
        return true;
      } else {
        _logger.e(
          'Таалагдсан зүйлээс устгах үед алдаа: ${response.statusCode}',
        );
        return false;
      }
    } catch (e) {
      _logger.e('Таалагдсан зүйлээс устгах үед алдаа: $e');
      return false;
    }
  }

  Future<List<StatusReport>> fetchWeeklyStatusReport() async {
    final response = await http.get(
      Uri.parse("http://192.168.99.163:8000/api/reports/weekly-status/"),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data.map<StatusReport>((item) {
        return StatusReport(
          status: item['status'],
          period: DateTime.parse(item['week']),
          totalSales: double.parse(item['total_sales']),
          totalOrders: item['total_orders'],
        );
      }).toList();
    } else {
      throw Exception("Report fetch failed");
    }
  }
}
