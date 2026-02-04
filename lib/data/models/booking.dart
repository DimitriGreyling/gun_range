class Booking {
  String? id;
  String? userId;
  String? eventId;
  String? rangeId;
  String? status;
  String? paymentStatus;

  Booking({
    this.id,
    this.userId,
    this.eventId,
    this.rangeId,
    this.status,
    this.paymentStatus,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'],
        userId: json['user_id'],
        eventId: json['event_id'],
        rangeId: json['range_id'],
        status: json['status'],
        paymentStatus: json['payment_status'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'event_id': eventId,
        'range_id': rangeId,
        'status': status,
        'payment_status': paymentStatus,
      };
}
