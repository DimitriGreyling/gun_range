import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/range_repository.dart';
import '../data/repositories/event_repository.dart';
import '../data/repositories/booking_repository.dart';
import '../data/repositories/auth_repository.dart';
import 'supabase_provider.dart';

final rangeRepositoryProvider = Provider<RangeRepository>((ref) {
  // final supabase = ref.watch(supabaseProvider);
  return RangeRepository();
});

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return EventRepository(supabase);
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return BookingRepository(supabase);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return AuthRepository(supabase);
});
