import 'package:gun_range_app/core/constants/tables.dart';
import 'package:gun_range_app/data/models/review.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewRepository {
  final SupabaseClient _client;
  ReviewRepository(this._client);

  final tableName = Tables.reviews;

  Future<List<Review?>?> getReviewsByRangeId({
    required String rangeId,
    required int page,
    int pageSize = 10,
  }) async {
    final offset = (page - 1) * pageSize;
    final response = await _client
        .from('reviews')
        .select()
        .eq('range_id', rangeId)
        .order('created_at', ascending: false)
        .range(offset, offset + pageSize - 1);

    if (response.isEmpty) {
      return [];
    }
    return (response as List).map((json) => Review.fromMap(json)).toList();
  }
}
