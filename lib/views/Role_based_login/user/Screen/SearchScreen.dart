import 'package:flutter/material.dart';
import 'package:shopping/services/api_service.dart';
import '../../../../core/model/product_model.dart';
import '../Widgets/curated_items.dart'; // Import the CuratedItems widget

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product> searchResults = [];
  bool isLoading = false;
  String query = '';

  void performSearch(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await ApiService.searchProducts(query);
      setState(() {
        searchResults = data.map((e) => Product.fromJson(e)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Алдаа гарлаа: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Бүтээгдэхүүн хайх")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) {
                query = value;
                performSearch(query);
              },
              decoration: InputDecoration(
                hintText: 'Бүтээгдэхүүний нэрээр хайх...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Expanded(
              child:
                  searchResults.isEmpty
                      ? const Center(child: Text('Үр дүн олдсонгүй'))
                      : ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final product = searchResults[index];
                          return ListTile(
                            leading: Image.network(product.image, width: 60),
                            title: Text(product.name),
                            subtitle: Text('${product.price}₮'),
                            onTap: () {
                              // Navigate to CuratedItems screen and pass the selected product
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          CuratedItems(productModel: product),
                                ),
                              );
                            },
                          );
                        },
                      ),
            ),
        ],
      ),
    );
  }
}
