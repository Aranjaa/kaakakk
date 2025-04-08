import 'package:flutter/material.dart';
import 'package:shopping/views/Role_based_login/user/Widgets/curated_items.dart';
import '../Widgets/banner.dart';
import '../model/category_model.dart';
import '../model/product_model.dart';
import 'items_defail_screen.dart';
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
  // Энд өмнө нь байхгүй categoryItems-ийг устгаж, бүтээгдэхүүнийг ангилалаар шүүх products-ыг ашиглая.
  var _logger = Logger(); // Logger инициалчилсан

  @override
  void initState() {
    super.initState();
    // Скрин дүүрэхэд ангилал, бүтээгдэхүүнийг татаж авна.
    _fetchData();
  }

  // Ангилал, бүтээгдэхүүнийг татах функц
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
      _logger.e('Алдаа: $e'); // Алдааг логлосон
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
            // Header хэсэг: логог харуулах ба саганы дугаар
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
            // Баннер хэсэг
            const MyBanner(),
            // Ангилал гарчиг ба "Бүгдийг харах"
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
                    ),
                  ),
                  Text(
                    "Бүгдийг харах",
                    style: TextStyle(fontSize: 16, color: Colors.black45),
                  ),
                ],
              ),
            ),
            // Ангилалыг шалгах хэсэг
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
                            // Бүтээгдэхүүний жагсаалтаас тухайн ангиллын бүтээгдэхүүнийг шүүж байна.
                            final filterItems =
                                products
                                    .where(
                                      (item) =>
                                          item.category.name.toLowerCase() ==
                                          categories[index].name.toLowerCase(),
                                    )
                                    .toList();

                            // Энд CategoryItems хуудас руу шилжиж, ангиллын нэр ба шүүсэн бүтээгдэхүүнийг дамжуулж байна.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => CategoryItems(
                                      category: categories[index].name,
                                      categoryItems: filterItems,
                                      // Subcategories өгөгдөөгүй тул хоосон лист дамжуулж байна.
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
                                Text(categories[index].name),
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
            // "Танд зориулагдсан" бүтээгдэхүүний жагсаалт
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
