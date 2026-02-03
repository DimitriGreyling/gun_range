import 'package:gun_range_app/core/constants/tables.dart';
import 'package:gun_range_app/data/models/review.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewRepository {
  final SupabaseClient _client;
  ReviewRepository(this._client);

  final tableName = Tables.reviews;

  Future<List<Review?>?> getReviewsByRangeId(String rangeId) async {
    final response = await _client
        .from(tableName)
        .select()
        .eq('range_id', rangeId)
        .order('created_at', ascending: false);

    if (response.isEmpty) {
      return [];
    }

    return response.map((e) => Review.fromMap(e)).toList();

    // return (response as List).map((e) => e['review_text'] as String).toList();
  }
}
