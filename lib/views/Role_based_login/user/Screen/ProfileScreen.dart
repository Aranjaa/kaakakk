import 'package:flutter/material.dart';
import 'package:shopping/services/api_service.dart';
import 'package:shopping/core/model/profiles_model.dart'; // Таны UserProfile классыг энд импорт хийх хэрэгтэй

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserProfile> profileFuture;

  @override
  void initState() {
    super.initState();
    profileFuture =
        ApiService.fetchUserProfile(); // Хэрэглэгчийн профайлыг авна
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

          final profile = snapshot.data!; // Хэрэглэгчийн профайлыг авах
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(profile.profilePicture),
                ),
                const SizedBox(height: 16),
                Text(
                  'Хэрэглэгч ID: ${profile.user}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Утас: ${profile.phone ?? "Байхгүй"}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Бүртгүүлсэн огноо: ${profile.createdAt.toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
