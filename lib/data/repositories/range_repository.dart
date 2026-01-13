import '../models/range.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RangeRepository {
  final SupabaseClient supabase;
  RangeRepository(this.supabase);

  Future<List<Range>> getRanges() async {
    final response = await supabase.from('ranges').select().eq('is_active', true);
    return (response as List).map((e) => Range.fromJson(e)).toList();
  }
}
