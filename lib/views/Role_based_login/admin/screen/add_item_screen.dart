import 'dart:async';
import 'dart:io'; // To handle file system
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import '../model/add_item_model.dart'; // Import your Product model
import '../controller/apicontroller.dart'; // Your ApiController

final Logger _logger = Logger();

class AddItems extends StatefulWidget {
  const AddItems({super.key});

  @override
  AddItemsState createState() => AddItemsState();
}

class AddItemsState extends State<AddItems> {
  final ApiController _apiController = ApiController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  List<Category> _categories = [];
  List<Subcategory> _subcategories = [];

  String? _selectedCategory;
  String? _selectedSubcategory;

  List<Subcategory> _filteredSubcategories = []; // Define the filtered list

  bool _isLoading = false;
  String? _errorMessage;

  File? _imageFile; // File to hold the selected image

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    try {
      // Fetch categories
      final categories = await _apiController.fetchCategories();
      if (categories.isEmpty) {
        _setErrorState('Ангилал өгөгдөл хоосон байна');
        return;
      }

      // Fetch subcategories
      final subcategories = await _apiController.fetchSubcategories();
      if (subcategories.isEmpty) {
        _setErrorState('Дэд ангилал өгөгдөл хоосон байна');
        return;
      }

      setState(() {
        _categories = categories;
        _subcategories = subcategories;
      });
    } catch (e) {
      _setErrorState('Алдаа гарлаа: $e');
    }
  }

  void _setErrorState(String message) {
    setState(() {
      _isLoading = false;
      _errorMessage = message;
    });
    _logger.e(message);
  }

  Future<void> _addItem() async {
    if (_selectedCategory == null || _selectedSubcategory == null) {
      setState(() {
        _errorMessage = 'Ангилал ба дэд ангиллыг сонгоно уу';
      });
      return;
    }

    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _stockController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Бүх талбарыг бөглөх ёстой';
      });
      return;
    }

    // Validate price and stock
    if (double.tryParse(_priceController.text) == null ||
        int.tryParse(_stockController.text) == null) {
      setState(() {
        _errorMessage = 'Үнэ болон хувьцааны хүчинтэй дугаарыг оруулна уу';
      });
      return;
    }

    // Ensure an image is selected
    if (_imageFile == null) {
      setState(() {
        _errorMessage = 'Зураг сонгоно уу';
      });
      return;
    }

    final category = _categories.firstWhere(
      (cat) => cat.name == _selectedCategory!,
    );
    final subcategory = _subcategories.firstWhere(
      (sub) => sub.name == _selectedSubcategory!,
    );

    final product = Product(
      id: 0, // Assuming ID is auto-generated by backend
      name: _nameController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      stock: int.parse(_stockController.text),
      imageUrl: 'image_url_placeholder', // This will be the path to the image
      category: category,
      subcategory: subcategory,
      color: [], // Example, implement color selection if needed
      size: [], // Example, implement size selection if needed
    );

    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await _apiController.addProduct(product);
      if (success) {
        setState(() {
          _isLoading = false;
          _errorMessage = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Бүтээгдэхүүн амжилттай нэмэгдлээ')),
        );
        // Optionally clear form or navigate back
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Бүтээгдэхүүн нэмэхэд алдаа гарлаа';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Алдаа гарлаа: $e';
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      setState(() {
        _errorMessage = 'Зураг сонгоогүй байна';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Бүтээгдэхүүн нэмэх'),
      ),
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
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:
                                _imageFile == null
                                    ? const Icon(Icons.camera_alt, size: 50)
                                    : Image.file(
                                      _imageFile!,
                                      fit: BoxFit.cover,
                                    ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(fontFamily: 'Roboto'),
                        decoration: const InputDecoration(
                          labelText: 'Бүтээгдэхүүний нэр',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontFamily: 'Roboto'),
                        decoration: const InputDecoration(
                          labelText: 'Үнэ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _descriptionController,
                        style: const TextStyle(fontFamily: 'Roboto'),
                        decoration: const InputDecoration(
                          labelText: 'Тайлбар',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _stockController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontFamily: 'Roboto'),
                        decoration: const InputDecoration(
                          labelText: 'Хувьцааны дугаар',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Ангилал:',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.black,
                        ),
                      ),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedCategory,
                        hint: const Text('Ангилал сонгоно уу'),
                        dropdownColor: Colors.white,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                            _selectedSubcategory = null;
                            _filteredSubcategories =
                                _subcategories
                                    .where(
                                      (sub) =>
                                          sub.categoryId ==
                                          _categories
                                              .firstWhere(
                                                (cat) => cat.name == newValue,
                                              )
                                              .id,
                                    )
                                    .toList();
                          });
                        },
                        items:
                            _categories.map((cat) {
                              return DropdownMenuItem<String>(
                                value: cat.name,
                                child: Text(cat.name),
                              );
                            }).toList(),
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedSubcategory,
                        hint: const Text('Дэд ангилал сонгоно уу'),
                        dropdownColor: Colors.white,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedSubcategory = newValue;
                          });
                        },
                        items:
                            _filteredSubcategories.map((sub) {
                              return DropdownMenuItem<String>(
                                value: sub.name,
                                child: Text(sub.name),
                              );
                            }).toList(),
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _addItem,
                        child: const Text('Бүтээгдэхүүн нэмэх'),
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 20),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
    );
  }
}
