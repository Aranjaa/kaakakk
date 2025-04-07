import 'package:flutter/material.dart';
import 'package:shopping/services/api_service.dart';
import 'package:shopping/views/Role_based_login/admin/screen/add_item_screen.dart';
import 'package:shopping/views/Role_based_login/loginscreen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  List<dynamic> products = [];
  List<dynamic> filteredProducts = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // API-аас бүтээгдэхүүн татах функц
  Future<void> _loadProducts() async {
    try {
      final response =
          await ApiService.getProducts(); // API-с бүтээгдэхүүн татаж авах
      setState(() {
        products = response; // Бүтээгдэхүүнүүдийг хадгалах
        filteredProducts = products; // Анхны шүүлт нь бүгдийг харах
      });
    } catch (e) {
      // Алдаа гарах тохиолдолд
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Өгөгдөл татах үед алдаа гарлаа: $e')),
      );
    }
  }

  // Шүүлт хийх функц
  void _filterProducts(String query) {
    final filtered =
        products.where((product) {
          final productName = product['name'].toLowerCase();
          return productName.contains(query.toLowerCase());
        }).toList();

    setState(() {
      searchQuery = query;
      filteredProducts = filtered;
    });
  }

  // Logout function
  Future<void> _handleLogout(BuildContext context) async {
    await ApiService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Loginscreen(),
      ), // Redirect to login screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: const Text('Admin screen'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed:
                () => _handleLogout(context), // Logout when button is pressed
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: _filterProducts, // Шүүлт хийх
              decoration: const InputDecoration(
                labelText: 'Хайх...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(product['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Үнэ: ${product['price']}'),
                          Text('Сагсанд: ${product['stock']} ширхэг'),
                          Text('Ангилал: ${product['category']['name']}'),
                          Text(
                            'Дэд ангилал: ${product['subcategory']['name']}',
                          ),
                        ],
                      ),
                      trailing: Image.network(
                        product['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () async {
          await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const AddItems()));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
