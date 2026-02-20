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
        bookedDate: json['booked_date'] != null
            ? _parseDateTime(['booked_date'])
            : null,
        startTime: json['start_time'] != null
            ?_parseDateTime(['start_time'])
            : null,
        endTime:
            json['end_time'] != null ? _parseDateTime(['end_time']) : null,
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

  // Safe date parsing with error handling
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;

    try {
      final stringValue = value.toString();
      print('Parsing datetime: "$stringValue"'); // Debug log

      // Handle empty strings
      if (stringValue.isEmpty || stringValue == 'null') {
        return null;
      }

      // Handle different date/time formats
      if (stringValue.contains('T')) {
        // ISO format: "2026-02-20T18:00:00.000Z" or "2026-02-20T18:00:00"
        return DateTime.parse(stringValue);
      } else if (stringValue.contains('-') &&
          stringValue.split('-').length == 3) {
        // Date only format: "2026-02-20"
        return DateTime.parse(stringValue);
      } else if (stringValue.contains(':') && !stringValue.contains('-')) {
        // Time only format: "18:00:00" - can't parse without date context
        print(
            'Warning: Time-only format detected, cannot parse without date: $stringValue');
        return null;
      } else {
        print('Unknown date format: $stringValue');
        return null;
      }
    } catch (e) {
      print('Error parsing datetime "$value": $e');
      return null;
    }
  }

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
