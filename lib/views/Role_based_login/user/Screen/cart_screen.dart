import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../services/api_service.dart';
import '../../../../core/model/cart_item_model.dart';
import 'package:shopping/views/Role_based_login/loginscreen.dart';
import 'package:logger/logger.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static final Logger _logger = Logger();
  List<CartItem> _cartItems = [];
  double _totalPrice = 0;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkLoginAndFetchCart(); // Check login status and fetch cart items
  }

  // ✅ SharedPreferences-оос токен авах функц
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _checkLoginAndFetchCart() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      _showLoginAlert(); // Show login alert if no token found
    } else {
      _fetchCartItems(); // Fetch cart items if token exists
    }
  }

  // Show login alert if the user is not logged in
  void _showLoginAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Нэвтрэх шаардлагатай'),
          content: Text('Та нэвтэрч орсонгүй. Нэвтрэх үү?'),
          actions: <Widget>[
            TextButton(
              child: Text('Үгүй'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Тийм'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Loginscreen()), // Redirect to login screen
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Fetch cart items if token is available
  // Assuming you're trying to parse a list of cart items
  Future<void> _fetchCartItems() async {
    String? token = await _getToken();
    if (token != null) {
      List<CartItem> items = [];
      try {
        // Fetch the cart items from the API
        final response =
            await ApiService.fetchCartItems(token); // Your API call method
        print('Cart API Response: $response'); // Log the raw response

        // Ensure that the response is a List of Maps
        if (response is List) {
          for (var itemJson in response) {
            // Ensure each item is a Map<String, dynamic>
            if (itemJson is Map<String, dynamic>) {
              // Convert Map<String, dynamic> to CartItem
              items.add(CartItem.fromJson(itemJson)); // This is correct
            } else {
              _logger.e("Expected Map<String, dynamic> but found: $itemJson");
            }
          }

          // Update state with the fetched cart items
          setState(() {
            _cartItems = items;
            _calculateTotal(); // Calculate total price
          });
        } else {
          _logger.e('Expected a list but got: $response');
        }
      } catch (e) {
        _logger.e("Error parsing cart items: $e");
        setState(() {
          _errorMessage = "Сагсны мэдээллийг ачааллах үед алдаа гарлаа.";
        });
      }
    } else {
      _logger.e('❗ Token олдсонгүй');
    }
  }

  // Calculate the total price of the cart items
  void _calculateTotal() {
    _totalPrice = _cartItems.fold(
      0,
      (sum, item) => sum + item.product.price * item.quantity,
    );
  }

  // Remove an item from the cart
  Future<void> _removeItem(int cartItemId) async {
    setState(() => _isLoading = true);
    try {
      final success = await ApiService.removeCartItem(cartItemId);
      if (success) {
        setState(() {
          _cartItems.removeWhere((item) => item.id == cartItemId);
          _calculateTotal();
        });
        _showMessage('Амжилттай устгагдлаа');
      } else {
        _showMessage('Устгах үед алдаа гарлаа');
      }
    } catch (_) {
      _showMessage('Сүлжээний алдаа. Дахин оролдоно уу.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Checkout process, create an order
  Future<void> _checkout() async {
    final orderData = {
      "items": _cartItems
          .map((item) => {
                "product_id": item.product.id,
                "quantity": item.quantity,
              })
          .toList(),
      "total_price": _totalPrice,
    };

    setState(() => _isLoading = true);
    try {
      final success = await ApiService.createOrder(orderData);
      if (success) {
        _showMessage('Захиалга үүсгэлээ');
        Navigator.pushNamed(context, '/payment'); // Navigate to payment screen
      } else {
        _showMessage('Захиалга үүсгэхэд алдаа гарлаа');
      }
    } catch (_) {
      _showMessage('Интернет холболтоо шалгана уу');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Show message in a SnackBar
  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_isLoading) CircularProgressIndicator(),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
              ),
            if (_cartItems.isNotEmpty) ...[
              for (var item in _cartItems)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image.network(
                        item.product.image,
                        width: 50,
                        height: 50,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          }
                        },
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return Icon(Icons.error);
                        },
                      ),
                      SizedBox(width: 10),
                      Text(item.product.name),
                      Spacer(),
                      Text('\$${item.product.price}'),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () => _removeItem(item.id),
                      ),
                    ],
                  ),
                )
            ],
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _checkout,
                child: Text("Proceed to Checkout"),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _cartItems.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Нийт: ₮$_totalPrice',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton.icon(
                    onPressed: _checkout,
                    icon: Icon(Icons.payment),
                    label: Text('Төлбөр хийх'),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
