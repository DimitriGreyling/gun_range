import 'package:flutter/material.dart';

class BookingConfigs {
  String? id;
  String? resourceType;
  String? resourceId;
  int? slotDuration;
  TimeOfDay? openingTime;
  TimeOfDay? closingTime;
  int? bufferMinutes;
  int? maxBookings;
  bool? isActive;

  BookingConfigs({
    this.id,
    this.resourceType,
    this.resourceId,
    this.slotDuration,
    this.openingTime,
    this.closingTime,
    this.bufferMinutes,
    this.maxBookings,
    this.isActive,
  });

  factory BookingConfigs.fromJson(Map<String, dynamic> json) {
    return BookingConfigs(
      id: json['id'],
      resourceType: json['resource_type'],
      resourceId: json['resource_id'],
      slotDuration: json['slot_duration'],
      openingTime: _parseTimeOfDay(json['opening_time']),
      closingTime: _parseTimeOfDay(json['closing_time']),
      bufferMinutes: json['buffer_minutes'],
      maxBookings: json['max_bookings'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resource_type': resourceType,
      'resource_id': resourceId,
      'slot_duration': slotDuration,
      'opening_time': _formatTimeOfDay(openingTime),
      'closing_time': _formatTimeOfDay(closingTime),
      'buffer_minutes': bufferMinutes,
      'max_bookings': maxBookings,
      'is_active': isActive,
    };
  }

  static TimeOfDay? _parseTimeOfDay(String? time) {
    if (time == null) return null;
    final parts = time.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  static String? _formatTimeOfDay(TimeOfDay? time) {
    if (time == null) return null;
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}