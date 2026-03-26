import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/booking_configs.dart';
import 'package:gun_range_app/data/repositories/booking_config_repository.dart';
import 'package:gun_range_app/domain/services/errors_exception_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingConfigState {
  final bool isLoadingBookingConfigs;
  final List<BookingConfigs> bookingConfigs;

  BookingConfigState({
    this.isLoadingBookingConfigs = false,
    this.bookingConfigs = const [],
  });

  BookingConfigState copyWith({
    bool? isLoadingBookingConfigs,
    List<BookingConfigs>? bookingConfigs,
  }) {
    return BookingConfigState(
      isLoadingBookingConfigs:
          isLoadingBookingConfigs ?? this.isLoadingBookingConfigs,
      bookingConfigs: bookingConfigs ?? this.bookingConfigs,
    );
  }
}

class BookingConfigVm extends StateNotifier<BookingConfigState> {
  final BookingConfigRepository _bookingConfigRepository;

  BookingConfigVm(this._bookingConfigRepository) : super(BookingConfigState());

  Future<void> fetchBookingConfigs(String rangeId) async {
    state = state.copyWith(isLoadingBookingConfigs: true);
    try {
      final bookingConfigs =
          await _bookingConfigRepository.getBookingConfigsByRangeId(rangeId);
      _setBookingConfigsInPreference(configs: bookingConfigs);
      await buildTimeSlotsForBookingConfig(
        bookingConfigs: bookingConfigs,
      );
      state = state.copyWith(
          isLoadingBookingConfigs: false, bookingConfigs: bookingConfigs);
    } catch (e) {
      state = state.copyWith(isLoadingBookingConfigs: false);
      ErrorsExceptionService.handleException(e);
    }
  }

  Future<void> _setBookingConfigsInPreference({
    required List<BookingConfigs> configs,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList(
          'BOOKING_CONFIGS', configs.map((c) => c.toString()).toList());
    } catch (e) {
      ErrorsExceptionService.handleException(e);
    }
  }

  Future<List<BookingConfigs>> getBookingConfigsInPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configsString = prefs.getStringList('BOOKING_CONFIGS') as List?;

      if (configsString == null || configsString.isEmpty) {
        return [];
      }

      final mappedValues = configsString.map((val) {
        return BookingConfigs.fromJson(jsonDecode(val));
      });

      return mappedValues.toList();
    } catch (e) {
      ErrorsExceptionService.handleException(e);
      return [];
    }
  }

  TimeOfDay fromMinutes(int totalMinutes) {
    return TimeOfDay(
      hour: totalMinutes ~/ 60,
      minute: totalMinutes % 60,
    );
  }

  String formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  int toMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  Future<List<String>> buildSlots({
    required TimeOfDay openingTime,
    required TimeOfDay closingTime,
    required int slotMinutes,
  }) async {
    final start = toMinutes(openingTime);
    final end = toMinutes(closingTime);

    final slots = <String>[];

    for (int current = start;
        current + slotMinutes <= end;
        current += slotMinutes) {
      final slotStart = fromMinutes(current);
      final slotEnd = fromMinutes(current + slotMinutes);

      slots.add('${formatTime(slotStart)} - ${formatTime(slotEnd)}');
    }

    return slots;
  }

  Future<void> buildTimeSlotsForBookingConfig({
    required List<BookingConfigs> bookingConfigs,
  }) async {
    try {
      for (final config in bookingConfigs) {
        final openingTime = config.openingTime;
        final closingTime = config.closingTime;
        final slotMinutes = config.slotDuration;

        if (openingTime == null || closingTime == null || slotMinutes == null) {
          continue;
        }

        final slots = await buildSlots(
            openingTime: openingTime,
            closingTime: closingTime,
            slotMinutes: config.slotDuration ?? 60);

        config.timeSlots = slots;
      }
    } catch (error) {
      ErrorsExceptionService.handleException(error);
    }
  }
}
