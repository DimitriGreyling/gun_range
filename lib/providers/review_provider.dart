import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/repositories/review_repository.dart';
import 'package:gun_range_app/providers/supabase_provider.dart';

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return ReviewRepository(supabase);
});