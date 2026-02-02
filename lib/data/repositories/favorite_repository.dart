import 'package:gun_range_app/core/constants/tables.dart';
import 'package:gun_range_app/data/models/favorite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteRepository {
  final SupabaseClient _client;

  FavoriteRepository(this._client);

  final String _tableName = Tables.favorites;

  Future<void> addRangeFavorite(String userId, String rangeId) async {
    await _client.from(_tableName).insert({
      'user_id': userId,
      'range_id': rangeId,
    });
  }

  Future<void> addEventFavorite(String userId, String eventId) async {
    await _client.from(_tableName).insert({
      'user_id': userId,
      'event_id': eventId,
    });
  }

  Future<void> removeEventFavorite(String userId, String eventId) async {
    await _client
        .from(_tableName)
        .delete()
        .eq('user_id', userId)
        .eq('event_id', eventId);
  }

  Future<void> removeRangeFavorite(String userId, String rangeId) async {
    await _client
        .from(_tableName)
        .delete()
        .eq('user_id', userId)
        .eq('range_id', rangeId);
  }

  Future<List<Favorite>> getFavoritesByUserId(String userId) async {
    if(userId.isEmpty || userId == '') return [];

    final response = await _client
        .from(_tableName)
        .select()
        .eq('user_id', userId) as List<dynamic>;

    return response
        .map((favoriteMap) => Favorite.fromMap(favoriteMap))
        .toList();
  }
}
