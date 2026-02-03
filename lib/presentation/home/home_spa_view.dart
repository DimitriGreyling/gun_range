import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gun_range_app/core/theme/theme_provider.dart';
import 'package:gun_range_app/domain/services/global_popup_service.dart';
import 'package:gun_range_app/presentation/widgets/controllers/expanded_collapsed_menu_controller.dart';
import 'package:gun_range_app/providers/auth_state_provider.dart';
import 'package:gun_range_app/providers/supabase_provider.dart';
import 'package:gun_range_app/providers/viewmodel_providers.dart';

class HomeSPAView extends ConsumerStatefulWidget {
  final Widget child;

  const HomeSPAView({Key? key, required this.child}) : super(key: key);

  @override
  _HomeSPAViewState createState() => _HomeSPAViewState();
}

class _HomeSPAViewState extends ConsumerState<HomeSPAView> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Dashboard')),
    Center(child: Text('Bookings')),
    Center(child: Text('Profile')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _handleAccountMenuSelection(String value) async {
    switch (value) {
      case 'profile':
        if (!mounted) return;
        GoRouter.of(context).go('/profile');
        return;
      case 'logout':
        {
          GlobalPopupService.showAction(
              title: 'Logout',
              message: 'Are you sure you want to logout?',
              actionText: 'Logout',
              onAction: () async {
                await ref.read(authViewModelProvider.notifier).signOut();
              });

          return;
        }
      case 'theme_mode':
        {
          final themeToggler = ref.read(themeModeTogglerProvider);
          themeToggler.toggleThemeMode(ref);
          return;
        }
    }
  }

  static String _initialFromFullName(String? fullName) {
    final splitList = fullName?.split(' ');
    if (splitList == null || splitList.isEmpty) return '?';
    String initials = '';

    for (var part in splitList) {
      if (part.isNotEmpty) {
        initials += part.characters.first.toUpperCase();
      }
    }

    return initials;
  }

  @override
  Widget build(BuildContext context) {
    //MENU
    final menuExpanded = ref.watch(menuExpandedProvider);
    final menuWidth = menuExpanded ? 280.0 : 80.0;

    //Ranges and Events would be fetched from ViewModels
    final rangeState = ref.watch(rangeViewModelProvider);

    //Get user authentication state
    final isAuthed = ref.watch(isAuthenticatedProvider);

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 16.0),
          _buildHeader(isAuthed),
          const SizedBox(height: 16.0),
          Expanded(
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  width: menuWidth,
                  child: SizedBox(
                    width: menuWidth,
                    child: _buildMenu(menuExpanded),
                  ),
                ),
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildHeader(bool isAuthed) {
    final user = ref.watch(supabaseProvider).auth.currentUser;

    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 2,
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'assets/logo/logo_bigger.svg',
                      height: 60,
                    ),
                    Text('RangeConnect',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const Spacer(),
                    if (isAuthed)
                      Row(
                        children: [
                          PopupMenuButton<String>(
                            tooltip: 'Account',
                            position: PopupMenuPosition.under,
                            offset: const Offset(0, 8),
                            onSelected: _handleAccountMenuSelection,
                            itemBuilder: (context) => [
                              const PopupMenuItem<String>(
                                value: 'profile',
                                child: Text('Profile'),
                              ),
                              const PopupMenuDivider(),
                              PopupMenuItem<String>(
                                value: 'theme_mode',
                                child: Row(
                                  children: [
                                    const Text('Theme Mode'),
                                    const Spacer(),
                                    if (Theme.of(context).brightness ==
                                        Brightness.dark)
                                      const Icon(Icons.brightness_2),
                                    if (Theme.of(context).brightness ==
                                        Brightness.light)
                                      const Icon(Icons.brightness_6),
                                  ],
                                ),
                              ),
                              const PopupMenuDivider(),
                              const PopupMenuItem<String>(
                                value: 'logout',
                                child: Text('Logout'),
                              ),
                            ],
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                child: Text(
                                  _initialFromFullName(user
                                      ?.userMetadata?['full_name'] as String?),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          // const SizedBox(width: 12),
                          // Text(
                          //   user?.email ?? 'Account',
                          //   style: Theme.of(context)
                          //       .textTheme
                          //       .bodyLarge
                          //       ?.copyWith(
                          //         color:
                          //             Theme.of(context).colorScheme.onPrimary,
                          //       ),
                          // ),
                        ],
                      ),
                    if (!isAuthed)
                      ElevatedButton(
                          onPressed: () {
                            GoRouter.of(context).go('/login');
                          },
                          child: Text('Login/Register',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary))),
                  ],
                )),
          ),
        ),
      ],
    );
  }

  Widget _buildMenu(bool expanded) {
    return Material(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildMenuHeader(expanded),
          _buildTitle(
            icon: Icons.dashboard,
            label: 'Home',
            expanded: expanded,
            path: '/home',
          ),
          _buildTitle(
            icon: Icons.book_online,
            label: 'Bookings',
            expanded: expanded,
            path: '/bookings',
          ),
          _buildTitle(
            icon: Icons.settings,
            label: 'Settings',
            expanded: expanded,
            path: '/settings',
          ),
        ],
      ),
    );
  }

  Widget _buildMenuHeader(bool expanded) {
    if (!expanded) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  onPressed: () =>
                      ref.read(menuExpandedProvider.notifier).toggle(),
                  icon: Icon(Icons.menu,
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider()
          ],
        ),
      );
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, anim) => FadeTransition(
                        opacity: anim,
                        child: SizeTransition(
                          sizeFactor: anim,
                          axis: Axis.horizontal,
                          child: child,
                        ),
                      ),
                      child: expanded
                          ? Align(
                              key: const ValueKey('MenuLabel'),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Menu',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            )
                          : const SizedBox(key: ValueKey('collapsed')),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider()
            ],
          ),
          Positioned(
            top: 0,
            right: -10,
            child: IconButton.filledTonal(
              onPressed: () => ref.read(menuExpandedProvider.notifier).toggle(),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle({
    required IconData icon,
    required String label,
    required bool expanded,
    required String path,
  }) {
    if (expanded) {
      return ListTile(
        onTap: () {
          context.go(path);
        },
        leading: Icon(icon),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SizeTransition(
              sizeFactor: anim,
              axis: Axis.horizontal,
              child: child,
            ),
          ),
          child: expanded
              ? Align(
                  key: ValueKey(label),
                  alignment: Alignment.centerLeft,
                  child: Text(label,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false),
                )
              : const SizedBox(key: ValueKey('collapsed')),
        ),
        minLeadingWidth: 0,
      );
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(icon),
          if (expanded) const SizedBox(width: 12),
          if (expanded)
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
