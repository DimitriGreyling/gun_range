import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/repositories/favorite_repository.dart';
import 'package:gun_range_app/providers/supabase_provider.dart';

final favoriteProvider = Provider<FavoriteRepository>((ref) {
  final supabaseClient = ref.watch(supabaseProvider);
  return FavoriteRepository(supabaseClient);
});