import 'package:gun_range_app/core/constants/tables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteRepository {
  final SupabaseClient _client;

  FavoriteRepository(this._client);

  final String _tableName = Tables.favorites;

  Future<void> addFavorite(String userId, String rangeId) async {
    await _client.from(_tableName).insert({
      'user_id': userId,
      'range_id': rangeId,
    });
  }

  Future<void> removeFavorite(String userId, String rangeId) async {
    await _client
        .from(_tableName)
        .delete()
        .eq('user_id', userId)
        .eq('range_id', rangeId);
  }
}
