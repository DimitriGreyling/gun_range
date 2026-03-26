import 'package:flutter/material.dart';

enum GradientButtonTone {
  primary,
  secondary,
  tertiary,
}

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.large = false,
    this.tone = GradientButtonTone.primary,
  });

  final String label;
  final void Function()? onPressed;
  final IconData? icon;
  final bool large;
  final GradientButtonTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final colors = _gradientColors(scheme);
    final foregroundColor = _foregroundColor(scheme);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.last.withOpacity(0.20),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: large ? 26 : 20,
              vertical: large ? 18 : 12,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: foregroundColor, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _gradientColors(ColorScheme scheme) {
    switch (tone) {
      case GradientButtonTone.primary:
        return [
          scheme.primary,
          scheme.primaryContainer,
        ];
      case GradientButtonTone.secondary:
        return [
          scheme.secondary,
          scheme.secondaryContainer,
        ];
      case GradientButtonTone.tertiary:
        return [
          scheme.tertiary,
          scheme.tertiaryContainer,
        ];
    }
  }

  Color _foregroundColor(ColorScheme scheme) {
    switch (tone) {
      case GradientButtonTone.primary:
        return scheme.onPrimary;
      case GradientButtonTone.secondary:
        return scheme.onSecondary;
      case GradientButtonTone.tertiary:
        return scheme.onTertiary;
    }
  }
}