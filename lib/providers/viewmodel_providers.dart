import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/range.dart';
import 'package:gun_range_app/providers/favorite_provider.dart';
import 'package:gun_range_app/providers/photo_provider.dart';
import 'package:gun_range_app/providers/review_provider.dart';
import 'package:gun_range_app/providers/supabase_provider.dart';
import 'package:gun_range_app/viewmodels/booking_config_vm.dart';
import 'package:gun_range_app/viewmodels/lookup_vm.dart';
import 'package:gun_range_app/viewmodels/range_detail_vm.dart';
import 'package:gun_range_app/viewmodels/ranges_vm.dart';
import 'package:gun_range_app/viewmodels/top_bar_viewmodel.dart';
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

// final rangeViewModelProvider =
//     StateNotifierProvider<RangeViewModel, RangeState>((ref) {
//   final rangeRepository = ref.watch(rangeRepositoryProvider);
//   final favoriteRepository = ref.watch(favoriteProvider);
//   final photoRepository = ref.watch(photoProvider);

//   return RangeViewModel(rangeRepository, favoriteRepository, photoRepository);
// });

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

final rangeDetailViewModelProvider =
    StateNotifierProvider<RangeDetailVm, RangeDetailState>((ref) {
  final rangeRepository = ref.watch(rangeRepositoryProvider);
  final reviewRepository = ref.watch(reviewRepositoryProvider);

  return RangeDetailVm(rangeRepository, reviewRepository);
});

final bookingConfigViewModelProvider =
    StateNotifierProvider<BookingConfigVm, BookingConfigState>((ref) {
  final bookingConfigRepository = ref.watch(bookingConfigRepositoryProvider);
  return BookingConfigVm(bookingConfigRepository);
});

final topBarViewModelProvider =
    StateNotifierProvider<TopBarViewModel, TopBarState>((ref) {
  return TopBarViewModel();
});

final lookupViewModelProvider =
    StateNotifierProvider<LookupVm, LookupState>((ref) {
  final lookupRepository = ref.watch(lookupProvider);
  return LookupVm(lookupRepository);
});

final rangeViewModelProvider =
    StateNotifierProvider<RangesVm, RangesState>((ref) {
  final rangeRepository = ref.watch(rangeRepositoryProvider);

  return RangesVm(rangeRepository: rangeRepository);
});

// Provider for cached distance calculations
final distanceProvider =
    FutureProvider.family<String, Range>((ref, range) async {
  final notifier = ref.read(rangeViewModelProvider.notifier);
  await notifier.getDistanceBetweenLocations(range);
  return range.nspDistanceInKilometers != null
      ? 'DIST: ${range.nspDistanceInKilometers} KM'
      : 'DIST: N/A';
});

// Provider for range detail with proper caching
final rangeDetailProvider =
    FutureProvider.family<Range?, String>((ref, rangeId) async {
  final notifier = ref.read(rangeDetailViewModelProvider.notifier);
  await notifier.fetchRangeDetail(rangeId);
  return ref.read(rangeDetailViewModelProvider).range;
});

// Provider for cached lookup values
final lookupValueProvider =
    FutureProvider.family<String, String>((ref, id) async {
  final notifier = ref.read(lookupViewModelProvider.notifier);
  return await notifier.loadLookupValueById(id: id) ?? '';
});
