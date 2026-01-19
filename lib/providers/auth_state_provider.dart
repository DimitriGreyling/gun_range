import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/providers/supabase_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authUserProvider = StreamProvider<User?>((ref) {
  final supabase = ref.read(supabaseProvider);
  return supabase.auth.onAuthStateChange
      .map((event) => event.session?.user);
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final auth = ref.watch(authUserProvider);
  return auth.valueOrNull != null;
});