import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/presentation/widgets/v2/gradient_button.dart';

class TopBarWidget extends ConsumerStatefulWidget {
  const TopBarWidget({super.key});

  @override
  ConsumerState<TopBarWidget> createState() => _TopBarWidgetState();
}

class _TopBarWidgetState extends ConsumerState<TopBarWidget> {
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
                      Text(
                        'SENTINEL TACTICAL',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.6,
                        ),
                      ),
                      Wrap(
                        spacing: 20,
                        runSpacing: 8,
                        children: [
                          _navItem(theme, 'HOME', active: true),
                          _navItem(theme, 'RANGES'),
                          _navItem(theme, 'EVENTS'),
                          _navItem(theme, 'MEMBERSHIP'),
                        ],
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'PARTNER LOGIN',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      GradientButton(
                        label: 'BOOK NOW',
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
  }) {
    final scheme = theme.colorScheme;

    return Container(
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
          color: active ? scheme.primary : scheme.onSurfaceVariant,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
