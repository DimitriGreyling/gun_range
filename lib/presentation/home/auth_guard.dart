import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/providers/auth_state_provider.dart';

class AuthGuard extends ConsumerWidget {
  final Widget child;

  const AuthGuard({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuth = ref.watch(isAuthenticatedProvider);

    return isAuth
        ? child
        : const Center(child: Text('Please login'));
  }
}
