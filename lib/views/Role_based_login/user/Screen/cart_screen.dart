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
    _checkLoginAndFetchCart();
  }

  // Логин шалгаад сагсны мэдээлэл авах
  Future<void> _checkLoginAndFetchCart() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Loginscreen()),
        );
      }
    } else {
      _fetchCartItems();
    }
  }

  // Сагсны мэдээлэл авах
  Future<void> _fetchCartItems() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final cartData = await ApiService.fetchCartItems();
      _logger.e("API хариу: $cartData");

      if (cartData == null) {
        setState(() {
          _errorMessage =
              'Сагсны мэдээлэл татахад алдаа гарлаа. Та дахин оролдоно уу.';
        });
      } else if (cartData.isEmpty) {
        setState(() {
          _cartItems = [];
          _totalPrice = 0;
          _errorMessage = 'Сагсанд ямар ч бүтээгдэхүүн байхгүй.';
        });
      } else {
        setState(() {
          _cartItems = cartData.map((e) => CartItem.fromJson(e)).toList();
          _totalPrice = _cartItems.fold(
            0,
            (sum, item) => sum + item.product.price * item.quantity,
          );
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Сагсны мэдээлэл татах үед алдаа гарлаа. Та дахин оролдоно уу. Алдаа: $e';
      });
      _logger.e('🚨 Error: $e'); // Error-ыг логод бичих
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Бүтээгдэхүүнийг сагснаас устгах
  Future<void> _removeItem(int cartItemId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await ApiService.removeCartItem(cartItemId);
      if (success) {
        setState(() {
          _cartItems.removeWhere((item) => item.id == cartItemId);
          _totalPrice = _cartItems.fold(
            0,
            (sum, item) => sum + item.product.price * item.quantity,
          );
        });
      } else {
        setState(() {
          _errorMessage = 'Бүтээгдэхүүнийг устгахад алдаа гарлаа.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Бүтээгдэхүүнийг устгах үед алдаа гарлаа. Дахин оролдоно уу.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Захиалга үүсгэх
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

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await ApiService.createOrder(orderData);
      if (success) {
        Navigator.pushNamed(context, '/payment');
      } else {
        setState(() {
          _errorMessage = 'Захиалга үүсгэхэд алдаа гарлаа. Дахин оролдоно уу.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Захиалга үүсгэхийн тулд интернет холболтоо шалгана уу.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Бүтээгдэхүүний тоо хэмжээг шинэчлэх
  Future<void> _updateCartItemQuantity(int cartItemId, int quantity) async {
    if (quantity <= 0) {
      setState(() {
        _errorMessage = 'Тооны хэмжээ 0-аас их байх ёстой.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success =
          await ApiService.updateCartItemQuantity(cartItemId, quantity);

      if (success) {
        setState(() {
          _cartItems.firstWhere((item) => item.id == cartItemId).quantity =
              quantity;
          _totalPrice = _cartItems.fold(
            0,
            (sum, item) => sum + item.product.price * item.quantity,
          );
        });
      } else {
        setState(() {
          _errorMessage = 'Бүтээгдэхүүний тоо хэмжээг шинэчлэхэд алдаа гарлаа.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Бүтээгдэхүүний тоо хэмжээг шинэчлэхэд алдаа гарлаа.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Миний сагс")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
              ? Center(
                  child: Text(
                    "Таны сагс хоосон байна",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: _cartItems.length,
                  itemBuilder: (context, index) {
                    final item = _cartItems[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: Image.network(
                          item.product.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(item.product.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Үнэ: ${item.product.price}₮"),
                            Text(
                                "Нийт: ${item.product.price * item.quantity}₮"),
                          ],
                        ),
                        trailing: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    int newQty = item.quantity - 1;
                                    if (newQty > 0) {
                                      _updateCartItemQuantity(item.id, newQty);
                                    }
                                  },
                                ),
                                Text(item.quantity.toString()),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    int newQty = item.quantity + 1;
                                    _updateCartItemQuantity(item.id, newQty);
                                  },
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeItem(item.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  // Show dialog to update quantity
  Future<int?> _showQuantityDialog(BuildContext context, int currentQuantity) {
    TextEditingController _quantityController =
        TextEditingController(text: currentQuantity.toString());

    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Тоо хэмжээ сонгох'),
          content: TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Тооны хэмжээ'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Болих'),
            ),
            TextButton(
              onPressed: () {
                int? newQuantity = int.tryParse(_quantityController.text);
                if (newQuantity != null && newQuantity > 0) {
                  Navigator.of(context).pop(newQuantity);
                }
              },
              child: Text('Шинэчлэх'),
            ),
          ],
        );
      },
    );
  }
}
