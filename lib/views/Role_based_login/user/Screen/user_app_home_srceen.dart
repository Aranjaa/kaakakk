import 'package:flutter/material.dart';
import 'package:shopping/views/Role_based_login/user/Widgets/curated_items.dart';
import '../Widgets/banner.dart';
import '../../../../core/model/category_model.dart';
import '../../../../core/model/product_model.dart';
import 'items_detail_screen/screen/items_defail_screen.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../services/api_service.dart';
import 'package:logger/logger.dart'; // Logger ашигласан
import 'category_items.dart';

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({super.key});

  @override
  State<AppHomeScreen> createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen> {
  List<Category> categories = [];
  List<Product> products = [];
  var _logger = Logger();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      List<Map<String, dynamic>> fetchedCategories =
          List<Map<String, dynamic>>.from(await ApiService.fetchCategories());
      List<Map<String, dynamic>> fetchedProducts =
          List<Map<String, dynamic>>.from(await ApiService.getProducts());

      setState(() {
        categories =
            fetchedCategories
                .map((categoryJson) => Category.fromJson(categoryJson))
                .toList();
        products =
            fetchedProducts
                .map((productJson) => Product.fromJson(productJson))
                .toList();
      });
    } catch (e) {
      _logger.e('Алдаа: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("assets/123.jpg"),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Iconsax.shopping_bag, size: 28),
                      Positioned(
                        right: -3,
                        top: -5,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              "3",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const MyBanner(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ангилал",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto', // Roboto шрифт
                    ),
                  ),
                  Text(
                    "Бүгдийг харах",
                    style: TextStyle(fontSize: 16, color: Colors.black45),
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: _fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Алдаа: ${snapshot.error}'));
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(categories.length, (index) {
                        return InkWell(
                          onTap: () {
                            final filterItems =
                                products
                                    .where(
                                      (item) =>
                                          item.category.name.toLowerCase() ==
                                          categories[index].name.toLowerCase(),
                                    )
                                    .toList();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => CategoryItems(
                                      category: categories[index].name,
                                      categoryItems: filterItems,
                                      subcategories: [],
                                    ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  categories[index].name,
                                  style: TextStyle(
                                    fontFamily: 'Roboto', // Roboto шрифт
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Танд зориулагдсан",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto', // Roboto шрифт
                    ),
                  ),
                  Text(
                    "Бүгдийг харах",
                    style: TextStyle(fontSize: 16, color: Colors.black45),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(products.length, (index) {
                  final productModel = products[index];
                  return Padding(
                    padding:
                        index == 0
                            ? const EdgeInsets.symmetric(horizontal: 20)
                            : const EdgeInsets.only(right: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ItemsDefailScreen(
                                  productModel: productModel,
                                ),
                          ),
                        );
                      },
                      child: CuratedItems(productModel: productModel),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
