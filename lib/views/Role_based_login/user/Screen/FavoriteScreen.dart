import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping/core/Provider/FavoriteProvider.dart';
import 'package:shopping/views/Role_based_login/loginscreen.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool _isLoading = true;

  Future<void> _checkLoginAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      // Нэвтрээгүй бол Loginscreen рүү хандуулна
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Loginscreen()),
        );
      }
    } else {
      // Нэвтэрсэн бол wishlist-ээ татна
      await Provider.of<FavoriteProvider>(
        context,
        listen: false,
      ).fetchFavorites();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginAndFetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Таалагдсан бүтээгдэхүүнүүд')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Consumer<FavoriteProvider>(
                builder: (context, favoriteProvider, child) {
                  if (favoriteProvider.favoriteItems.isEmpty) {
                    return Center(
                      child: Text('Таалагдсан бүтээгдэхүүнүүд байхгүй.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: favoriteProvider.favoriteItems.length,
                    itemBuilder: (context, index) {
                      final wishlistItem =
                          favoriteProvider.favoriteItems[index];
                      final product = wishlistItem.product;

                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text("\$${product.price}"),
                        leading: Image.network(product.image),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            favoriteProvider.removeFromWishlist(product);
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
