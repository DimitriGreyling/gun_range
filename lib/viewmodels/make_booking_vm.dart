import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/booking.dart';
import 'package:gun_range_app/data/models/booking_guest.dart';
import 'package:gun_range_app/data/models/range.dart';
import 'package:gun_range_app/data/repositories/booking_repository.dart';
import 'package:gun_range_app/data/repositories/booking_guest_repository.dart';
import 'package:gun_range_app/data/repositories/range_repository.dart';
import 'package:gun_range_app/domain/services/errors_exception_service.dart';
import 'package:gun_range_app/domain/services/global_popup_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingGuestData {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  BookingGuestData({
    required this.nameController,
    required this.emailController,
    required this.phoneController,
  });

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }

  BookingGuestData copyWith({
    TextEditingController? nameController,
    TextEditingController? emailController,
    TextEditingController? phoneController,
  }) {
    return BookingGuestData(
      nameController: nameController ?? this.nameController,
      emailController: emailController ?? this.emailController,
      phoneController: phoneController ?? this.phoneController,
    );
  }
}

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

class MakeBookingVm extends StateNotifier<MakeBookingState> {
  final BookingRepository _bookingRepository;
  final BookingGuestRepository _bookingGuestRepository;
  final RangeRepository _rangeRepository;
  final User _authUser;

  MakeBookingVm(
    this._bookingRepository,
    this._bookingGuestRepository,
    this._rangeRepository,
    this._authUser,
  ) : super(MakeBookingState(
          nameController: TextEditingController(),
          emailController: TextEditingController(),
          phoneController: TextEditingController(),
          notesController: TextEditingController(),
          recipientNameController: TextEditingController(),
          recipientEmailController: TextEditingController(),
          dateController: TextEditingController(),
        )) {
    _loadSavedPage();
  }

  @override
  void dispose() {
    // Dispose all controllers
    state.nameController.dispose();
    state.emailController.dispose();
    state.phoneController.dispose();
    state.notesController.dispose();
    state.recipientNameController.dispose();
    state.recipientEmailController.dispose();
    state.dateController.dispose();

    // Dispose guest controllers
    for (final guest in state.guests) {
      guest.dispose();
    }

    super.dispose();
  }

  // Save all form state to SharedPreferences
  Future<void> _saveAllFormState() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save basic booking details
      await prefs.setString('booking_for', state.bookingFor);
      await prefs.setInt('current_page_index', state.currentPageIndex);

      // Save booking details
      final bookingDetails = state.bookingDetails;
      if (bookingDetails != null) {
        await prefs.setString('booking_event_id', bookingDetails.eventId ?? '');
        if (bookingDetails.bookedDate != null) {
          await prefs.setString(
              'booking_date', bookingDetails.bookedDate!.toIso8601String());
        }
        if (bookingDetails.startTime != null) {
          await prefs.setString('booking_start_time',
              bookingDetails.startTime!.toIso8601String());
        }
        if (bookingDetails.endTime != null) {
          await prefs.setString(
              'booking_end_time', bookingDetails.endTime!.toIso8601String());
        }
      }

      // Save form controllers text
      await prefs.setString('name_controller', state.nameController.text);
      await prefs.setString('email_controller', state.emailController.text);
      await prefs.setString('phone_controller', state.phoneController.text);
      await prefs.setString('notes_controller', state.notesController.text);
      await prefs.setString(
          'recipient_name_controller', state.recipientNameController.text);
      await prefs.setString(
          'recipient_email_controller', state.recipientEmailController.text);
      await prefs.setString('date_controller', state.dateController.text);

      // Save guests data
      await prefs.setInt('guests_count', state.guests.length);
      for (int i = 0; i < state.guests.length; i++) {
        final guest = state.guests[i];
        await prefs.setString('guest_${i}_name', guest.nameController.text);
        await prefs.setString('guest_${i}_email', guest.emailController.text);
        await prefs.setString('guest_${i}_phone', guest.phoneController.text);
      }

      // Save range info
      if (state.rangeId != null) {
        await prefs.setString('range_id', state.rangeId!);
      }
      if (state.range != null) {
        await prefs.setString('range_name', state.range?.name ?? '');
        // Add other range fields as needed
      }

