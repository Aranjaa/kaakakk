import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/core/Provider/FavoriteProvider.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Таалагдсан бүтээгдэхүүнүүд')),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          if (favoriteProvider.favoriteItems.isEmpty) {
            return Center(child: Text('Таалагдсан бүтээгдэхүүнүүд байхгүй.'));
          }
          return ListView.builder(
            itemCount: favoriteProvider.favoriteItems.length,
            itemBuilder: (context, index) {
              final product = favoriteProvider.favoriteItems[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text("\$${product.price}"),
                leading: Image.network(product.image),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Remove the product from favorites
                    favoriteProvider.removeFromFavorites(product);
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
