import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/api_service.dart';
import '../../../../core/model/cart_item_model.dart';
import 'package:shopping/views/Role_based_login/loginscreen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _cartItems = [];
  double _totalPrice = 0;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkLoginAndFetchCart();
  }

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

  Future<void> _fetchCartItems() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final cartData = await ApiService.fetchCartItems();
      setState(() {
        _cartItems = cartData.map((e) => CartItem.fromJson(e)).toList();
        _totalPrice = _cartItems.fold(
          0,
          (sum, item) => sum + item.product.price * item.quantity,
        );
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Сагсны мэдээлэл татахад алдаа гарлаа.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeItem(int cartItemId) async {
    setState(() {
      _isLoading = true;
    });

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

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _checkout() async {
    final orderData = {
      "items":
          _cartItems
              .map(
                (item) => {
                  "product_id": item.product.id,
                  "quantity": item.quantity,
                },
              )
              .toList(),
      "total_price": _totalPrice,
    };

    setState(() {
      _isLoading = true;
    });

    final success = await ApiService.createOrder(orderData);
    if (success) {
      Navigator.pushNamed(context, '/payment');
    } else {
      setState(() {
        _errorMessage = 'Захиалга үүсгэхэд алдаа гарлаа.';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Миний сагс')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _cartItems.isEmpty
              ? Center(child: Text('Сагсанд бүтээгдэхүүн алга.'))
              : ListView.builder(
                itemCount: _cartItems.length,
                itemBuilder: (context, index) {
                  final item = _cartItems[index];
                  return ListTile(
                    title: Text(item.product.name),
                    subtitle: Text('Тоо: ${item.quantity}'),
                    trailing: Text('₮${item.product.price * item.quantity}'),
                    leading: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeItem(item.id),
                    ),
                  );
                },
              ),
      bottomNavigationBar:
          _cartItems.isNotEmpty
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Нийт: ₮$_totalPrice'),
                    ElevatedButton(
                      onPressed: _checkout,
                      child: Text('Төлбөр хийх'),
                    ),
                  ],
                ),
              )
              : null,
    );
  }
}
