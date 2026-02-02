import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gun_range_app/presentation/range_detail.dart/range_detail_web.dart';

class RangeDetailAppShell extends StatelessWidget {
  final String? rangeId;

  const RangeDetailAppShell({super.key, this.rangeId});

  @override
  Widget build(BuildContext context) {
    final isMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);
    final isWeb = kIsWeb;
    final isDesktop = !isMobile && !isWeb;

    if (isMobile) {
      return RangeDetailWeb();
    } else if (isWeb) {
      return const RangeDetailWeb();
    } else {
      return const RangeDetailWeb();
    }
  }
}
