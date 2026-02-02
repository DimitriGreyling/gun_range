import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/core/constants/tables.dart';
import 'package:gun_range_app/data/models/event.dart';

import '../models/range.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RangeRepository {
  final SupabaseClient _supabase;
  RangeRepository(SupabaseClient supabase) : _supabase = supabase;
  final tablename = Tables.ranges;

  Future<List<Range>> getRanges() async {
    final response =
        await _supabase.from(tablename).select().eq('is_active', true);
    return (response as List).map((e) => Range.fromJson(e)).toList();
  }
}
