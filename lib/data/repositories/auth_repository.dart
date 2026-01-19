import 'package:supabase/supabase.dart';

class AuthRepository {
  final SupabaseClient supabase;
  AuthRepository(this.supabase);

  Future<String> signIn(String email, String password) async {
    final response = await supabase.auth
        .signInWithPassword(email: email, password: password);
    if (response.user == null) throw Exception('Sign in failed');
    return response.user!.id;
  }

  Future<String> register(String email, String password) async {
    final response =
        await supabase.auth.signUp(email: email, password: password);
    if (response.user == null) throw Exception('Registration failed');
    return response.user!.id;
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
