import 'package:flutter/material.dart';
import 'package:shopping/views/Role_based_login/user/Widgets/curated_items.dart';
import '../Widgets/banner.dart';
import '../../../../core/model/category_model.dart';
import '../../../../core/model/product_model.dart';
import 'items_detail_screen/screen/items_defail_screen.dart';
import '../../../../services/api_service.dart';
import 'package:logger/logger.dart';
import 'category_items.dart';
// Сагсны дэлгэцээ импортлоорой
import 'cart_screen.dart'; // ← энэ мөрийг өөрийн замаар тохируул
import 'package:provider/provider.dart';
import '../../../../core/Provider/cart_provider.dart';
import '../../loginscreen.dart';

class AppHomeScreen extends StatefulWidget {
  const AppHomeScreen({super.key});

  @override
  State<AppHomeScreen> createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen> {
  List<Category> categories = [];
  List<Product> products = [];
  var _logger = Logger();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Хэрвээ токен байхгүй эсвэл хугацаа дууссан бол категорийн болон бүтээгдэхүүний мэдээллийг ямар ч тохиолдолд авахыг оролдох
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
        _isLoading = false;
      });
    } catch (e) {
      _logger.e('Алдаа: $e');
      setState(() {
        _isLoading = false;
      });

      // Хэрвээ токен буруу эсвэл хугацаа дууссан бол хэрэглэгчийг нэвтрүүлэх
      if (e.toString().contains('Токен алдаатай эсвэл хугацаа дууссан')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Токен алдаатай эсвэл хугацаа дууссан. Нэвтэрнэ үү.'),
          ),
        );

        // Нэвтрэх дэлгэц рүү шилжих
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Loginscreen()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Алдаа гарлаа: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Shopping",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -2,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => CartScreen()),
                              );
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(Icons.shopping_bag, size: 28),
                                Positioned(
                                  right: -3,
                                  top: -5,
                                  child: Consumer<CartProvider>(
                                    builder: (context, cart, child) {
                                      return cart.totalItems > 0
                                          ? Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                cart.totalItems.toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                          : const SizedBox.shrink();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const MyBanner(),
                    // Ангилал харах хэсэг
                    categories.isEmpty
                        ? const Center(child: Text("Ангилал олдсонгүй"))
                        : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(categories.length, (index) {
                              return InkWell(
                                onTap: () {
                                  final filterItems =
                                      products
                                          .where(
                                            (item) =>
                                                item.category.name
                                                    .toLowerCase() ==
                                                categories[index].name
                                                    .toLowerCase(),
                                          )
                                          .toList();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => CategoryItem(
                                            category: categories[index].name,
                                            categoryItems: filterItems,
                                            subcategories: [],
                                          ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      Text(
                                        categories[index].name,
                                        style: const TextStyle(
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                    // Бүтээгдэхүүн харах хэсэг
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Танд зориулагдсан",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          Text(
                            "Бүгдийг харах",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black45,
                            ),
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
