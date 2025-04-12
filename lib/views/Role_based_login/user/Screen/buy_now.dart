import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

Future<void> buyNow({
  required int productId,
  required double price,
  required int quantity,
  required String method,
  required BuildContext context, // Added context for showing snackbar
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';

  if (token.isEmpty) {
    // Token is missing, show error message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Токен алга, дахин нэвтэрнэ үү.')),
    );
    return;
  }

  final url = Uri.parse("http://192.168.1.4:8000/api/orders/create/");
  final body = {
    "status": "pending",
    "total_price": (price * quantity).toString(),
    "items": [
      {"product": productId, "quantity": quantity, "price": price.toString()},
    ],
    "payment": {
      "method": method,
      "status": false,
      "transaction_id":
          "", // You can add the transaction ID after payment completion
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
      // Order successfully created
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Таны захиалга амжилттай баталгаажлаа!')),
      );
      // Optionally, navigate to an order confirmation screen or home page
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => OrderConfirmationScreen()));
    } else {
      // API returned an error
      final responseData = jsonDecode(response.body);
      String errorMessage =
          responseData['detail'] ?? 'Захиалга үүсгэхэд алдаа гарлаа';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  } catch (e) {
    // Network or other errors
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Сүлжээний алдаа гарлаа. Та дараа дахин оролдож үзнэ үү.',
        ),
      ),
    );
    print("Error: $e");
  }
}