      log('All form state saved successfully');
    } catch (e) {
      log('Error saving form state: $e');
    }
  }

  // Load all form state from SharedPreferences
  Future<void> _loadAllFormState() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load basic settings
      final savedBookingFor = prefs.getString('booking_for') ?? 'myself';
      final savedPageIndex = prefs.getInt('current_page_index') ?? 0;
      final savedRangeId = prefs.getString('range_id');

      // Load booking details
      final eventId = prefs.getString('booking_event_id');
      final bookingDateStr = prefs.getString('booking_date');
      final startTimeStr = prefs.getString('booking_start_time');
      final endTimeStr = prefs.getString('booking_end_time');

      Booking? booking;
      if (eventId != null || bookingDateStr != null || startTimeStr != null) {
        booking = Booking();

        if (eventId != null && eventId.isNotEmpty) {
          booking.eventId = eventId;
        }

        if (bookingDateStr != null) {
          booking.bookedDate = DateTime.parse(bookingDateStr);
        }

        if (startTimeStr != null) {
          booking.startTime = DateTime.parse(startTimeStr);
        }

        if (endTimeStr != null) {
          booking.endTime = DateTime.parse(endTimeStr);
        }
      }

      // Load form controller texts
      final nameText = prefs.getString('name_controller') ?? '';
      final emailText = prefs.getString('email_controller') ?? '';
      final phoneText = prefs.getString('phone_controller') ?? '';
      final notesText = prefs.getString('notes_controller') ?? '';
      final recipientNameText =
          prefs.getString('recipient_name_controller') ?? '';
      final recipientEmailText =
          prefs.getString('recipient_email_controller') ?? '';
      final dateText = prefs.getString('date_controller') ?? '';

      // Set controller texts
      state.nameController.text = nameText;
      state.emailController.text = emailText;
      state.phoneController.text = phoneText;
      state.notesController.text = notesText;
      state.recipientNameController.text = recipientNameText;
      state.recipientEmailController.text = recipientEmailText;
      state.dateController.text = dateText;

      // Load guests
      final guestsCount = prefs.getInt('guests_count') ?? 0;
      final List<BookingGuestData> restoredGuests = [];

      for (int i = 0; i < guestsCount; i++) {
        final guestName = prefs.getString('guest_${i}_name') ?? '';
        final guestEmail = prefs.getString('guest_${i}_email') ?? '';
        final guestPhone = prefs.getString('guest_${i}_phone') ?? '';

        final guestData = BookingGuestData(
          nameController: TextEditingController(text: guestName),
          emailController: TextEditingController(text: guestEmail),
          phoneController: TextEditingController(text: guestPhone),
        );

        restoredGuests.add(guestData);
      }

      // Update state with restored data
      state = state.copyWith(
        bookingFor: savedBookingFor,
        currentPageIndex: savedPageIndex,
        bookingDetails: booking ?? state.bookingDetails,
        guests: restoredGuests,
        rangeId: savedRangeId ?? state.rangeId,
      );

      log('All form state loaded successfully');
      log('Restored booking for: $savedBookingFor');
      log('Restored page index: $savedPageIndex');
      log('Restored guests count: $guestsCount');
    } catch (e) {
      log('Error loading form state: $e');
    }
  }

  // Clear all saved form state
  Future<void> _clearAllSavedFormState() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Remove all booking-related keys
      final keys = prefs.getKeys();
      final bookingKeys = keys
          .where((key) =>
              key.startsWith('booking_') ||
              key.startsWith('guest_') ||
              key.contains('controller') ||
              key == 'current_page_index' ||
              key == 'range_id' ||
              key == 'range_name' ||
              key == 'guests_count')
          .toList();

      for (String key in bookingKeys) {
        await prefs.remove(key);
      }

      log('All saved form state cleared');
    } catch (e) {
      log('Error clearing form state: $e');
    }
  }

  // Initialize with range data
  Future<void> initialize(String? rangeId, Range? range) async {
    state = state.copyWith(
      rangeId: rangeId,
      range: range,
    );

    // Load all saved state first
    await _loadAllFormState();

    // Initialize booking details if still null
    if (state.bookingDetails == null) {
      state = state.copyWith(bookingDetails: Booking());
    }

    // Add listeners to form controllers for auto-save
    _addFormControllerListeners();

    // Load range details if needed
    if (range == null && (rangeId != null || state.rangeId != null)) {
      _loadRangeDetails(rangeId ?? state.rangeId!);
    }
  }

  // Add form controller listeners for auto-save
  void _addFormControllerListeners() {
    state.nameController.addListener(_saveAllFormState);
    state.emailController.addListener(_saveAllFormState);
    state.phoneController.addListener(_saveAllFormState);
    state.notesController.addListener(_saveAllFormState);
    state.recipientNameController.addListener(_saveAllFormState);
    state.recipientEmailController.addListener(_saveAllFormState);
    state.dateController.addListener(_saveAllFormState);

    // Add listeners to existing guests
    for (final guest in state.guests) {
      guest.nameController.addListener(_saveAllFormState);
      guest.emailController.addListener(_saveAllFormState);
      guest.phoneController.addListener(_saveAllFormState);
    }
  }

  // Load range details if not provided
  Future<void> _loadRangeDetails(String rangeId) async {
    try {
      state = state.copyWith(isLoading: true);
      final range = await _rangeRepository.getRangeById(rangeId);
      state = state.copyWith(
        range: range,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load range details: $e',
      );
    }
  }

  // Initialize booking details if null
  void initializeBookingDetails() {
    if (state.bookingDetails == null) {
      state = state.copyWith(bookingDetails: Booking());
    }
  }

  // Update booking date
  void updateBookingDate(DateTime date) {
    final updatedBooking = state.bookingDetails?.copyWith(bookingDate: date) ??
        Booking(bookedDate: date);
    state = state.copyWith(
      selectedDate: date,
      bookingDetails: updatedBooking,
      errorMessage: null,
    );
    _saveAllFormState();
  }

  // Update booking event ID
  void updateBookingEventId(String? eventId) {
    final updatedBooking = state.bookingDetails?.copyWith(eventId: eventId) ??
        Booking(eventId: eventId);
    state = state.copyWith(
      bookingDetails: updatedBooking,
      errorMessage: null,
    );
    _saveAllFormState();
  }

  // Update booking time
  void updateBookingTime(String timeSlot) {
    final selectedDate = state.bookingDetails?.bookedDate ?? DateTime.now();
    final slotHour = int.parse(timeSlot.split(':')[0]) +
        (timeSlot.contains('PM') && !timeSlot.startsWith('12') ? 12 : 0);

    final startTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      slotHour,
      0,
    );
    final endTime = startTime.add(const Duration(hours: 1));

    final updatedBooking = state.bookingDetails?.copyWith(
          startTime: startTime,
          endTime: endTime,
        ) ??
        Booking(
          startTime: startTime,
          endTime: endTime,
          bookedDate: selectedDate,
        );

    state = state.copyWith(
      bookingDetails: updatedBooking,
      errorMessage: null,
    );
    _saveAllFormState();
  }

  // Set booking type (myself/someone else)
  void setBookingFor(String value) {
    state = state.copyWith(bookingFor: value, errorMessage: null,);
    _saveAllFormState();
  }

  // Set selected date
  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date, errorMessage: null,);
    _saveAllFormState();
  }

  // Add a new guest
  void addGuest() {
    final newGuest = BookingGuestData(
      nameController: TextEditingController(),
      emailController: TextEditingController(),
      phoneController: TextEditingController(),
    );

    // Add listeners to guest controllers for auto-save
    newGuest.nameController.addListener(_saveAllFormState);
    newGuest.emailController.addListener(_saveAllFormState);
    newGuest.phoneController.addListener(_saveAllFormState);

    state = state.copyWith(guests: [...state.guests, newGuest], errorMessage: null,);
    _saveAllFormState();
  }

  // Remove a guest by index
  void removeGuest(int index) {
    if (index >= 0 && index < state.guests.length) {
      final guestToRemove = state.guests[index];
      guestToRemove.dispose(); // Dispose controllers

      final updatedGuests = [...state.guests];
      updatedGuests.removeAt(index);
      state = state.copyWith(guests: updatedGuests, errorMessage: null,);
      _saveAllFormState();
    }
  }

  // Clear all guests
  void clearAllGuests() {
    for (final guest in state.guests) {
      guest.dispose();
    }
    state = state.copyWith(guests: [], errorMessage: null,);
    _saveAllFormState();
  }

  // Navigate to page
  void setCurrentPage(int pageIndex) {
    state = state.copyWith(currentPageIndex: pageIndex, errorMessage: null);
    _saveCurrentPage(pageIndex);
    _saveAllFormState();
  }

  // Save current page to SharedPreferences
  Future<void> _saveCurrentPage(int pageIndex) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('booking_current_page', pageIndex);
    } catch (e) {
      // Handle error silently for now
    }
  }

  // Load saved page from SharedPreferences
  Future<void> _loadSavedPage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPage = prefs.getInt('booking_current_page') ?? 0;
      state = state.copyWith(currentPageIndex: savedPage);
    } catch (e) {
      // Handle error silently for now
    }
  }

  // Validate form data
  bool validateForm() {
    if (state.bookingFor == 'myself') {
      // For myself booking, we use current user data, just validate guests if any
      for (final guest in state.guests) {
        if (guest.nameController.text.trim().isEmpty) {
          return false;
        }
      }
      return true;
    } else {
      // For someone else booking, validate recipient data
      return state.recipientNameController.text.trim().isNotEmpty &&
          state.recipientEmailController.text.trim().isNotEmpty;
    }
  }

  // Call this when booking is completed or user wants to start fresh
  void clearBookingSession() {
    _clearAllSavedFormState();

    // Reset all controllers
    state.nameController.clear();
    state.emailController.clear();
    state.phoneController.clear();
    state.notesController.clear();
    state.recipientNameController.clear();
    state.recipientEmailController.clear();
    state.dateController.clear();

    // Clear guests
    for (final guest in state.guests) {
      guest.dispose();
    }

    // Reset state
    state = state.copyWith(
      bookingFor: 'myself',
      currentPageIndex: 0,
      guests: [],
      bookingDetails: Booking(),
      selectedDate: null,
    );
  }

  // Original makeBooking method (updated)
  Future<void> _makeBooking({
    required String rangeId,
    required DateTime bookingDate,
    required DateTime startTime,
    required DateTime endTime,
    String? notes,
    String? eventId,
    List<BookingGuest> guests = const [],
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      // Prepare booking data
      final booking = Booking(
        rangeId: rangeId,
        bookedBy: _authUser.id,
        paymentStatus: 'PENDING',
        // userId: _authUser.id,
        bookedDate: bookingDate,
        startTime: startTime,
        endTime: endTime,
        status: 'pending',
        // notes: notes,
        eventId: eventId,
      );

      // Create booking
      final createdBooking = await _bookingRepository.createBooking(booking);

      // if (createdBooking != null && guests.isNotEmpty) {
      //   // Add guests if any
      //   await _bookingGuestRepository.addGuestsToBooking(
      //     createdBooking.id!,
      //     guests,
      //   );
      // }

      state = state.copyWith(
        isLoading: false,
        bookingDetails: createdBooking,
      );

      // Clear session after successful booking
      clearBookingSession();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create booking: ${e.toString()}',
      );

      ErrorsExceptionService.handleException(
        e.toString(),
        // location: 'MakeBookingVm.makeBooking',
      );
    }
  }

  // Create booking with current state
  Future<void> createBookingFromCurrentState() async {
    try {
      if (state.bookingDetails == null ||
          state.bookingDetails!.startTime == null ||
          state.bookingDetails!.endTime == null ||
          state.bookingDetails!.bookedDate == null) {
        state = state.copyWith(
          errorMessage: 'Please complete all required booking details',
        );
        return;
      }

      state = state.copyWith(isLoading: true, errorMessage: null);

      // Convert guest data to BookingGuest objects
      final List<BookingGuest> bookingGuests = state.guests
          .where((guest) => guest.nameController.text.trim().isNotEmpty)
          .map((guest) => BookingGuest(
                name: guest.nameController.text.trim(),
                email: guest.emailController.text.trim().isNotEmpty
                    ? guest.emailController.text.trim()
                    : null,
                phone: guest.phoneController.text.trim().isNotEmpty
                    ? guest.phoneController.text.trim()
                    : null,
              ))
          .toList();

      await _makeBooking(
        rangeId: state.rangeId ?? state.range?.id ?? '',
        bookingDate: state.bookingDetails!.bookedDate!,
        startTime: state.bookingDetails!.startTime!,
        endTime: state.bookingDetails!.endTime!,
        notes: state.notesController.text.trim().isNotEmpty
            ? state.notesController.text.trim()
            : null,
        eventId: state.bookingDetails!.eventId,
        guests: bookingGuests,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to create booking: ${e.toString()}',
      );
    }
  }
}
