class Favorite {
  String? id;
  String? userId;
  String? rangeId;
  String? eventId;
  DateTime? createdAt;
  DateTime? modifiedDate;

  Favorite({
    this.id,
    this.userId,
    this.rangeId,
    this.createdAt,
    this.modifiedDate,
    this.eventId,
  });

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      id: map['id'] as String?,
      userId: map['user_id'] as String?,
      rangeId: map['range_id'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      modifiedDate: map['modified_date'] != null
          ? DateTime.parse(map['modified_date'] as String)
          : null,
      eventId: map['event_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'range_id': rangeId,
      'event_id': eventId,
      'created_at': createdAt?.toIso8601String(),
      'modified_date': modifiedDate?.toIso8601String(),
    };
  }
}
