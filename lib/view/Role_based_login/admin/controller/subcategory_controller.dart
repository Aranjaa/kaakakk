import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/subcategory_model.dart';

final subcategoryProvider = FutureProvider<List<Subcategory>>((ref) async {
  final response = await http.get(
    Uri.parse('http://192.168.99.163:8000/api/subcategories/'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((sub) => Subcategory.fromJson(sub)).toList();
  } else {
    throw Exception("Failed to load subcategories");
  }
});
