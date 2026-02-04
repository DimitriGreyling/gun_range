import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/range.dart';
import 'package:gun_range_app/data/repositories/booking_repository.dart';
import 'package:gun_range_app/domain/services/errors_exception_service.dart';

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
  
  MakeBookingVm(this._bookingRepository) : super(MakeBookingState());

  Future<void> makeBooking(Range range, DateTime date, String name,
      String email, String phone, String notes) async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      ErrorsExceptionService.handleException(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
