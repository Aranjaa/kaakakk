import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shopping/services/api_service.dart';
import 'package:shopping/view/Role_based_login/singup_screen.dart';
import 'package:shopping/view/Role_based_login/admin/screen/admin_home_screen.dart';
import 'package:shopping/view/Role_based_login/user/user_app_first_screen.dart';
import 'package:logger/logger.dart'; // Importing logger package

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Initialize logger
  final Logger _logger = Logger();

  Future<void> _handleLogin() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response = await ApiService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (response.statusCode == 200) {
        // Decode the response body to a Map<String, dynamic>
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Extract role and token from the decoded JSON safely
        final String? role =
            responseData['role']; // This should be 'superuser' or 'user'
        final String? token = responseData['token']; // The token

        if (role == null || token == null) {
          _showErrorDialog('Нэвтэрэх үед алдаа гарлаа!');
          return;
        }

        // Save the token to SharedPreferences (for later use)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        // Handle role-based navigation
        if (role == 'superuser') {
          // Navigate to admin home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => AdminHomeScreen(),
            ), // Ensure AdminScreen is defined
          );
        } else if (role == 'user') {
          // Navigate to user home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => UserAppFirstScreen(),
            ), // Ensure UserScreen is defined
          );
        } else {
          // Handle unknown role
          _showErrorDialog('Нэвтэрэх үед алдаа гарлаа!');
        }

        _logger.i('Нэвтэрэх амжилттай');
      } else {
        // Handle login failure
        _logger.e('Нэвтэрч чадсангүй: ${response.body}');
        _showErrorDialog('Нэвтэрэх үед алдаа гарлаа!');
      }
    } catch (e) {
      _logger.e('Нэвтэрэх үед алдаа гарлаа: $e');
      _showErrorDialog('Нэвтэрэх үед алдаа гарлаа!');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Алдаа'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.asset("assets/2.jpg"),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child:
                      _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Login"),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Бүртгэлгүй юу?", style: TextStyle(fontSize: 18)),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SingUpscreen()),
                      );
                    },
                    child: Text(
                      "Энд бүртгүүлнэ үү.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
