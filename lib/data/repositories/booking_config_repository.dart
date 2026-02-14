import 'package:gun_range_app/core/constants/tables.dart';
import 'package:gun_range_app/data/models/booking_configs.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingConfigRepository {
  final SupabaseClient _client;

  BookingConfigRepository(this._client);

  final tableName = Tables.bookingConfigs;

  Future<List<BookingConfigs>> getBookingConfigsByRangeId(String rangeId) async {
    final response = await _client.from(tableName).select().eq('range_id', rangeId);

    final data = response as List<dynamic>;
    return data.map((json) => BookingConfigs.fromJson(json)).toList();
  }

}