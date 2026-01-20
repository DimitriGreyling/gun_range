class Profile {
  final String id;
  final String role;
  final String? fullName;
  final String? themeMode;

  const Profile({
    required this.id,
    required this.role,
    this.fullName,
    this.themeMode,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      role: json['role'] as String,
      fullName: json['full_name'] as String?,
      themeMode: json['theme_mode'] as String?,
    );
  }

  bool get isMember => role == 'member';
  bool get isAdmin => role == 'admin';
  bool get isSuperAdmin => role == 'super_admin';
}
