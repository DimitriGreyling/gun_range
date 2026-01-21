import 'dart:ui';

import 'package:cloudflare_turnstile/cloudflare_turnstile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/domain/services/global_popup_service.dart';
import 'package:gun_range_app/presentation/widgets/popup/global_popup_overlay.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/routing/app_router.dart';
import 'core/theme/theme_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables with error handling
  try {
    await dotenv.load(
      fileName: ".env",
    );
  } catch (e) {
    throw Exception('Failed to load .env file: $e');
  }

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
      UncontrolledProviderScope(container: container, child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isVerified = false; // Replace with your verification logic
    final TurnstileOptions options = TurnstileOptions(
      size: TurnstileSize.normal,
      theme: TurnstileTheme.light,
      language: 'ar',
      retryAutomatically: false,
      refreshTimeout: TurnstileRefreshTimeout.manual,
    );

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
            // if (!isVerified) {
            //   return Scaffold(
            //     body: Center(
            //       child: CloudflareTurnstile(
            //         siteKey:
            //             '0x4AAAAAACN1eNs8QRNLB3o5', //Change with your site key
            //         // baseUrl: 'http://localhost:58271/',
            //         onTokenReceived: (token) {
            //           print(token);
            //           setstate
            //         },
            //       ),
            //     ),
            //   );
            // }

            return GlobalPopupOverlay(
                child: TurnstileScreen(
              child: child!,
            ));
          },
        );
      },
    );
  }
}

class TurnstileScreen extends StatefulWidget {
  final Widget child;
  const TurnstileScreen({super.key, required this.child});

  @override
  State<TurnstileScreen> createState() => _TurnstileScreenState();
}

class _TurnstileScreenState extends State<TurnstileScreen> {
  final TurnstileController _turnstileController = TurnstileController();
  bool _isVerified = false; // State to track verification

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Turnstile Demo')),
      body: Center(
        child: _isVerified
            ? // Show your main UI if verified
            widget.child
            : // Show Turnstile if not verified
            CloudflareTurnstile(
                siteKey:
                    '0x4AAAAAACN1eNs8QRNLB3o5', // Replace with your actual key
                controller: _turnstileController,
                onTokenReceived: (token) async {
                  debugPrint("Token received: $token");
                  // Optional: Check if token is actually valid and not expired immediately
                  if (token.isNotEmpty &&
                      !await _turnstileController.isExpired()) {
                    setState(() {
                      _isVerified = true; // Update state to show next UI
                    });
                  } else {
                    debugPrint("Token is invalid or expired, refreshing...");
                    _turnstileController
                        .refreshToken(); // Refresh the token if needed
                  }
                },
                onTokenExpired: () {
                  debugPrint("Token expired, re-prompting...");
                  setState(() {
                    _isVerified = false; // Reset state if token expires
                  });
                },
                // mode: TurnstileMode.invisible, // Use invisible for seamless integration
              ),
      ),
    );
  }
}
