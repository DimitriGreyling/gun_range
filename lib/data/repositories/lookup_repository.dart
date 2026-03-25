import 'package:gun_range_app/core/constants/tables.dart';
import 'package:gun_range_app/data/models/v2/lookup_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LookupRepository {
  final SupabaseClient client;

  LookupRepository({
    required this.client,
  });

  final tableName = Tables.lookupTableName;

  Future<List<LookupModel>> getLookupsByListValue(
      {required String listvalue}) async {
    final response =
        await client.from(tableName).select().eq('list_value', listvalue);

    final data = response as List<dynamic>;
    return data.map((json) => LookupModel.fromJson(json)).toList();
  }
}
