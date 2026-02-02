class Favorite {
  String? id;
  String? userId;
  String? rangeId;
  DateTime? createdAt;
  DateTime? modifiedDate;

  Favorite({
    this.id,
    this.userId,
    this.rangeId,
    this.createdAt,
    this.modifiedDate,
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'range_id': rangeId,
      'created_at': createdAt?.toIso8601String(),
      'modified_date': modifiedDate?.toIso8601String(),
    };
  }
}
