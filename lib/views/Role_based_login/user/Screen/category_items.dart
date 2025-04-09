import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/model/subcategory_model.dart';
import '../../../../core/model/product_model.dart';
import '../Widgets/curated_items.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import for cached network images

class CategoryItems extends StatelessWidget {
  final String category;
  final List<Product> categoryItems;
  final List<Subcategory> subcategories;

  const CategoryItems({
    super.key,
    required this.category,
    required this.categoryItems,
    required this.subcategories,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios_new),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(5),
                          hintText: "$category's Fashion",
                          hintStyle: TextStyle(color: Colors.black38),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(
                            Iconsax.search_normal,
                            color: Colors.black38,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Subcategory scroll
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: List.generate(
                    subcategories.length,
                    (index) => InkWell(
                      onTap: () {
                        // Filter logic here
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black26),
                        ),
                        child: Text(subcategories[index].name),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Product grid wrapped with Expanded widget
            categoryItems.isEmpty
                ? Center(
                  child: Text(
                    "Ангилал олдсонгүй",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                )
                : Expanded(
                  // Wrap GridView.builder inside Expanded widget
                  child: GridView.builder(
                    shrinkWrap: true, // Shrink the GridView to its content
                    physics:
                        NeverScrollableScrollPhysics(), // Disable gridview scroll
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: categoryItems.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      final item = categoryItems[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => CuratedItems(productModel: item),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product image
                            Container(
                              height: size.height * 0.25,
                              width: size.width * 0.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image:
                                      item.image.startsWith("http")
                                          ? CachedNetworkImageProvider(
                                            item.image,
                                          ) // For network images
                                          : AssetImage(item.image)
                                              as ImageProvider, // For local assets
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black26,
                                    child: Icon(
                                      Icons.favorite_border,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 7),

                            // Category name
                            Text(
                              item.category.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black26,
                                fontFamily: 'Roboto',
                              ),
                            ),

                            // Rating and reviews
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 17),
                                SizedBox(width: 2),
                                Text(item.rating.toStringAsFixed(1)),
                                SizedBox(width: 4),
                                Text(
                                  '(${item.reviews})',
                                  style: TextStyle(color: Colors.black26),
                                ),
                              ],
                            ),

                            // Product name
                            Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                fontFamily: 'Roboto',
                              ),
                            ),

                            // Price
                            Row(
                              children: [
                                Text(
                                  "\$${item.price}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.pink,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                SizedBox(width: 6),
                                if (item.isCheck)
                                  Text(
                                    "\$${(double.tryParse(item.price) ?? 0)}",
                                    style: TextStyle(
                                      color: Colors.black26,
                                      decoration: TextDecoration.lineThrough,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
