class Booking {
  final String id;
  final String userId;
  final String eventId;
  final String status;
  final String paymentStatus;

  Booking({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.status,
    required this.paymentStatus,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'],
        userId: json['user_id'],
        eventId: json['event_id'],
        status: json['status'],
        paymentStatus: json['payment_status'],
      );
}
