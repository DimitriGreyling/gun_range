import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/auth_vm.dart';
import '../viewmodels/range_vm.dart';
import '../viewmodels/event_vm.dart';
import '../viewmodels/booking_vm.dart';
import 'repository_providers.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthViewModel(authRepository);
});

final rangeViewModelProvider = StateNotifierProvider<RangeViewModel, RangeState>((ref) {
  final rangeRepository = ref.watch(rangeRepositoryProvider);
  return RangeViewModel(rangeRepository);
});

final eventViewModelProvider = StateNotifierProvider<EventViewModel, EventState>((ref) {
  final eventRepository = ref.watch(eventRepositoryProvider);
  return EventViewModel(eventRepository);
});

final bookingViewModelProvider = StateNotifierProvider<BookingViewModel, BookingState>((ref) {
  final bookingRepository = ref.watch(bookingRepositoryProvider);
  return BookingViewModel(bookingRepository);
});
