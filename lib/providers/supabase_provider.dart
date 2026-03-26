import 'package:gun_range_app/data/repositories/lookup_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final lookupProvider = Provider<LookupRepository>((ref) {
  final supabaseClient = ref.watch(supabaseProvider);
  return LookupRepository(client: supabaseClient);
});
