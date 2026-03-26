class SystemHealth {
  final bool ok;
  final bool configOk;
  final bool supabaseOk;
  final bool backendOk;
  final Duration latency;
  final String? message;

  const SystemHealth({
    required this.ok,
    required this.configOk,
    required this.supabaseOk,
    required this.backendOk,
    required this.latency,
    this.message,
  });
}