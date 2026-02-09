class BookingBlackout {
  String? id;
  DateTime? date;
  String? reason;

  BookingBlackout({
    this.id,
    this.date,
    this.reason,
  });

  factory BookingBlackout.fromJson(Map<String, dynamic> json) {
    return BookingBlackout(
      id: json['id'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      reason: json['reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date?.toIso8601String(),
      'reason': reason,
    };
  }
}