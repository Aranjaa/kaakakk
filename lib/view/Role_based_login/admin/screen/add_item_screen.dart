import 'dart:async';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../model/category_model.dart';
import '../model/subcategory_model.dart';
import '../model/add_item_model.dart';
import '../controller/add_item_controller.dart';

final Logger _logger = Logger();

class AddItems extends StatefulWidget {
  const AddItems({super.key});

  @override
  AddItemsState createState() => AddItemsState();
}

class AddItemsState extends State<AddItems> {
  final ApiController _apiController = ApiController();
  List<Category> _categories = [];
  List<Subcategory> _subcategories = [];
  List<Product> _products = [];

  Map<String, int> _categoriesMap = {}; // category name -> id
  final Map<int, List<Subcategory>> _subcategoriesByCategory = {};

  List<Subcategory> _filteredSubcategories = [];

  String? _selectedCategory;
  String? _selectedSubcategory;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    try {
      final categories = await _apiController.fetchCategories();
      final subcategories = await _apiController.fetchSubcategories();
      final products = await _apiController.fetchProducts();

      setState(() {
        _categories = categories;
        _subcategories = subcategories;
        _products = products;
        _categoriesMap = {for (var item in _categories) item.name: item.id};

        _subcategoriesByCategory.clear();
        for (var sub in _subcategories) {
          _subcategoriesByCategory
              .putIfAbsent(sub.categoryId, () => [])
              .add(sub);
        }
        _isLoading = false;
      });
    } catch (e) {
      _logger.e('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Add Item')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Item Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Select Category:'),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedCategory,
                        hint: const Text('Choose Category'),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                            _selectedSubcategory = null;
                            final selectedCategoryId =
                                _categoriesMap[newValue]!;
                            _filteredSubcategories =
                                _subcategoriesByCategory[selectedCategoryId] ??
                                [];
                          });
                        },
                        items:
                            _categories
                                .map(
                                  (cat) => DropdownMenuItem<String>(
                                    value: cat.name,
                                    child: Text(cat.name),
                                  ),
                                )
                                .toList(),
                      ),
                      const SizedBox(height: 10),
                      if (_filteredSubcategories.isNotEmpty) ...[
                        const Text('Select Subcategory:'),
                        DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedSubcategory,
                          hint: const Text('Choose Subcategory'),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedSubcategory = newValue;
                            });
                          },
                          items:
                              _filteredSubcategories
                                  .map(
                                    (sub) => DropdownMenuItem<String>(
                                      value: sub.name,
                                      child: Text(sub.name),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
                      const SizedBox(height: 20),
                      const Text('Fetched Products:'),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              leading: Image.network(
                                product.imageUrl,
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) =>
                                        const Icon(Icons.broken_image),
                              ),
                              title: Text(product.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Category: ${product.category.name}'),
                                  Text('Description: ${product.description}'),
                                  Text('Price: ${product.price}'),
                                  Text('Stock: ${product.stock}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
