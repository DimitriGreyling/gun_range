import 'package:gun_range_app/core/constants/tables.dart';
import 'package:gun_range_app/data/models/booking_guest.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingGuestRepository {
  final SupabaseClient _client;

  BookingGuestRepository(this._client);

  final tableName = Tables.bookingGuests;

  Future<void> addGuestToBooking({
    required String bookingId,
    required BookingGuest guest,
  }) async {
    final response = await _client.from(tableName).insert({
      'booking_id': bookingId,
      'name': guest.name,
      'email': guest.email,
      'phone': guest.phone,
      'is_primary': guest.isPrimary,
    });

    if (response == null) {
      throw Exception('Failed to add guest to booking');
    }
  }

  Future<List<BookingGuest>> getGuestsForBooking(String bookingId) async {
    final response = await _client
        .from(tableName)
        .select()
        .eq('booking_id', bookingId) as List<dynamic>?;

    if (response == null) {
      throw Exception('Failed to fetch guests for booking');
    }

    return response
        .map((json) => BookingGuest.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
