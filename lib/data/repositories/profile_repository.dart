import 'package:gun_range_app/core/constants/tables.dart';
import 'package:gun_range_app/data/models/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileRepository {
  Future<Profile> getMyProfile();
}

class SupabaseProfileRepository implements ProfileRepository {
  final SupabaseClient client;

  SupabaseProfileRepository(this.client);

  final String _tableName = Tables.profiles;

  @override
  Future<Profile> getMyProfile() async {
    final user = client.auth.currentUser;
    if (user == null) {
      throw Exception('Not authenticated');
    }

    final response = await client
        .from(_tableName)
        .select()
        .eq('id', user.id)
        .single();

    return Profile.fromJson(response);
  }
}
