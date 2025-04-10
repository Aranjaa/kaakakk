class UserProfile {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String profilePicture;
  final String? phone;
  final String createdAt;

  UserProfile({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    this.phone,
    required this.createdAt,
  });

  // A factory constructor to convert JSON to a UserProfile object
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      profilePicture: json['profile_picture'],
      phone: json['phone'],
      createdAt: json['created_at'],
    );
  }
}
