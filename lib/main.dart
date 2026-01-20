import 'dart:ui';

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
            return GlobalPopupOverlay(child: child!);
          },
        );
      },
    );
  }
}
