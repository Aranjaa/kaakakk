import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/Provider/cart_provider.dart';
import './BuyNowScreen.dart'; // BuyNowScreen-г зөв import хийнэ

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Сагс"), centerTitle: true),
      body:
          cartProvider.items.isEmpty
              ? const Center(child: Text("Сагс хоосон байна"))
              : ListView.builder(
                itemCount: cartProvider.items.length,
                itemBuilder: (context, index) {
                  final item = cartProvider.items[index];
                  return ListTile(
                    leading: Image.network(
                      item.product.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item.product.name),
                    subtitle: Text(
                      "₮${item.product.price.toStringAsFixed(2)} x ${item.quantity}",
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        cartProvider.removeFromCart(item.product);
                      },
                    ),
                  );
                },
              ),
      bottomNavigationBar:
          cartProvider.items.isNotEmpty
              ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Нийт: ₮${cartProvider.totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Хамгийн эхний cartItem-г сонгож дамжуулах жишээ
                          final firstItem = cartProvider.items.first;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => BuyNowScreen(
                                    productId: firstItem.product.id,
                                    price: firstItem.product.price,
                                    quantity: firstItem.quantity,
                                    method: "cart", // эсвэл "buynow"
                                  ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          "Худалдан авах",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : null,
    );
  }
}
