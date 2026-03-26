import 'package:flutter/material.dart';
import 'package:gun_range_app/data/models/v2/widget_models.dart';
import 'package:gun_range_app/presentation/widgets/v2/gradient_button.dart';

class TierCard extends StatelessWidget {
  const TierCard({required this.item});

  final TierItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Transform.scale(
      scale: item.highlighted ? 1.03 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: item.highlighted
              ? scheme.surfaceContainer
              : scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
          border: item.highlighted
              ? Border.all(
                  color: scheme.primary.withOpacity(0.40),
                  width: 2,
                )
              : null,
          boxShadow: item.highlighted
              ? [
                  BoxShadow(
                    color: scheme.shadow.withOpacity(0.40),
                    blurRadius: 28,
                    offset: const Offset(0, 16),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            if (item.badge != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      topRight: Radius.circular(18),
                    ),
                  ),
                  child: Text(
                    item.badge!.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.onPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    item.name.toUpperCase(),
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item.price,
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: 44,
                          fontWeight: FontWeight.w800,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          '/ MONTH',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  for (final feature in item.features)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: scheme.tertiary,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              feature,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: item.highlighted
                        ? GradientButton(
                            label: item.cta,
                            onPressed: () {},
                            large: true,
                          )
                        : OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              backgroundColor: scheme.surfaceContainerHighest,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide.none,
                            ),
                            child: Text(
                              item.cta.toUpperCase(),
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
