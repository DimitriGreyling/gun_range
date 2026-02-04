import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gun_range_app/presentation/home/home_spa_view.dart';
import 'package:gun_range_app/presentation/make_booking/make_booking_web.dart';
import 'package:gun_range_app/presentation/range_detail.dart/range_detail_web.dart';

class MakeBookingAppShell extends StatelessWidget {
  final String? rangeId;

  const MakeBookingAppShell({super.key, this.rangeId});

  @override
  Widget build(BuildContext context) {
    final isMobile = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android);
    final isWeb = kIsWeb;
    final isDesktop = !isMobile && !isWeb;

    if (isMobile) {
      return MakeBookingWeb(rangeId: rangeId);
    } else if (isWeb) {
      return HomeSPAView(child: MakeBookingWeb(rangeId: rangeId));
    } else {
      return MakeBookingWeb(rangeId: rangeId);
    }
  }
}
