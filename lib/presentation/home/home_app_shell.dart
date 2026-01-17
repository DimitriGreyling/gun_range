import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gun_range_app/presentation/home/home_screen_desktop.dart';
import 'package:gun_range_app/presentation/home/home_screen_mobile.dart';
import 'package:gun_range_app/presentation/home/home_screen_web.dart';

class HomeAppShell extends StatelessWidget {
  const HomeAppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);
    final isWeb = kIsWeb;
    final isDesktop = !isMobile && !isWeb;

    if (isMobile) {
      return HomeScreenMobile();
    } else if (isWeb) {
      return const HomeScreenWeb();
    } else {
      return const HomeScreenDesktop();
    }
  }
}
