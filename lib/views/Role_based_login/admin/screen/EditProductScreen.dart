import 'package:flutter/material.dart';
import 'package:shopping/services/api_service.dart';
import 'package:shopping/core/model/product_model.dart';

class EditProductScreen extends StatefulWidget {
  final dynamic product;

  const EditProductScreen({super.key, required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product['name']);
    _priceController = TextEditingController(
      text: widget.product['price'].toString(),
    );
    _stockController = TextEditingController(
      text: widget.product['stock'].toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.product['description'],
    );
  }

  Future<void> _saveProduct() async {
    final updatedProduct = Product(
      id: widget.product['id'],
      name: _nameController.text,
      price: double.parse(_priceController.text),
      stock: int.parse(_stockController.text),
      description: _descriptionController.text,
      image: widget.product['image'], // Add the image parameter
      category: widget.product['category'], // Add the category parameter
      subcategory:
          widget.product['subcategory'], // Add the subcategory parameter
      rating: widget.product['rating'], // Add the rating parameter
      reviews: widget.product['reviews'], // Add the reviews parameter
      isCheck: widget.product['isCheck'], // Add the isCheck parameter
      color: widget.product['color'], // Add the color parameter
      size: widget.product['size'], // Add the size parameter
    );

    try {
      // Create an instance of ApiService and call the method
      final apiService = ApiService(); // Create an instance of ApiService
      final success = await apiService.editProduct(
        updatedProduct,
      ); // Call the instance method

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Бүтээгдэхүүн амжилттай шинэчилсэн')),
        );
        Navigator.pop(context); // Go back to the product list
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Бүтээгдэхүүн шинэчлэхэд алдаа гарлаа: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Бүтээгдэхүүн засах')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Нэр'),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Үнэ'),
            ),
            TextField(
              controller: _stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Сагсанд байгаа тоо',
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Тайлбар'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  _saveProduct, // Call _saveProduct when the button is pressed
              child: const Text('Шинэчлэх'),
            ),
          ],
        ),
      ),
    );
  }
}
