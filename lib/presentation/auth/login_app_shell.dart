import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/presentation/auth/login_register_desktop.dart';
import 'package:gun_range_app/presentation/auth/login_register_web.dart';

class LoginAppShell extends ConsumerStatefulWidget {
  const LoginAppShell({super.key});

  @override
  ConsumerState<LoginAppShell> createState() => _LoginAppShellState();
}

class _LoginAppShellState extends ConsumerState<LoginAppShell> {
  @override
  Widget build(BuildContext context) {
    final isMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);
    final isWeb = kIsWeb;
    final isDesktop = !isMobile && !isWeb;

    if (isMobile) {
      return const LoginRegisterScreen();
    } else if (isWeb) {
      return const LoginRegisterScreen();
    } else {
      return const LoginRegisterDesktop();
    }
  }
}
