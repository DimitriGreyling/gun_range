class Range {
  String? id;
  String? name;
  String? description;
  double? latitude;
  double? longitude;
  List<Facility>? facilities;
  bool? isActive;
  String? contactNumber;

  double? nspDistanceInKilometers;

  bool nspIsFavorite = false;
  List<String> nspPhotoUrls = [];

  Range({
    this.id,
    this.name,
    this.description,
    this.latitude,
    this.longitude,
    this.facilities,
    this.isActive,
    this.nspIsFavorite = false,
    this.nspPhotoUrls = const [],
    this.contactNumber,
  });

  factory Range.fromJson(Map<String, dynamic> json) => Range(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        facilities: json['facilities'] != null
            ? (json['facilities'] as List)
                .map((fac) => Facility.fromJson(fac))
                .toList()
            : [],
        isActive: json['is_active'] ?? true,
        contactNumber: json['contact_number'],
      );
}

class Facility {
  String? facilityId;

  Facility({
    this.facilityId,
  });

  factory Facility.fromJson(Map<String, dynamic> json) => Facility(
        facilityId: json['facility_id'],
      );
}
