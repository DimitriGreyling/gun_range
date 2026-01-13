import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/booking_repository.dart';
import '../data/models/booking.dart';

class BookingState {
  final List<Booking> bookings;
  final bool isLoading;
  final String? error;
  const BookingState({this.bookings = const [], this.isLoading = false, this.error});

  BookingState copyWith({List<Booking>? bookings, bool? isLoading, String? error}) => BookingState(
        bookings: bookings ?? this.bookings,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class BookingViewModel extends StateNotifier<BookingState> {
  final BookingRepository _bookingRepository;
  BookingViewModel(this._bookingRepository) : super(const BookingState());

  Future<void> fetchBookings() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final bookings = await _bookingRepository.getBookings();
      state = state.copyWith(isLoading: false, bookings: bookings);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
