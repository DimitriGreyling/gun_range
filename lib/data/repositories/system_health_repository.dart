import 'package:gun_range_app/data/models/v2/system_health.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HealthRepository {
  final SupabaseClient client;

  HealthRepository(this.client);

  Future<SystemHealth> check() async {
    final started = DateTime.now();

    try {
      final result = await client
          .rpc('health_check')
          .timeout(const Duration(seconds: 3));

      final latency = DateTime.now().difference(started);

      return SystemHealth(
        ok: true,
        configOk: true,
        supabaseOk: true,
        backendOk: true,
        latency: latency,
        message: result.toString(),
      );
    } catch (e) {
      final latency = DateTime.now().difference(started);

      return SystemHealth(
        ok: false,
        configOk: true,
        supabaseOk: true,
        backendOk: false,
        latency: latency,
        message: e.toString(),
      );
    }
  }
}