import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/providers/repository_providers.dart';
import 'package:gun_range_app/providers/supabase_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authUserProvider = StreamProvider<User?>((ref) async* {
  final supabase = ref.read(supabaseProvider);
  final profile = await ref.read(profileRepositoryProvider).getMyProfile();
  yield* supabase.auth.onAuthStateChange.map((event) {
    final user = event.session?.user;
    if (user != null) {
      user.appMetadata['theme_mode'] = profile.themeMode;

      return user;
    }
    return null;
  });
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final auth = ref.watch(authUserProvider);
  return auth.valueOrNull != null;
});
