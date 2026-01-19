class Profile {
  final String id;
  final String role;
  final String? fullName;

  const Profile({
    required this.id,
    required this.role,
    this.fullName,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      role: json['role'] as String,
      fullName: json['full_name'] as String?,
    );
  }

  bool get isMember => role == 'member';
  bool get isAdmin => role == 'admin';
  bool get isSuperAdmin => role == 'super_admin';
}
