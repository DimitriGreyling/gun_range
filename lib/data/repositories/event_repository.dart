import 'package:gun_range_app/core/constants/tables.dart';

import '../models/event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventRepository {
  final SupabaseClient _supabaseClient;
  EventRepository(SupabaseClient supabaseClient)
      : _supabaseClient = supabaseClient;

  final tableName = Tables.events;

  Future<List<Event>> getEvents() async {
    final response =
        await _supabaseClient.from(tableName).select().eq('is_active', true);
    return (response as List).map((e) => Event.fromJson(e)).toList();
  }
}
