class Range {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final Map<String, dynamic> facilities;
  final bool isActive;

  Range({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.facilities,
    required this.isActive,
  });

  factory Range.fromJson(Map<String, dynamic> json) => Range(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        facilities: json['facilities'] ?? {},
        isActive: json['is_active'] ?? true,
      );
}
