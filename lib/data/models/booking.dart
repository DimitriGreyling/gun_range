class Booking {
  String? id;
  String? bookedBy;
  String? eventId;
  String? rangeId;
  String? status;
  String? paymentStatus;

  Booking({
    this.id,
    this.bookedBy,
    this.eventId,
    this.rangeId,
    this.status,
    this.paymentStatus,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'],
        bookedBy: json['booked_by'],
        eventId: json['event_id'],
        rangeId: json['range_id'],
        status: json['status'],
        paymentStatus: json['payment_status'],
      );

  Map<String, dynamic> toJson() => {
        'booked_by': bookedBy,
        'event_id': eventId,
        'range_id': rangeId,
        'status': status,
        'payment_status': paymentStatus,
      };
}
