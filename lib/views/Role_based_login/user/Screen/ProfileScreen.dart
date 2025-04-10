import 'package:flutter/material.dart';
import 'package:shopping/services/api_service.dart';
import 'package:shopping/core/model/profiles_model.dart';
import 'package:logger/logger.dart';
import 'package:image_picker/image_picker.dart'; // Add this import for image picking
import 'dart:io'; // To handle image files
import 'package:shopping/views/Role_based_login/loginscreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserProfile> profileFuture;
  final _logger = Logger();
  File? _image;

  @override
  void initState() {
    super.initState();
    profileFuture = _fetchUserProfile(); // Fetch user profile on screen load
  }

  Future<void> _handleLogout(BuildContext context) async {
    await ApiService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Loginscreen()),
    );
  }

  Future<UserProfile> _fetchUserProfile() async {
    try {
      // Fetch the logged-in user's profile
      final profileData = await ApiService.fetchUserProfile();

      _logger.i(
        "Profile data: $profileData",
      ); // Log the profile data for debugging

      if (profileData.isNotEmpty) {
        return UserProfile.fromJson(
          profileData[0],
        ); // Assuming the response is an array
      } else {
        _logger.e("No profiles found.");
        throw Exception("No profiles found");
      }
    } catch (e) {
      _logger.e("Error fetching profile: $e");
      rethrow;
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
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
                  backgroundImage:
                      _image != null
                          ? FileImage(_image!)
                          : NetworkImage(profile.profilePicture)
                              as ImageProvider,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor:
                        Theme.of(context).primaryColor, // Set background color
                    shadowColor: Colors.black.withOpacity(0.1),
                  ),
                  child: const Text(
                    'Зураг сонгох',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 16),
                // User Profile Info
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
                const Spacer(), // Push the logout button to the bottom
                // Logout Button
                ElevatedButton(
                  onPressed: () => _handleLogout(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.redAccent, // Red color for logout
                    shadowColor: Colors.black.withOpacity(0.1),
                  ),
                  child: const Text(
                    'Гарах',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
