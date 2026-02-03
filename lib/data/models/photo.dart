class Photo {
  String? id;
  String? url;
  DateTime? modifiedDate;
  DateTime? createdAt;
  String? rangeId;
  String? eventId;

  Photo({
    this.id,
    this.url,
    this.modifiedDate,
    this.createdAt,
    this.rangeId,
    this.eventId,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as String?,
      url: json['url'] as String?,
      modifiedDate: json['modified_date'] != null
          ? DateTime.parse(json['modified_date'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      rangeId: json['range_id'] as String?,
      eventId: json['event_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'modified_date': modifiedDate?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'range_id': rangeId,
      'event_id': eventId,
    };
  }
}