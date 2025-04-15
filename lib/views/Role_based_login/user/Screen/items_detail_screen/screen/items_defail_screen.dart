import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../../../../../core/model/product_model.dart';
import '../../../../../../core/Provider/cart_provider.dart';
import '../../../../../../core/Provider/FavoriteProvider.dart';
import '../../cart_screen.dart'; // Import CartScreen
import '../../BuyNowScreen.dart';

class ItemsDefailScreen extends StatefulWidget {
  final Product productModel;
  const ItemsDefailScreen({super.key, required this.productModel});

  @override
  State<ItemsDefailScreen> createState() => _ItemsDefailScreenState();
}

class _ItemsDefailScreenState extends State<ItemsDefailScreen> {
  int currentIndex = 0;
  int selectedColorIndex = 0;
  int selectedSizeIndex = 0;
  Color selectedColor = Colors.blue;
  bool isFavorite = false; // Track favorite status

  void _addToCart() {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addToCart(widget.productModel); // Pass the quantity as well

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Бүтээгдэхүүн картанд нэмэгдлээ!')),
    );
  }

  void _buyNow() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => BuyNowScreen(
              productId: widget.productModel.id,
              price: widget.productModel.price.toDouble(), // <- Энэ хэсэг чухал
              quantity: 1,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final product = widget.productModel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black26,
        title: const Text("Бүтээгдэхүүн"),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_bag, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartScreen()),
                  );
                },
              ),
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
                          child: Text(
                            cart.totalItems.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                        : const SizedBox();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image and PageView
            Container(
              color: Colors.black26,
              height: size.height * 0.46,
              width: size.width,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Image.network(
                        product.image,
                        height: size.height * 0.4,
                        width: size.width * 0.85,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 7),
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:
                                  index == currentIndex
                                      ? Colors.blue
                                      : Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Product Details Section
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "H&M",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black26,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.star, color: Colors.amber, size: 17),
                      Text(product.rating.toString()),
                      Text(
                        '(${product.reviews})',
                        style: const TextStyle(color: Colors.black26),
                      ),
                      const Spacer(),
                      // Heart icon for favorite status
                      IconButton(
                        icon: Icon(
                          Icons.favorite_border,
                          color:
                              Provider.of<FavoriteProvider>(
                                    context,
                                  ).isProductInWishlist(widget.productModel)
                                  ? Colors.red
                                  : Colors.black26,
                        ),
                        onPressed: () {
                          final favoriteProvider =
                              Provider.of<FavoriteProvider>(
                                context,
                                listen: false,
                              );
                          if (favoriteProvider.isProductInWishlist(
                            widget.productModel,
                          )) {
                            favoriteProvider.removeFromWishlist(
                              widget.productModel,
                            ); // Remove from wishlist
                          } else {
                            favoriteProvider.addToWishlist(
                              widget.productModel,
                            ); // Add to wishlist
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.name,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "\$${product.price}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.pink,
                        ),
                      ),
                      const SizedBox(width: 5),
                      if (product.isCheck == true)
                        Text(
                          "\$${product.price}",
                          style: const TextStyle(
                            color: Colors.black26,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black38,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Color & Size selection (remaining unchanged)
                  // ...
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addToCart,
        backgroundColor: Colors.white,
        label: SizedBox(
          width: size.width * 0.9,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Iconsax.shopping_bag, color: Colors.black),
                      SizedBox(width: 10),
                      Text(
                        'Картанд нэмэх',
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  color: Colors.black,
                  child: GestureDetector(
                    onTap: _buyNow,
                    child: const Center(
                      child: Text(
                        'Худалдаж авах',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
