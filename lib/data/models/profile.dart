class Profile {
  final String id;
  final String role;

  const Profile({
    required this.id,
    required this.role,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      role: json['role'] as String,
    );
  }

  bool get isMember => role == 'member';
  bool get isAdmin => role == 'admin';
  bool get isSuperAdmin => role == 'super_admin';
}
