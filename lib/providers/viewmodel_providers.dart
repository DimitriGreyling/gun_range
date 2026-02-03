import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/providers/favorite_provider.dart';
import 'package:gun_range_app/providers/photo_provider.dart';
import '../viewmodels/auth_vm.dart';
import '../viewmodels/range_vm.dart';
import '../viewmodels/event_vm.dart';
import '../viewmodels/booking_vm.dart';
import 'repository_providers.dart';

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final profileRepository = ref.watch(profileRepositoryProvider);

  return AuthViewModel(authRepository, profileRepository, ref);
});

final rangeViewModelProvider =
    StateNotifierProvider<RangeViewModel, RangeState>((ref) {
  final rangeRepository = ref.watch(rangeRepositoryProvider);
  final favoriteRepository = ref.watch(favoriteProvider);
  final photoRepository = ref.watch(photoProvider);

  return RangeViewModel(rangeRepository, favoriteRepository, photoRepository);
});

final eventViewModelProvider =
    StateNotifierProvider<EventViewModel, EventState>((ref) {
  final eventRepository = ref.watch(eventRepositoryProvider);
  final favoriteRepository = ref.watch(favoriteProvider);

  return EventViewModel(eventRepository, favoriteRepository);
});

final bookingViewModelProvider =
    StateNotifierProvider<BookingViewModel, BookingState>((ref) {
  final bookingRepository = ref.watch(bookingRepositoryProvider);
  return BookingViewModel(bookingRepository);
});
