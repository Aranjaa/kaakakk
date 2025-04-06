import 'package:flutter/material.dart';
import 'package:shopping/services/api_service.dart';
import 'package:shopping/view/Role_based_login/loginscreen.dart';
import 'package:logger/logger.dart'; // Import the logger package

class SingUpscreen extends StatefulWidget {
  const SingUpscreen({super.key});

  @override
  State<SingUpscreen> createState() => _SingUpscreenState();
}

class _SingUpscreenState extends State<SingUpscreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Initialize the Logger
  final Logger _logger = Logger();

  Future<void> _handleSignUp() async {
    try {
      final response = await ApiService.register(
        _emailController.text,
        _usernameController.text,
        _firstnameController.text,
        _lastnameController.text,
        _passwordController.text,
      );

      if (response.statusCode == 201) {
        // Handle successful sign-up
        _logger.i('Амжилттай бүртгүүлэв'); // Using logger instead of print
        // Navigate to login page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Loginscreen()),
        );
      } else {
        // Handle sign-up failure
        _logger.e(
          'Бүртгүүлж чадсангүй: ${response.body}',
        ); // Using logger instead of print
      }
    } catch (e) {
      _logger.e(
        'Бүртгүүлэх явцад гарсан алдаа: $e',
      ); // Using logger instead of print
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset("assets/12.jpg"),
                SizedBox(height: 15),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _lastnameController,
                  decoration: InputDecoration(
                    labelText: "овог",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _firstnameController,
                  decoration: InputDecoration(
                    labelText: "нэр",
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
                SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSignUp,
                    child: Text("Sign Up"),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Бүртгэлтэй юу?", style: TextStyle(fontSize: 18)),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Loginscreen()),
                        );
                      },
                      child: Text(
                        "Энд нэвтэрнэ үү",
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
      ),
    );
  }
}
