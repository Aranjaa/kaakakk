import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BuyNowScreen extends StatefulWidget {
  final int productId;
  final num price;
  final int quantity;

  const BuyNowScreen({
    super.key,
    required this.productId,
    required this.price,
    required this.quantity,
  });

  @override
  State<BuyNowScreen> createState() => _BuyNowScreenState();
}

class _BuyNowScreenState extends State<BuyNowScreen> {
  final _formKey = GlobalKey<FormState>();
  final _country = TextEditingController();
  final _city = TextEditingController();
  final _street = TextEditingController();
  final _postalCode = TextEditingController();
  String selectedMethod = "card"; // Default value

  Future<void> buyNow() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Нэвтрэлт байхгүй байна.')));
      return;
    }

    final url = Uri.parse("http://192.168.99.163:8000/api/orders/create/");

    final body = {
      "status": "pending",
      "total_price": (widget.price * widget.quantity).toString(),
      "items": [
        {
          "product": widget.productId,
          "quantity": widget.quantity,
          "price": widget.price.toString(),
        },
      ],
      "shipping_address": {
        "country": _country.text,
        "city": _city.text,
        "street": _street.text,
        "postal_code": _postalCode.text,
      },
      "payment": {
        "method": selectedMethod,
        "status": false,
        "transaction_id": "",
      },
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Захиалга амжилттай үүссэн!")),
        );

        // Төлбөр амжилттай болбол success дэлгэц рүү шилжих
        Navigator.pushNamed(context, '/payment-success');
      } else {
        final data = jsonDecode(response.body);
        String error = data['detail'] ?? 'Алдаа гарлаа.';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Сүлжээний алдаа гарлаа')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Одоо худалдаж авах"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text("Бүтээгдэхүүн ID: ${widget.productId}"),
              Text("Үнэ: ₮${widget.price.toStringAsFixed(2)}"),
              Text("Тоо хэмжээ: ${widget.quantity}"),
              const Divider(height: 32),

              // Shipping fields
              TextFormField(
                controller: _country,
                decoration: const InputDecoration(labelText: 'Улс'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Улс оруулна уу' : null,
              ),
              TextFormField(
                controller: _city,
                decoration: const InputDecoration(labelText: 'Хот'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Хот оруулна уу' : null,
              ),
              TextFormField(
                controller: _street,
                decoration: const InputDecoration(labelText: 'Гудамж'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Гудамж оруулна уу' : null,
              ),
              TextFormField(
                controller: _postalCode,
                decoration: const InputDecoration(labelText: 'Шуудангийн код'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Шуудангийн код оруулна уу'
                    : null,
                keyboardType: TextInputType
                    .number, // Ensure numeric input for postal code
              ),

              const SizedBox(height: 16),
              const Text(
                "Төлбөрийн арга сонгох:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              PaymentOptionTile(
                title: "Банк",
                value: "bank",
                groupValue: selectedMethod,
                onChanged: (val) => setState(() => selectedMethod = val),
              ),
              PaymentOptionTile(
                title: "Карт",
                value: "card",
                groupValue: selectedMethod,
                onChanged: (val) => setState(() => selectedMethod = val),
              ),
              PaymentOptionTile(
                title: "QR",
                value: "qr",
                groupValue: selectedMethod,
                onChanged: (val) => setState(() => selectedMethod = val),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: buyNow,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    "Одоо худалдаж авах",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentOptionTile extends StatelessWidget {
  final String title;
  final String value;
  final String groupValue;
  final Function(String) onChanged;

  const PaymentOptionTile({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      value: value,
      groupValue: groupValue,
      onChanged: (val) => onChanged(val!),
      title: Text(title),
      activeColor: Colors.blueAccent,
    );
  }
}
