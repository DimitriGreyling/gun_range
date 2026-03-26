import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final SupabaseClient supabase;
  AuthRepository(this.supabase);

  Future<String> signIn(String email, String password) async {
    final response = await supabase.auth
        .signInWithPassword(email: email, password: password);
    if (response.user == null) throw Exception('Sign in failed');
    return response.user!.id;
  }

  Future<String> register(
      String email, String password, Map<String, dynamic> data) async {
    final response = await supabase.auth
        .signUp(email: email, password: password, data: data);
    if (response.user == null) throw Exception('Registration failed');
    return response.user!.id;
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<void> signInWithGoogle() async {
    await Supabase.instance.client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'my.scheme://login-callback',
    );
  }

  Future<void> callUserCreationEdgeFunction() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final response = await supabase.rpc('handle_new_user', params: {
      'user_id': user.id,
      'email': user.email,
    });

    if (response.error != null) {
      throw Exception('Edge function call failed: ${response.error!.message}');
    }
  }

  Future<void> updateThemeMode({
    required String currentUserId,
    String themeMode = 'light',
  }) async {
    final response = await supabase
        .from('profiles')
        .update({'theme_mode': themeMode}).eq('id', currentUserId);
    log('Updated theme mode for user $currentUserId to $themeMode: $response');
  }
}
