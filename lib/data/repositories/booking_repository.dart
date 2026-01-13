import '../models/booking.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingRepository {
  final SupabaseClient supabase;
  BookingRepository(this.supabase);

  Future<List<Booking>> getBookings() async {
    final response = await supabase.from('bookings').select();
    return (response as List).map((e) => Booking.fromJson(e)).toList();
  }
}
