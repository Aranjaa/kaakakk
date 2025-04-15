import 'package:flutter/material.dart';
import '../../../../services/api_service.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _amountController = TextEditingController();
  int _orderId = 0; // This should come from the previous screen (order ID)

  Future<void> _makePayment() async {
    final amount = double.tryParse(_amountController.text);
    if (amount != null && amount > 0) {
      final success = await ApiService.makePayment(_orderId, amount);
      if (success) {
        Navigator.pushNamed(context, '/success'); // Navigate to a success page
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Payment failed')));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invalid amount')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Enter payment amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _makePayment, child: Text('Pay Now')),
          ],
        ),
      ),
    );
  }
}
