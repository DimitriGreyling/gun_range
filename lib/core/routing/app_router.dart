import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:gun_range_app/presentation/add_range/add_range_app_shell.dart';
import 'package:gun_range_app/presentation/auth/login_app_shell.dart';
import 'package:gun_range_app/presentation/home/home_app_shell.dart';
import 'package:gun_range_app/presentation/home/home_spa_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../presentation/ranges/range_list_screen.dart';
import '../../presentation/events/event_list_screen.dart';
import '../../presentation/bookings/booking_list_screen.dart';
import '../../presentation/owner/owner_dashboard_screen.dart';
import '../../presentation/profile/profile_screen.dart';

final isMobile = !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);
const isWeb = kIsWeb;
final isDesktop = !isMobile && !isWeb;

final appRouter = GoRouter(
  initialLocation: isDesktop ? '/login' : '/home',
  restorationScopeId: 'appRouter',
  redirect: (context, state) {
    if (isDesktop) {
      final isLoggingIn = state.matchedLocation == '/login';
      final isAuthedNow = Supabase.instance.client.auth.currentUser != null;

      if (!isAuthedNow) return isLoggingIn ? null : '/login';
      if (isLoggingIn) return '/home';
    }

    return state.matchedLocation;
  },
  routes: [
    GoRoute(
      name: 'home',
      path: '/home',
      builder: (context, state) => HomeSPAView(
        child: HomeAppShell(),
      ),
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginAppShell(),
    ),
    GoRoute(
      path: '/ranges',
      builder: (context, state) => const RangeListScreen(),
    ),
    GoRoute(
      path: '/events',
      builder: (context, state) => const EventListScreen(),
    ),
    GoRoute(
      path: '/bookings',
      builder: (context, state) => const BookingListScreen(),
    ),
    GoRoute(
      path: '/owner',
      builder: (context, state) => const OwnerDashboardScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/add_range',
      builder: (context, state) => const AddRangeAppShell(),
    ),
  ],
);
