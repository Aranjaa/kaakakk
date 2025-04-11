import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/Provider/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Сагс")),
      body:
          cartProvider.items.isEmpty
              ? const Center(child: Text("Сагс хоосон байна"))
              : ListView.builder(
                itemCount: cartProvider.items.length,
                itemBuilder: (context, index) {
                  final item = cartProvider.items[index];
                  return ListTile(
                    leading: Image.network(
                      item
                          .product
                          .image, // Assuming `image` is a property of Product
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item.product.name),
                    subtitle: Text("₮${item.product.price} x ${item.quantity}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        cartProvider.removeFromCart(
                          item.product,
                        ); // Remove by item id
                      },
                    ),
                  );
                },
              ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Нийт: ₮${cartProvider.totalItems.toStringAsFixed(2)}", // Use totalPrice
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
