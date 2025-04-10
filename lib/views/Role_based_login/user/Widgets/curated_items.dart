import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/model/product_model.dart';
import '../../../../core/Provider/FavoriteProvider.dart'; // Make sure this is imported

class CuratedItems extends StatelessWidget {
  final Product productModel;

  const CuratedItems({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Screen size

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(productModel.image),
            ),
          ),
          height: size.height * 0.25,
          width: size.width * 0.5,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black26,
                child: IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color:
                        Provider.of<FavoriteProvider>(
                              context,
                            ).favoriteItems.contains(productModel)
                            ? Colors.red
                            : Colors.black26,
                  ),
                  onPressed: () {
                    final favoriteProvider = Provider.of<FavoriteProvider>(
                      context,
                      listen: false,
                    );
                    if (favoriteProvider.favoriteItems.contains(productModel)) {
                      favoriteProvider.removeFromFavorites(
                        productModel,
                      ); // Remove from favorites
                    } else {
                      favoriteProvider.addToFavorites(
                        productModel,
                      ); // Add to favorites
                    }
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),

        // First row: category, rating, reviews
        Row(
          children: [
            Text(
              productModel.category.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black26,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(width: 5),
            const Icon(Icons.star, color: Colors.amber, size: 17),
            Text(
              productModel.rating.toString(),
              style: const TextStyle(fontFamily: 'Roboto'),
            ),
            Text(
              ' (${productModel.reviews})',
              style: const TextStyle(
                color: Colors.black26,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),

        // Second row: product name (no overflow)
        SizedBox(
          width: size.width * 0.5,
          child: Text(
            productModel.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.5,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        const SizedBox(height: 5),

        // Third row: price, discounted price
        Row(
          children: [
            Text(
              "\$${productModel.price.toString()}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Colors.pink,
                height: 1.5,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(width: 5),
            if (productModel.isCheck) // Check for discount
              Text(
                "\$${(productModel.price * 0.9).toStringAsFixed(2)}", // Assuming discount is 10%
                style: const TextStyle(
                  color: Colors.black26,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.black26,
                  fontFamily: 'Roboto',
                ),
              ),
          ],
        ),
      ],
    );
  }
}
