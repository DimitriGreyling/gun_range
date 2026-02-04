import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/repositories/booking_guest_repository.dart';
import 'package:gun_range_app/providers/supabase_provider.dart';

final bookingGuestProvider = Provider<BookingGuestRepository>((ref) {
  final supabaseClient = ref.watch(supabaseProvider);
  return BookingGuestRepository(supabaseClient);
});