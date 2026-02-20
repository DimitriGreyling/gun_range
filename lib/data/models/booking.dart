import 'dart:async';

class Booking {
  String? id;
  String? bookedBy;
  String? eventId;
  String? rangeId;
  String? status;
  String? paymentStatus;
  DateTime? bookedDate;
  DateTime? startTime;
  DateTime? endTime;

  Booking({
    this.id,
    this.bookedBy,
    this.eventId,
    this.rangeId,
    this.status,
    this.paymentStatus,
    this.bookedDate,
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
        bookedDate: json['booked_date'] != null ? DateTime.parse(json['booked_date']) : null,
        startTime: json['start_time'] != null ? DateTime.parse(json['start_time']) : null,
        endTime: json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
      );

  Map<String, dynamic> toJson() => {
        'booked_by': bookedBy,
        'event_id': eventId,
        'range_id': rangeId,
        'status': status,
        'payment_status': paymentStatus,
        'booked_date': bookedDate?.toIso8601String().split('T')[0],
        'start_time': startTime != null ? _extractTimeOnly(startTime!) : null,
        'end_time': endTime != null ? _extractTimeOnly(endTime!) : null,
      };

    // Extract time-only string from DateTime for PostgreSQL time column
  String _extractTimeOnly(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:'
           '${dateTime.minute.toString().padLeft(2, '0')}:'
           '${dateTime.second.toString().padLeft(2, '0')}';
  }


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
      bookedDate: bookingDate ?? this.bookedDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
