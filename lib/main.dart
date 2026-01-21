import 'dart:ui';

import 'package:cloudflare_turnstile/cloudflare_turnstile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gun_range_app/domain/services/global_popup_service.dart';
import 'package:gun_range_app/presentation/widgets/popup/global_popup_overlay.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/routing/app_router.dart';
import 'core/theme/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  if (supabaseUrl == null) {
    throw Exception('SUPABASE_URL not found in .env');
  }

  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
  if (supabaseAnonKey == null) {
    throw Exception('SUPABASE_ANON_KEY not found in .env');
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  final container = ProviderContainer();
  GlobalPopupService.initialize(container);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final themeMode = ref.watch(themeModeProvider);

        return MaterialApp.router(
          restorationScopeId: 'app',
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.trackpad,
              PointerDeviceKind.stylus,
              PointerDeviceKind.unknown,
            },
          ),
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          title: 'Range Connect',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          builder: (context, child) {
            if (child == null) return const SizedBox.shrink();

            return GlobalPopupOverlay(
              child: TurnstileGate(
                child: child,
              ),
            );
          },
        );
      },
    );
  }
}

class TurnstileGate extends StatefulWidget {
  final Widget child;
  const TurnstileGate({super.key, required this.child});

  @override
  State<TurnstileGate> createState() => _TurnstileGateState();
}

class _TurnstileGateState extends State<TurnstileGate> {
  final TurnstileController _controller = TurnstileController();

  bool _verified = false;
  String? _lastError;

  final TurnstileOptions _options = TurnstileOptions(
    size: TurnstileSize.normal,
    theme: TurnstileTheme.light,
    language: 'ar',
    retryAutomatically: false,
    refreshTimeout: TurnstileRefreshTimeout.manual,
  );

  @override
  Widget build(BuildContext context) {
    // Once verified, show the app UI and never rebuild Turnstile again.
    if (_verified) return widget.child;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Please verify to continue',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                CloudflareTurnstile(
                  siteKey: '0x4AAAAAACN1eNs8QRNLB3o5',
                  controller: _controller,
                  options: _options,
                  onTokenReceived: (token) {
                    // IMPORTANT: don’t call refresh/isExpired here.
                    // Just accept token and move on.
                    if (token.isNotEmpty) {
                      setState(() {
                        _verified = true;
                        _lastError = null;
                      });
                    }
                  },
                  onError: (error) {
                    setState(() {
                      _lastError = error.toString();
                    });
                  },
                  onTokenExpired: () {
                    setState(() {
                      _verified = false;
                    });
                  },
                ),
                if (_lastError != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _lastError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () {
                      setState(() => _lastError = null);
                      _controller.refreshToken();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
