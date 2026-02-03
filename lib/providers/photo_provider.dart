import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/repositories/photo_repository.dart';
import 'package:gun_range_app/providers/supabase_provider.dart';

final photoProvider = Provider<PhotoRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return PhotoRepository(supabase);
});