import 'package:flutter/material.dart';
import 'package:shopping/services/api_service.dart';
import 'package:shopping/view/Role_based_login/admin/screen/add_item_screen.dart';
import 'package:shopping/view/Role_based_login/loginscreen.dart'; // Import your login screen

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  // Logout function
  Future<void> _handleLogout(BuildContext context) async {
    await ApiService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Loginscreen(),
      ), // Redirect to login screen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: const Text('Admin screen'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed:
                () => _handleLogout(context), // Logout when button is pressed
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Welcome Admin')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () async {
          await Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const AddItems()));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
