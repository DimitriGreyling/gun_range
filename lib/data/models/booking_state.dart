
import 'package:flutter/material.dart';
import 'package:gun_range_app/data/models/booking.dart';
import 'package:gun_range_app/data/models/booking_guest_data.dart';
import 'package:gun_range_app/data/models/range.dart';

class MakeBookingState {
  final String? rangeId;
  final Range? range;
  final bool isLoading;
  final String bookingFor; // 'myself' or 'someone'
  final DateTime? selectedDate;
  final int currentPageIndex;
  final List<BookingGuestData> guests;
  String? errorMessage;
  Booking? bookingDetails;

  // Form controllers
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController notesController;
  final TextEditingController recipientNameController;
  final TextEditingController recipientEmailController;
  final TextEditingController dateController;

  MakeBookingState({
    this.rangeId,
    this.range,
    this.isLoading = false,
    this.bookingFor = 'myself',
    this.selectedDate,
    this.currentPageIndex = 0,
    this.guests = const [],
    this.bookingDetails,
    this.errorMessage,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.notesController,
    required this.recipientNameController,
    required this.recipientEmailController,
    required this.dateController,
  });

  MakeBookingState copyWith({
    String? rangeId,
    Range? range,
    bool? isLoading,
    String? bookingFor,
    DateTime? selectedDate,
    int? currentPageIndex,
    List<BookingGuestData>? guests,
    String? errorMessage,
    TextEditingController? nameController,
    TextEditingController? emailController,
    TextEditingController? phoneController,
    TextEditingController? notesController,
    TextEditingController? recipientNameController,
    TextEditingController? recipientEmailController,
    TextEditingController? dateController,
    Booking? bookingDetails,
  }) {
    return MakeBookingState(
      rangeId: rangeId ?? this.rangeId,
      range: range ?? this.range,
      isLoading: isLoading ?? this.isLoading,
      bookingFor: bookingFor ?? this.bookingFor,
      selectedDate: selectedDate ?? this.selectedDate,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      guests: guests ?? this.guests,
      errorMessage: errorMessage ?? this.errorMessage,
      nameController: nameController ?? this.nameController,
      emailController: emailController ?? this.emailController,
      phoneController: phoneController ?? this.phoneController,
      notesController: notesController ?? this.notesController,
      recipientNameController:
          recipientNameController ?? this.recipientNameController,
      recipientEmailController:
          recipientEmailController ?? this.recipientEmailController,
      dateController: dateController ?? this.dateController,
      bookingDetails: bookingDetails ?? this.bookingDetails,
    );
  }
}