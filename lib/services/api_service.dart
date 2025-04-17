import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../core/model/product_model.dart';
import '../core/model/wishlists_model.dart';
import '../core/model/StatusReport.dart';
import '../core/model/user_profile_model.dart';
import '../core/model/cart_item_model.dart';

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

      if (response.statusCode == 200) {
        _logger.i('Нэвтрэлт амжилттай');

        // UTF-8 ашиглан JSON задлах
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        _logger.i('Response body: $responseData');

        final String token = responseData['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        return response;
      } else {
        final error = utf8.decode(response.bodyBytes);
        _logger.e('Нэвтрэх үед алдаа гарлаа: ${response.statusCode}');
        _logger.e('Response body: $error');
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

      if (response.statusCode == 201) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        _logger.i('Хэрэглэгч амжилттай бүртгүүлэв: $responseData');
      } else {
        final error = utf8.decode(response.bodyBytes);
        _logger.e('Бүртгэх үед алдаа гарлаа: ${response.statusCode}');
        _logger.e('Response body: $error');
        throw Exception('Бүртгэх үед алдаа гарлаа: ${response.statusCode}');
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
      String? token;
      try {
        token = await getToken();
      } catch (e) {
        _logger.w('⚠️ Token байхгүй. Зочин хэрэглэгч гэж үзэв.');
        // Зочин хэрэглэгчийн ангилал авах
        final response = await http.get(
          Uri.parse(
            '$baseUrl/categories/?guest=true',
          ), // Зочин хэрэглэгчийн хувьд параметр нэмэх
        );

        if (response.statusCode == 200) {
          _logger.i('✅ Ангилал амжилттай татагдлаа');
          final List<dynamic> data = json.decode(
            utf8.decode(response.bodyBytes),
          );
          return List<Map<String, dynamic>>.from(data);
        } else {
          _logger.e('⛔ Ангилал татахад алдаа гарлаа: ${response.statusCode}');
          throw Exception(
            'Ангилал татахад алдаа гарлаа: ${response.statusCode}',
          );
        }
      }

      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      final response = await http.get(
        Uri.parse('$baseUrl/categories/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        _logger.i('✅ Ангилал амжилттай татагдлаа');
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return List<Map<String, dynamic>>.from(data);
      } else if (response.statusCode == 401) {
        _logger.e('⛔ Токен алдаатай эсвэл хугацаа дууссан');
        throw Exception('Токен алдаатай эсвэл хугацаа дууссан');
      } else {
        _logger.e('⛔ Ангилал татахад алдаа гарлаа: ${response.statusCode}');
        throw Exception('Ангилал татахад алдаа гарлаа: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('⛔ Ангилал татахад алдаа гарлаа: $e');
      rethrow;
    }
  }

  // Function to fetch subcategories
  static Future<List<Map<String, dynamic>>> fetchSubcategories() async {
    try {
      String? token;
      try {
        token = await getToken();
      } catch (e) {
        _logger.w('⚠️ Token байхгүй. Зочин хэрэглэгч гэж үзэв.');
      }

      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      final response = await http.get(
        Uri.parse('$baseUrl/subcategories/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        _logger.i('✅ Дэд ангилал амжилттай татагдлаа');
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return List<Map<String, dynamic>>.from(data);
      } else {
        _logger.e('⛔ Дэд ангилал татахад алдаа гарлаа: ${response.statusCode}');
        throw Exception(
          'Дэд ангилал татахад алдаа гарлаа: ${response.statusCode}',
        );
      }
    } catch (e) {
      _logger.e('⛔ Дэд ангилал татахад алдаа гарлаа: $e');
      rethrow;
    }
  }

  // Function to retrieve the token from SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Хэрэглэгч нэвтэрсэн эсэхийг шалгах
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null &&
        token.isNotEmpty; // Хэрэв token байгаа бол хэрэглэгч нэвтэрсэн гэж үзнэ
  }

  // Хэрэглэгчийг гарах үйлдэл (logout) хийх
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
      // Token авна (байхгүй байж болно)
      String? token;
      try {
        token = await getToken();
      } catch (e) {
        _logger.w('⚠️ Token байхгүй байна. Зочин хэрэглэгч гэж үзэв.');
      }

      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      final response = await http.get(
        Uri.parse('$baseUrl/products/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        _logger.i('✅ Бүтээгдэхүүнүүд амжилттай татагдлаа');
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data;
      } else {
        _logger.e(
          '⛔ Бүтээгдэхүүнүүдийг татахад алдаа гарлаа: ${response.statusCode}',
        );
        throw Exception('Бүтээгдэхүүнүүдийг татахад алдаа гарлаа');
      }
    } catch (e) {
      _logger.e('⛔ Бүтээгдэхүүн татах үед алдаа гарлаа: $e');
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
          return [];
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
      String? token;
      try {
        token = await getToken();
      } catch (e) {
        _logger.w('⚠️ Token байхгүй. Зочин хайлт хийж байна.');
      }

      final headers = {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      };

      final response = await http.get(
        Uri.parse('$baseUrl/products/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));

        final List<dynamic> filtered = data.where((product) {
          final productName = product['name']?.toString().toLowerCase() ?? '';
          return productName.contains(query.toLowerCase());
        }).toList();

        return filtered;
      } else {
        _logger.e('⛔ Хайлтын үед алдаа гарлаа: ${response.statusCode}');
        throw Exception('Хайлтын үед алдаа гарлаа');
      }
    } catch (e) {
      _logger.e('⛔ Хайлтын үед алдаа гарлаа: $e');
      rethrow;
    }
  }

  static Future<UserProfile> fetchUserProfile() async {
    try {
      final token = await getToken(); // Хэрэглэгчийн токеныг авах
      final url = '$baseUrl/profiles/'; // API эндпоинт

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer $token", // Токен зөв ирж байгаа эсэхийг шалгах
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        // Хэрэглэгчийн профайлыг авч оруулна
        if (data.isNotEmpty) {
          return UserProfile.fromJson(
            data[0],
          ); // Тус бүрийн хэрэглэгчийн профайл
        } else {
          throw Exception("Profile not found");
        }
      } else {
        throw Exception("Error fetching profile: ${response.statusCode}");
      }
    } catch (e) {
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

  static Future<List<Map<String, dynamic>>> fetchCartItems(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/cart/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      _logger.e('❌ API Error: ${response.statusCode}');
      _logger.e('❌ Response body: ${response.body}');
      throw Exception('Failed to load cart items');
    }
  }

  // Update cart item quantity
  static Future<bool> updateCartItemQuantity(
      int cartItemId, int quantity) async {
    try {
      final token =
          await getToken(); // Ensure token fetching is handled consistently
      if (token == null || token.isEmpty) {
        _logger.e('⛔ No token found.');
        return false; // No token, cannot update cart item
      }

      final url =
          '$baseUrl/cart/$cartItemId/'; // Adjust the URL for your backend
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final data = {
        'quantity': quantity,
      };

      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        _logger.i('✅ Бүтээгдэхүүний тоог амжилттай шинэчиллээ');
        return true; // Successfully updated the quantity
      } else {
        _logger.e('❌ Failed to update quantity: ${response.statusCode}');
        return false; // Failed to update
      }
    } catch (e) {
      _logger.e('🚨 Error updating cart item quantity: $e');
      return false; // Error occurred during the request
    }
  }

  static Future<bool> addToCart(int productId, int quantity) async {
    try {
      final token = await getToken();
      if (token == null) {
        _logger.e('⛔ No token found.');
        return false;
      }

      if (productId == null || quantity == null || quantity <= 0) {
        _logger.e('⛔ Invalid productId or quantity.');
        return false; // Check for invalid data before sending the request
      }

      final response = await http.post(
        Uri.parse('$baseUrl/cart-items/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode({
          "product": productId,
          "quantity": quantity,
        }),
      );

      if (response.statusCode == 201) {
        _logger.i("✅ Item added to cart successfully");
        return true;
      } else {
        _logger.e("❌ Failed to add item to cart: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      _logger.e("🚨 Error adding item to cart: $e");
      return false;
    }
  }

  static Future<bool> removeCartItem(int itemId) async {
    try {
      final token = await getToken(); // Ensure token is fetched
      if (token == null) {
        _logger.e('⛔ No token found.');
        return false;
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/cart/$itemId/'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 204) {
        _logger.i('Сагснаас бүтээгдэхүүн амжилттай устгагдлаа');
        return true;
      } else {
        _logger.e(
          'Сагснаас бүтээгдэхүүн устгах үед алдаа: ${response.statusCode}',
        );
        return false;
      }
    } catch (e) {
      _logger.e('Сагснаас бүтээгдэхүүн устгах үед алдаа: $e');
      return false;
    }
  }

  static Future<bool> createOrder(Map<String, dynamic> orderData) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/orders/create/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      _logger.e('Order failed: ${response.body}');
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
