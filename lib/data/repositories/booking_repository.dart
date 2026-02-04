import 'package:gun_range_app/core/constants/tables.dart';

import '../models/booking.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingRepository {
  final SupabaseClient supabase;
  BookingRepository(this.supabase);

  final tableName = Tables.bookings;

  Future<List<Booking>> getBookings() async {
    final response = await supabase.from(tableName).select();
    return (response as List).map((e) => Booking.fromJson(e)).toList();
  }

  Future<void> createBooking(Booking booking) async {
    await supabase.from(tableName).insert(booking.toJson());
  }
}
