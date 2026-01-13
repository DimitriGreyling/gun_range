import '../models/event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventRepository {
  final SupabaseClient supabase;
  EventRepository(this.supabase);

  Future<List<Event>> getEvents() async {
    final response = await supabase.from('events').select();
    return (response as List).map((e) => Event.fromJson(e)).toList();
  }
}
