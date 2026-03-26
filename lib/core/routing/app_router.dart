import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:gun_range_app/presentation/auth/login_page_v2.dart';
import 'package:gun_range_app/presentation/home/home_screen_web_2.dart';
import 'package:gun_range_app/presentation/make_booking/make_booking_v2.dart';
import 'package:gun_range_app/presentation/profile/profile_page_widget.dart';
import 'package:gun_range_app/presentation/ranges/ranges_screen_v2.dart';
import 'package:gun_range_app/presentation/target_capturing/target_capturing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final isMobile = !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);
const isWeb = kIsWeb;
final isDesktop = !isMobile && !isWeb;

final appRouter = GoRouter(
  initialLocation: isDesktop ? '/login' : '/home',
  restorationScopeId: 'appRouter',
  routes: [
    GoRoute(
      name: 'home',
      path: '/home',
      builder: (context, state) => const HomeScreenWeb2(),
    ),
    GoRoute(
      name: 'home-2',
      path: '/',
      builder: (context, state) => const HomeScreenWeb2(),
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginPageV2(),
    ),
    GoRoute(
      name: 'ranges',
      path: '/ranges',
      builder: (context, state) {
        final filters = state.uri.queryParameters;
        return const RangesScreenV2();
      }
    ),
    GoRoute(
      path: '/make-booking',
      builder: (context, state) {
        log('TESTING :: ${state}');
        return const MakeBookingV2();
      },
    ),
    GoRoute(
      name: 'profile',
      path: '/profile',
      builder: (context, state) => const ProfilePageWidget(),
    ),
    GoRoute(
      name: 'target',
      path: '/target',
      builder: (context, state) => const TargetCapturing(),
    ),
  ],
);
