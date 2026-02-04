import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/booking.dart';
import 'package:gun_range_app/data/models/booking_guest.dart';
import 'package:gun_range_app/data/models/range.dart';
import 'package:gun_range_app/data/repositories/booking_guest_repository.dart';
import 'package:gun_range_app/data/repositories/booking_repository.dart';
import 'package:gun_range_app/domain/services/errors_exception_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MakeBookingState {
  final String? rangeId;
  final bool isLoading;

  MakeBookingState({this.rangeId, this.isLoading = false});

  MakeBookingState copyWith({String? rangeId, bool? isLoading}) {
    return MakeBookingState(
      rangeId: rangeId ?? this.rangeId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MakeBookingVm extends StateNotifier<MakeBookingState> {
  final BookingRepository _bookingRepository;
  final User _authUserProvider;
  final BookingGuestRepository _bookingGuestRepository;
  
  MakeBookingVm(this._bookingRepository, this._authUserProvider, this._bookingGuestRepository)
      : super(MakeBookingState());

  Future<void> makeBooking({
    required Range range,
    required DateTime date,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      // Create a Booking object
      final booking = Booking(
        bookedBy: _authUserProvider.id,
        rangeId: range.id!,
        status: 'pending',
        paymentStatus: 'unpaid',
      );

      // Call the repository to create the booking
      await _bookingRepository.createBooking(booking);
    } catch (e) {
      ErrorsExceptionService.handleException(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
