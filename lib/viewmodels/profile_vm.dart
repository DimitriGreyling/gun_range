import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/profile.dart';
import 'package:gun_range_app/providers/auth_state_provider.dart';
import 'package:gun_range_app/providers/repository_providers.dart';

final profileViewModelProvider =
    AsyncNotifierProvider<ProfileViewModel, Profile?>(
  ProfileViewModel.new,
);

class ProfileViewModel extends AsyncNotifier<Profile?> {
  @override
  Future<Profile?> build() async {
    final user = ref.watch(authUserProvider).valueOrNull;
    if (user == null) return null;

    final repo = ref.read(profileRepositoryProvider);
    return repo.getMyProfile();
  }
}
