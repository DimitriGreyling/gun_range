import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gun_range_app/presentation/home/auth_guard.dart';
import 'package:gun_range_app/presentation/home/home_screen_desktop.dart';
import 'package:gun_range_app/presentation/home/home_screen_mobile.dart';
import 'package:gun_range_app/presentation/home/home_screen_web.dart';

class ProfileAppShell extends StatelessWidget {
  const ProfileAppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);
    final isWeb = kIsWeb;
    final isDesktop = !isMobile && !isWeb;

    if (isMobile) {
      return AuthGuard(child: HomeScreenMobile());
    } else if (isWeb) {
      return AuthGuard(child: HomeScreenMobile());
    } else {
      return AuthGuard(child: HomeScreenMobile());
    }
  }
}
