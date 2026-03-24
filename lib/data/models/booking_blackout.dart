class BookingBlackout {
  String? id;
  DateTime? date;
  String? reason;
  String? rangeId;

  BookingBlackout({
    this.id,
    this.date,
    this.reason,
    this.rangeId,
  });

  factory BookingBlackout.fromJson(Map<String, dynamic> json) {
    return BookingBlackout(
      id: json['id'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      reason: json['reason'],
      rangeId: json['range_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'reason': reason,
      'range_id':rangeId,
    };
  }
}