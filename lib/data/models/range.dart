class Range {
  String? id;
  String? name;
  String? description;
  double? latitude;
  double? longitude;
  Map<String, dynamic> facilities;
  bool? isActive;

  bool nspIsFavorite = false;

  Range({
    this.id,
    this.name,
    this.description,
    this.latitude,
    this.longitude,
    this.facilities = const {},
    this.isActive,
    this.nspIsFavorite = false,
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
