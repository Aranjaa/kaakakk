import 'package:flutter/material.dart';
import '../../FavoriteScreen.dart'; // Import FavoriteScreen

class SomeScreen extends StatelessWidget {
  const SomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Some Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteScreen(),
                ), // Remove const here
              );
            },
          ),
        ],
      ),
      body: const Center(child: Text('Your Screen Content')),
    );
  }
}
