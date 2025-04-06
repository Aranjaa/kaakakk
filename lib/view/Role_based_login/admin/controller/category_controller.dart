import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/category_model.dart';

final categoryProvider = FutureProvider<List<Category>>((ref) async {
  final response = await http.get(
    Uri.parse('http://192.168.99.163:8000/api/categories/'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => Category.fromJson(item)).toList();
  } else {
    throw Exception("Failed to load categories");
  }
});
