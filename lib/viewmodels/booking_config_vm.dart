import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/booking_configs.dart';
import 'package:gun_range_app/data/repositories/booking_config_repository.dart';
import 'package:gun_range_app/domain/services/errors_exception_service.dart';

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
      state = state.copyWith(
          isLoadingBookingConfigs: false, bookingConfigs: bookingConfigs);
    } catch (e) {
      state = state.copyWith(isLoadingBookingConfigs: false);
      ErrorsExceptionService.handleException(e);
    }
  }
}
