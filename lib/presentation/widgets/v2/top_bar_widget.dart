import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gun_range_app/core/constants/general_constants.dart';
import 'package:gun_range_app/data/models/v2/top_bar_item.dart';
import 'package:gun_range_app/domain/services/global_popup_service.dart';
import 'package:gun_range_app/presentation/widgets/v2/gradient_button.dart';
import 'package:gun_range_app/providers/auth_state_provider.dart';
import 'package:gun_range_app/providers/viewmodel_providers.dart';

class TopBarWidget extends ConsumerStatefulWidget {
  const TopBarWidget({super.key});

  @override
  ConsumerState<TopBarWidget> createState() => _TopBarWidgetState();
}

class _TopBarWidgetState extends ConsumerState<TopBarWidget> {
  final List<TopBarItem> topBarItems = [
    const TopBarItem(
      destination: TopBarDestination.home,
      label: 'HOME',
      routeName: 'home',
      path: '/home',
    ),
    const TopBarItem(
      destination: TopBarDestination.ranges,
      label: 'RANGES',
      routeName: 'ranges',
      path: '/ranges',
    ),
    // const TopBarItem(
    //   destination: TopBarDestination.ranges,
    //   label: 'PROFILE',
    //   routeName: 'profile',
    //   path: '/profile',
    // ),
  ];

  TopBarDestination _destinationFromLocation(String location) {
    if (location == '/home' || location == '/') {
      return TopBarDestination.home;
    }
    if (location.startsWith('/ranges')) {
      return TopBarDestination.ranges;
    }
    if (location.startsWith('/events')) {
      return TopBarDestination.events;
    }
    if (location.startsWith('/profile')) {
      return TopBarDestination.profile;
    }
    if (location.startsWith('/login')) {
      return TopBarDestination.login;
    }
    return TopBarDestination.unknown;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width >= 1400
        ? 48.0
        : width >= 1024
            ? 32.0
            : 20.0;

    final topBarState = ref.watch(topBarViewModelProvider);
    final location = GoRouterState.of(context).matchedLocation;
    final activeDestination = _destinationFromLocation(location);
    final isAuthed = ref.read(isAuthenticatedProvider);
    final authViewModel = ref.read(authViewModelProvider.notifier);
    final authState = ref.watch(authViewModelProvider);

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface.withOpacity(0.92),
        border: Border(
          bottom: BorderSide(
            color: scheme.outlineVariant.withOpacity(0.30),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.45),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1600),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 20,
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 16,
                spacing: 24,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 24,
                    runSpacing: 12,
                    children: [
                      Image.asset(
                        'assets/logo/logo_no_buffer.png',
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox.shrink();
                        },
                        frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) {
                          return const CircularProgressIndicator(
                            strokeWidth: 1,
                          );
                        },
                        height: 50,
                      ),
                      Text(
                        GeneralConstants.appName.toUpperCase(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          fontSize: 18,
                        ),
                      ),
                      Wrap(
                        spacing: 20,
                        runSpacing: 8,
                        children: [
                          _navItem(
                            theme,
                            'HOME',
                            active: activeDestination == TopBarDestination.home,
                            callBack: () => context.goNamed('home'),
                          ),
                          _navItem(
                            theme,
                            'RANGES',
                            active:
                                activeDestination == TopBarDestination.ranges,
                            callBack: () => context.goNamed('ranges'),
                          ),
                          _navItem(
                            theme,
                            'EVENTS',
                            active:
                                activeDestination == TopBarDestination.events,
                            callBack: () => context.goNamed('events'),
                          ),
                          // if (isAuthed)
                          //   _navItem(
                          //     theme,
                          //     'PROFILE',
                          //     active: activeDestination ==
                          //         TopBarDestination.profile,
                          //     callBack: () => context.goNamed('profile'),
                          //     disabled: !isAuthed,
                          //   ),
                        ],
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      if (isAuthed)
                        CircleAvatar(
                          child: IconButton(
                            onPressed: () {
                              context.goNamed('profile');
                            },
                            icon: Icon(
                              Icons.person,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      if (!isAuthed)
                        GradientButton(
                          label: 'LOGIN',
                          onPressed: () {
                            context.goNamed('login');
                          },
                          tone: GradientButtonTone.tertiary,
                        ),
                      // if (isAuthed)
                      //   GradientButton(
                      //     label: 'LOG OUT',
                      //     onPressed: () {
                      //       authViewModel.signOut();
                      //     },
                      //     tone: GradientButtonTone.secondary,
                      //   ),
                      if (isAuthed)
                        GradientButton(
                          label: 'QUICK BOOK',
                          onPressed: () {},
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    ThemeData theme,
    String label, {
    bool active = false,
    VoidCallback? callBack,
    bool disabled = false,
  }) {
    final scheme = theme.colorScheme;

    return MouseRegion(
      cursor: MouseCursor.defer,
      child: InkWell(
        onTap: disabled
            ? null
            : () {
                callBack?.call();
              },
        child: Container(
          padding: const EdgeInsets.only(bottom: 4),
          decoration: active
              ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: scheme.primaryContainer,
                      width: 2,
                    ),
                  ),
                )
              : null,
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: disabled
                  ? scheme.outlineVariant
                  : active
                      ? scheme.primary
                      : scheme.onSurfaceVariant,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}
