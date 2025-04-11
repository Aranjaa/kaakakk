import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/core/Provider/FavoriteProvider.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch the favorite items when the screen is first loaded
    Provider.of<FavoriteProvider>(context, listen: false).fetchFavorites();

    return Scaffold(
      appBar: AppBar(title: Text('Таалагдсан бүтээгдэхүүнүүд')),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          // Check if there are no favorite items
          if (favoriteProvider.favoriteItems.isEmpty) {
            return Center(child: Text('Таалагдсан бүтээгдэхүүнүүд байхгүй.'));
          }

          // Display the list of favorite products
          return ListView.builder(
            itemCount: favoriteProvider.favoriteItems.length,
            itemBuilder: (context, index) {
              final wishlistItem = favoriteProvider.favoriteItems[index];
              final product = wishlistItem.product;

              return ListTile(
                title: Text(product.name),
                subtitle: Text("\$${product.price}"),
                leading: Image.network(product.image),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Removing from the wishlist
                    favoriteProvider.removeFromWishlist(wishlistItem.product);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
