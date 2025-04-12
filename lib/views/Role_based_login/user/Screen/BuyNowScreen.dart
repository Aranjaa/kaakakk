import 'package:flutter/material.dart';

class BuyNowScreen extends StatelessWidget {
  final int productId;
  final num price;
  final int quantity;
  final String method;

  const BuyNowScreen({
    super.key,
    required this.productId,
    required this.price,
    required this.quantity,
    required this.method,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Худалдан авах"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product details section
              Text(
                "Бүтээгдэхүүн ID: $productId",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 8),
              Text(
                "Үнэ: ₮${price.toStringAsFixed(2)}",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 8),
              Text(
                "Тоо хэмжээ: $quantity",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 8),
              Text(
                "Аргууд: $method",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Divider(),

              // Payment method selection
              Text(
                "Төлбөрийн арга",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 16),
              PaymentMethodTile(
                icon: Icons.account_balance_wallet,
                title: "Банк",
                description: "Монгол улсын банкууд ашиглах боломжтой.",
                onTap: () {
                  // Add bank payment method logic here
                },
              ),
              PaymentMethodTile(
                icon: Icons.credit_card,
                title: "Карт",
                description: "Кредит болон дебит карт ашиглах боломжтой.",
                onTap: () {
                  // Add card payment method logic here
                },
              ),
              PaymentMethodTile(
                icon: Icons.qr_code_scanner,
                title: "QR",
                description: "QR код ашиглан төлбөр хийх.",
                onTap: () {
                  // Add QR code payment method logic here
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle the 'Buy Now' action here
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text("Төлбөр амжилттай хийгдлээ!"),
                          content: const Text(
                            "Таны худалдан авалт амжилттай боллоо.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("ОК"),
                            ),
                          ],
                        ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Одоо худалдан авах",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const PaymentMethodTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      subtitle: Text(description),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
