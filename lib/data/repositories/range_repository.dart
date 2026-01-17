import 'package:gun_range_app/core/constants/tables.dart';

import '../models/range.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RangeRepository {
  // final SupabaseClient supabase;
  RangeRepository();

  final _client = Supabase.instance.client;
  final tablename = Tables.ranges;

  Future<List<Range>> getRanges() async {
    final response =
        await _client.from(tablename).select().eq('is_active', true);
    return (response as List).map((e) => Range.fromJson(e)).toList();
  }
}
