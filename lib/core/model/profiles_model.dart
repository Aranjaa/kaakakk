class UserProfile {
  final int user;
  final String profilePicture;
  final String? phone;
  final DateTime createdAt;

  UserProfile({
    required this.user,
    required this.profilePicture,
    this.phone,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      user: json['user'] ?? 0,
      profilePicture: json['profile_picture'] ?? '',
      phone: json['phone'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'profile_picture': profilePicture,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
