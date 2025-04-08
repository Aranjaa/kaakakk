import 'package:flutter/material.dart';
import 'package:shopping/views/Role_based_login/user/Screen/user_app_home_srceen.dart';

class UserAppFirstScreen extends StatefulWidget {
  const UserAppFirstScreen({super.key});

  @override
  State<UserAppFirstScreen> createState() => _UserAppFirstScreenState();
}

class _UserAppFirstScreenState extends State<UserAppFirstScreen> {
  int selecedIndex = 0;
  final List pages = [
    const AppHomeScreen(),
    const Scaffold(),
    const Scaffold(),
    const Scaffold(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black38,
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: selecedIndex,
        onTap: (value) {
          setState(() {
            selecedIndex = value; // Set the selected index here
          });
        },
        elevation: 0, // you can increase this value for a shadow effect
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Нүүр'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Хайх'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Мэдэгдэл',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профайл'),
        ],
      ),
      body: pages[selecedIndex], // Show selected page
    );
  }
}
