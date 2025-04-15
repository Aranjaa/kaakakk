class UserProfile {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? profilePicture;
  final String? phone;
  final String createdAt;

  UserProfile({
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profilePicture,
    this.phone,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      profilePicture: json['profile_picture'],
      phone: json['phone'],
      createdAt: json['created_at'],
    );
  }

  @override
  String toString() {
    return 'UserProfile(username: $username, email: $email, firstName: $firstName, lastName: $lastName, profilePicture: $profilePicture, phone: $phone, createdAt: $createdAt)';
  }
}
