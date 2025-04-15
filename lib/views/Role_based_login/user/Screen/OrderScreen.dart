import 'package:flutter/material.dart';
import '../../../../services/api_service.dart';
import 'package:provider/provider.dart';
import '../../../../core/Provider/cart_provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _country = TextEditingController();
  final _city = TextEditingController();
  final _street = TextEditingController();
  final _postalCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Хүргэлтийн мэдээлэл")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _country,
                decoration: const InputDecoration(labelText: 'Улс'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Улс заавал оруулна уу'
                            : null,
              ),
              TextFormField(
                controller: _city,
                decoration: const InputDecoration(labelText: 'Хот'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Хот заавал оруулна уу'
                            : null,
              ),
              TextFormField(
                controller: _street,
                decoration: const InputDecoration(labelText: 'Гудамж'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Гудамж заавал оруулна уу'
                            : null,
              ),
              TextFormField(
                controller: _postalCode,
                decoration: const InputDecoration(labelText: 'Шуудангийн код'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Шуудангийн код заавал оруулна уу'
                            : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final items =
                      cartProvider.items
                          .map(
                            (e) => {
                              'product_id': e.product.id,
                              'quantity': e.quantity,
                            },
                          )
                          .toList();

                  final orderData = {
                    'shipping_address': {
                      'country': _country.text,
                      'city': _city.text,
                      'street': _street.text,
                      'postal_code': _postalCode.text,
                    },
                    'items': items,
                  };

                  try {
                    final success = await ApiService.createOrder(orderData);

                    if (success) {
                      for (var item in cartProvider.items) {
                        cartProvider.removeFromCart(item.product);
                      }
                      if (!mounted) return;
                      Navigator.pushNamed(context, '/payment');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Захиалга үүсгэхэд алдаа гарлаа'),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Алдаа гарлаа: $e')));
                  }
                },
                child: const Text("Захиалах"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
