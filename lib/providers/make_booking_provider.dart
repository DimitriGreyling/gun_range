import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/providers/repository_providers.dart';
import 'package:gun_range_app/viewmodels/make_booking_vm.dart';

final makeBookingProvider =
    StateNotifierProvider<MakeBookingVm, MakeBookingState>((ref) {
  final bookingRepository = ref.watch(bookingRepositoryProvider);
  return MakeBookingVm(bookingRepository);
});
