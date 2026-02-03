class Review {
  String? id;
  String? rangeId;
  String? eventId;
  String? userId;
  String? description;
  String? title;
  DateTime? createdAt;
  DateTime? modifiedDate;
  int? rating;

  Review({
    this.id,
    this.rangeId,
    this.eventId,
    this.userId,
    this.description,
    this.title,
    this.createdAt,
    this.modifiedDate,
    this.rating,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] as String?,
      rangeId: map['range_id'] as String?,
      eventId: map['event_id'] as String?,
      userId: map['user_id'] as String?,
      description: map['description'] as String?,
      title: map['title'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      modifiedDate: map['modified_date'] != null
          ? DateTime.parse(map['modified_date'] as String)
          : null,
      rating: map['rating'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'range_id': rangeId,
      'event_id': eventId,
      'user_id': userId,
      'description': description,
      'title': title,
      'created_at': createdAt?.toIso8601String(),
      'modified_date': modifiedDate?.toIso8601String(),
      'rating': rating,
    };
  }
}
