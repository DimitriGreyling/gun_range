import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/auth/login_screen.dart';
import '../../presentation/ranges/range_list_screen.dart';
import '../../presentation/events/event_list_screen.dart';
import '../../presentation/bookings/booking_list_screen.dart';
import '../../presentation/owner/owner_dashboard_screen.dart';
import '../../presentation/profile/profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
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
  ],
);
