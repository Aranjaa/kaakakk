import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мэдэгдэл'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Таны захиалга амжилттай баталгаажлаа.'),
            subtitle: Text('3 минутын өмнө'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.local_offer),
            title: Text('Шинэ хямдрал гарлаа - 20% Off!'),
            subtitle: Text('Өчигдөр'),
          ),
        ],
      ),
    );
  }
}
