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
  final String? errorMessage;
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
      recipientNameController: recipientNameController ?? this.recipientNameController,
      recipientEmailController: recipientEmailController ?? this.recipientEmailController,
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

  // Initialize with range data
  Future<void> initialize(String? rangeId, Range? range) async {
    state = state.copyWith(
      rangeId: rangeId,
      range: range,
      bookingDetails: state.bookingDetails ?? Booking(), // Ensure bookingDetails is initialized
    );
    await _loadSavedPage();
    if (range == null && rangeId != null) {
      _loadRangeDetails(rangeId);
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

  // Set booking type (myself/someone else)
  void setBookingFor(String value) {
    state = state.copyWith(bookingFor: value);
  }

  // Set selected date
  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
    state.dateController.text = date.toLocal().toString().split(' ')[0];
  }

  // Add a new guest
  void addGuest() {
    final newGuest = BookingGuestData(
      nameController: TextEditingController(),
      emailController: TextEditingController(),
      phoneController: TextEditingController(),
    );
    
    final updatedGuests = [...state.guests, newGuest];
    state = state.copyWith(guests: updatedGuests);
  }

  // Remove a guest by index
  void removeGuest(int index) {
    if (index >= 0 && index < state.guests.length) {
      final guestToRemove = state.guests[index];
      guestToRemove.dispose(); // Dispose controllers
      
      final updatedGuests = [...state.guests];
      updatedGuests.removeAt(index);
      state = state.copyWith(guests: updatedGuests);
    }
  }

  // Clear all guests
  void clearAllGuests() {
    for (final guest in state.guests) {
      guest.dispose();
    }
    state = state.copyWith(guests: []);
  }

  // Navigate to page
  void setCurrentPage(int pageIndex) {
    state = state.copyWith(currentPageIndex: pageIndex);
    _saveCurrentPage(pageIndex);
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

  // Submit booking
  Future<void> submitBooking() async {
    if (!validateForm()) {
      state = state.copyWith(errorMessage: 'Please fill in all required fields');
      return;
    }

    if (state.selectedDate == null) {
      state = state.copyWith(errorMessage: 'Please select a booking date');
      return;
    }

    if (state.range == null) {
      state = state.copyWith(errorMessage: 'Range information not available');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final name = state.bookingFor == 'myself'
          ? _authUser.userMetadata != null ? _authUser.userMetadata!['full_name'] : _authUser.email ?? ''
          : state.recipientNameController.text;
      final email = state.bookingFor == 'myself'
          ? _authUser.email ?? ''
          : state.recipientEmailController.text;
      final phone = state.bookingFor == 'myself'
          ? _authUser.userMetadata != null ? _authUser.userMetadata!['phone'] : ''
          : state.phoneController.text;

      // Build BookingGuest list
      final List<BookingGuest> bookingGuests = [];

      // Add main booker or recipient
      bookingGuests.add(
        BookingGuest(
          name: name,
          email: email,
          phone: phone,
          isPrimary: true,
        ),
      );

      // Add additional guests
      for (final guest in state.guests) {
        if (guest.nameController.text.trim().isNotEmpty) {
          bookingGuests.add(
            BookingGuest(
              name: guest.nameController.text,
              email: guest.emailController.text,
              phone: guest.phoneController.text,
              isPrimary: false,
            ),
          );
        }
      }

      await makeBooking(
        range: state.range!,
        date: state.selectedDate!,
        bookingGuest: bookingGuests,
      );

      GlobalPopupService.showInfo(
        title: 'Booking Submitted',
        message:
            'Thank you, $name! Your booking for ${state.range?.name ?? ''} on ${state.selectedDate!.toLocal().toString().split(' ')[0]} has been submitted.',
      );

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to submit booking: $e',
      );
    }
  }

  // Original makeBooking method (updated)
  Future<void> makeBooking({
    required Range range,
    required DateTime date,
    List<BookingGuest>? bookingGuest,
  }) async {
    try {
      // Create a Booking object
      final booking = Booking(
        bookedBy: _authUser.id,
        rangeId: range.id!,
        status: 'pending',
        paymentStatus: 'unpaid',
      );

      // Call the repository to create the booking
      final bookingResponse = await _bookingRepository.createBooking(booking);

      if (bookingResponse.id == null) {
        throw Exception('Booking cannot be found or created');
      }

      // Update state with created booking
      state = state.copyWith(bookingDetails: bookingResponse);

      // Add guests to the booking
      if (bookingGuest != null && bookingGuest.isNotEmpty) {
        bookingGuest.removeWhere(
          (guest) => (guest.name == null || guest.name!.isEmpty) && 
                    (guest.email == null || guest.email!.isEmpty)
        );

        for (var guest in bookingGuest) {
          await _bookingGuestRepository.addGuestToBooking(
            bookingId: bookingResponse.id!,
            guest: guest,
          );
        }
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      ErrorsExceptionService.handleException(e);
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}