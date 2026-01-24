import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gun_range_app/presentation/add_range/add_range_desktop.dart';
import 'package:gun_range_app/presentation/home/home_screen_desktop.dart';
import 'package:gun_range_app/presentation/home/home_screen_mobile.dart';
import 'package:gun_range_app/presentation/home/home_screen_web.dart';

class AddRangeAppShell extends StatelessWidget {
  const AddRangeAppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);
    final isWeb = kIsWeb;
    final isDesktop = !isMobile && !isWeb;

    if (isMobile) {
      return AddRangeDesktop();
    } else if (isWeb) {
      return const AddRangeDesktop();
    } else {
      return const AddRangeDesktop();
    }
  }
}
