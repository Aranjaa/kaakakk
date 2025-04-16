import 'package:flutter/material.dart';
import 'package:shopping/services/api_service.dart';
import 'package:shopping/views/home.dart';
import '../../../../core/model/user_profile_model.dart';
import 'package:logger/logger.dart'; // HomeScreen импорт

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserProfile> profileFuture;
  final _logger = Logger();

  @override
  void initState() {
    super.initState();
    profileFuture = _fetchUserProfile(); // Хэрэглэгчийн профайлыг татах
  }

  Future<UserProfile> _fetchUserProfile() async {
    try {
      final profileData = await ApiService.fetchUserProfile();
      _logger.i("Profile data: $profileData");
      return profileData;
    } catch (e) {
      _logger.e("Error fetching profile: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профайл')),
      body: FutureBuilder<UserProfile>(
        future: profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Алдаа гарлаа: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Мэдээлэл олдсонгүй'));
          }

          final profile = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    profile.profilePicture ?? 'https://default_image.com',
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Нэвтрэх нэр: ${profile.username}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'И-мэйл: ${profile.email}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Нэр: ${profile.firstName} ${profile.lastName}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Утас: ${profile.phone ?? "Байхгүй"}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await ApiService
                        .logout(); // Токен болон хэрэглэгчийн мэдээллийг цэвэрлэх
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => HomeScren()), // HomeScreen руу шилжих
                    );
                  },
                  child: const Text('Гарах'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
