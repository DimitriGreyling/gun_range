import 'package:gun_range_app/core/constants/tables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PhotoRepository {
  final SupabaseClient _client;

  PhotoRepository(this._client);

  final String _tableName = Tables.photos;

  Future<List<String>> getPhotoUrlsByRangeId(String rangeId) async {
    final response = await _client
        .from(_tableName)
        .select()
        .eq('range_id', rangeId) as List<dynamic>;

    return response.map((photoMap) => photoMap['url'] as String).toList();
  }
}
