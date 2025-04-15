import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/views/home.dart';
import 'core/Provider/cart_provider.dart';
import 'core/Provider/FavoriteProvider.dart'; // Provider class

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider(),
        ), // Add FavoriteProvider here
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      home: const HomeScren(),
    );
  }
}
