import 'package:flutter/material.dart';
import 'package:shopping/views/Role_based_login/loginscreen.dart';
import 'package:shopping/views/Role_based_login/user/Screen/user_app_home_srceen.dart';
import 'package:shopping/views/Role_based_login/user/Screen/SearchScreen.dart';
import 'package:shopping/views/Role_based_login/user/Screen/FavoriteScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScren extends StatefulWidget {
  const HomeScren({super.key});

  @override
  State<HomeScren> createState() => _HomeScrenState();
}

class _HomeScrenState extends State<HomeScren> {
  int selecedIndex = 0;

  final List<Widget> pages = [
    AppHomeScreen(),
    SearchScreen(),
    FavoriteScreen(),
    Loginscreen(),
  ];

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

  void handleNavigation(int index) async {
    // 2 = Favorites, 3 = Profile/Login
    if (index == 2 || index == 3) {
      bool loggedIn = await isLoggedIn();
      if (!loggedIn) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Эхлээд нэвтэрнэ үү')));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Loginscreen()),
        );
        return;
      }
    }

    setState(() {
      selecedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selecedIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black38,
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: selecedIndex,
        onTap: handleNavigation,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Нүүр'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Хайх'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Таалагдсан',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Нэвтрэх'),
        ],
      ),
    );
  }
}
