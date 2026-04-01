import 'package:flutter/material.dart';

class TagPill extends StatelessWidget {
  const TagPill({
    required this.label,
    required this.background,
    required this.foreground,
    this.isLoading = false,
  });

  final String label;
  final Color background;
  final Color foreground;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: isLoading == true
          ? const SizedBox(
              width: 20,
              height: 20,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ),
              ),
            )
          : Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
    );
  }
}