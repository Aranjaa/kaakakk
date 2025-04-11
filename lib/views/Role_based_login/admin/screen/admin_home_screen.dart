import 'package:flutter/material.dart';
import 'package:shopping/services/api_service.dart';
import 'package:shopping/views/Role_based_login/admin/screen/add_item_screen.dart';
import './EditProductScreen.dart'; // Add the import for the edit screen
import 'package:shopping/views/Role_based_login/loginscreen.dart';
import './ReportScreen.dart';

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

  Future<void> _loadProducts() async {
    try {
      final response = await ApiService.getProducts();
      setState(() {
        products = response;
        filteredProducts = products;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Өгөгдөл татах үед алдаа гарлаа: $e')),
      );
    }
  }

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

  Future<void> _handleLogout(BuildContext context) async {
    await ApiService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Loginscreen()),
    );
  }

  // Delete product
  Future<void> _deleteProduct(String productId) async {
    try {
      final isSuccess = await ApiService.deleteProduct(productId);
      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Бүтээгдэхүүн амжилттай устгагдлаа')),
        );
        _loadProducts(); // Reload products after deletion
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Бүтээгдэхүүн устгах үед алдаа гарлаа: $e')),
      );
    }
  }

  // Navigate to edit product screen
  void _editProduct(BuildContext context, dynamic product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: const Text('Админ хуудас'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: _filterProducts,
              decoration: const InputDecoration(
                labelText: 'Хайх...',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontFamily: 'Roboto'),
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
                      title: Text(
                        product['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Үнэ: ${product['price']}',
                            style: TextStyle(fontFamily: 'Roboto'),
                          ),
                          Text(
                            'Сагсанд: ${product['stock']} ширхэг',
                            style: TextStyle(fontFamily: 'Roboto'),
                          ),
                          Text(
                            'Ангилал: ${product['category']['name']}',
                            style: TextStyle(fontFamily: 'Roboto'),
                          ),
                          Text(
                            'Дэд ангилал: ${product['subcategory']['name']}',
                            style: TextStyle(fontFamily: 'Roboto'),
                          ),
                        ],
                      ),
                      trailing: Image.network(
                        product['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      onTap:
                          () => _editProduct(context, product), // Edit action
                      onLongPress:
                          () => _deleteProduct(product['id']), // Delete action
                    ),
                  );
                },
              ),
            ),
            // Add buttons here for report and logout
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReportScreen(),
                      ),
                    );
                  },
                  child: const Text('Тайлан'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => _handleLogout(context),
                  child: const Text('Лог-аут'),
                ),
              ],
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
