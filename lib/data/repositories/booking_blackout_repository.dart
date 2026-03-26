import 'package:gun_range_app/core/constants/tables.dart';
import 'package:gun_range_app/data/models/booking_blackout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingBlackoutRepository {
  final SupabaseClient _client;

  BookingBlackoutRepository(this._client);

  final tableName = Tables.bookingBlackouts;

  Future<List<BookingBlackout>> getBookingBlackoutsByRangeId(String rangeId) async {
    final response = await _client.from(tableName).select().eq('range_id', rangeId);
    
    final data = response as List<dynamic>;
    return data.map((json) => BookingBlackout.fromJson(json)).toList();
  }
}