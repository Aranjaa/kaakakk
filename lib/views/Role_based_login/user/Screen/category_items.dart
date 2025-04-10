import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/model/product_model.dart';
import '../../../../core/model/subcategory_model.dart';
import './items_detail_screen/screen/items_defail_screen.dart';

class CategoryItem extends StatelessWidget {
  final String category;
  final List<Product> categoryItems;
  final List<Subcategory> subcategories;

  const CategoryItem({
    super.key,
    required this.category,
    required this.categoryItems,
    required this.subcategories,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("Ангилал")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: categoryItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final item = categoryItems[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ItemsDefailScreen(productModel: item),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🖼 Зураг
                    Container(
                      height: size.height * 0.20,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        image: DecorationImage(
                          image:
                              item.image.startsWith("http")
                                  ? CachedNetworkImageProvider(item.image)
                                  : AssetImage(item.image) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.black26,
                            child: Icon(Icons.favorite_border, size: 16),
                          ),
                        ),
                      ),
                    ),

                    // 🔤 Текстүүд
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.category.name,
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 14),
                              SizedBox(width: 2),
                              Text(
                                item.rating.toStringAsFixed(1),
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "(${item.reviews})",
                                style: TextStyle(
                                  color: Colors.black26,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                "\$${item.price}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.pink,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                              SizedBox(width: 6),
                              if (item.isCheck)
                                Text(
                                  "\$${item.price}",
                                  style: TextStyle(
                                    color: Colors.black26,
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
