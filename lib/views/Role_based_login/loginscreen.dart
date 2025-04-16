import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shopping/services/api_service.dart';
import 'package:shopping/views/Role_based_login/singup_screen.dart';
import 'package:shopping/views/Role_based_login/admin/screen/admin_home_screen.dart';
import 'package:shopping/views/Role_based_login/user/Screen/user_app_first_screen.dart';
import 'package:logger/logger.dart'; // Importing logger package
import '../../core/Provider/auth_provider.dart';
import 'package:provider/provider.dart';

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
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String? role = responseData['role'];
        final String? token = responseData['token'];

        if (role == null || token == null) {
          _showErrorDialog('Нэвтэрэх үед алдаа гарлаа!');
          return;
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('role', role);

        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.login(token); // Нэмэгдсэн хэсэг

        if (role == 'superuser') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => AdminHomeScreen()),
          );
        } else if (role == 'user') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => UserAppFirstScreen()),
          );
        } else {
          _showErrorDialog('Роли тодорхойгүй байна!');
        }

        _logger.i('Нэвтрэх амжилттай');
      } else {
        // Handle login failure
        _logger.e('Нэвтэрч чадсангүй: ${response.body}');
        _showErrorDialog('Нэвтрэх үед алдаа гарлаа!');
      }
    } catch (e) {
      _logger.e('Нэвтрэх үед алдаа гарлаа: $e');
      _showErrorDialog('Нэвтрэх үед алдаа гарлаа!');
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
          child: SingleChildScrollView(
            // <-- Add this
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/2.jpg"),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  style: TextStyle(fontFamily: 'Roboto'),
                  decoration: InputDecoration(
                    labelText: "Майл хаяг",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  style: TextStyle(fontFamily: 'Roboto'),
                  decoration: InputDecoration(
                    labelText: "Нууц үг",
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
                            : Text(
                              "Нэвтрэх",
                              style: TextStyle(fontFamily: 'Roboto'),
                            ),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Бүртгэлгүй юу?",
                      style: TextStyle(fontSize: 18, fontFamily: 'Roboto'),
                    ),
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
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20), // Optional: to provide bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }
}
