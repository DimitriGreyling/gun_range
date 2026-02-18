import 'dart:async';

class Booking {
  String? id;
  String? bookedBy;
  String? eventId;
  String? rangeId;
  String? status;
  String? paymentStatus;
  DateTime? bookingDate;
  DateTime? startTime;
  DateTime? endTime;

  Booking({
    this.id,
    this.bookedBy,
    this.eventId,
    this.rangeId,
    this.status,
    this.paymentStatus,
    this.bookingDate,
    this.startTime,
    this.endTime,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'],
        bookedBy: json['booked_by'],
        eventId: json['event_id'],
        rangeId: json['range_id'],
        status: json['status'],
        paymentStatus: json['payment_status'],
        bookingDate: json['booking_date'] != null ? DateTime.parse(json['booking_date']) : null,
        startTime: json['start_time'] != null ? DateTime.parse(json['start_time']) : null,
        endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      );

  Map<String, dynamic> toJson() => {
        'booked_by': bookedBy,
        'event_id': eventId,
        'range_id': rangeId,
        'status': status,
        'payment_status': paymentStatus,
        'booking_date': bookingDate?.toIso8601String(),
        'start_time': startTime?.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
      };

  Booking copyWith({
    String? id,
    String? bookedBy,
    String? eventId,
    String? rangeId,
    String? status,
    String? paymentStatus,
    DateTime? bookingDate,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return Booking(
      id: id ?? this.id,
      bookedBy: bookedBy ?? this.bookedBy,
      eventId: eventId ?? this.eventId,
      rangeId: rangeId ?? this.rangeId,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      bookingDate: bookingDate ?? this.bookingDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
