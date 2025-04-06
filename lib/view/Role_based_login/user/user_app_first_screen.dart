import 'package:flutter/material.dart';
import 'package:shopping/services/api_service.dart';
import 'package:shopping/view/Role_based_login/loginscreen.dart';

class UserAppFirstScreen extends StatefulWidget {
  const UserAppFirstScreen({super.key});

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
  UserAppFirstScreenState createState() => UserAppFirstScreenState();
}

class UserAppFirstScreenState extends State<UserAppFirstScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: const Text('User screen'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed:
                () => widget._handleLogout(
                  context,
                ), // Access _handleLogout through widget
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Welcome User')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
