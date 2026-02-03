import 'package:gun_range_app/core/constants/tables.dart';
import 'package:gun_range_app/data/models/paged_items.dart';
import 'package:gun_range_app/data/models/review.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewRepository {
  final SupabaseClient _client;
  ReviewRepository(this._client);

  final tableName = Tables.reviews;

  Future<PagedItems?> getReviewsByRangeId({
    required String rangeId,
    required int page,
    int pageSize = 10,
  }) async {
    final offset = (page - 1) * pageSize;
    final response = await _client
        .from(tableName)
        .select('*')
        .eq('range_id', rangeId)
        .order('created_at', ascending: false)
        .range(offset, offset + pageSize - 1)
        .count(CountOption.exact);

    final data = response.data as List? ?? [];
    final totalCount = response.count ?? 0;

    return PagedItems(
      items: data.map((e) => Review.fromMap(e)).toList(),
      hasMore: offset + pageSize < totalCount,
      totalCount: totalCount,
    );
  }

  Future<int> _getCountByRangeId(String rangeId) async {
    final response = await _client
        .from(tableName)
        .select('*')
        .eq('range_id', rangeId)
        .count(CountOption.exact);

    return response.count ?? 0;
  }
}
