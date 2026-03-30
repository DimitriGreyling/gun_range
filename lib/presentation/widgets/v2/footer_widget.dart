import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FooterWidget extends ConsumerStatefulWidget {
  const FooterWidget({super.key});

  @override
  ConsumerState<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends ConsumerState<FooterWidget> {
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
      width: double.infinity,
      color: scheme.surfaceContainerLow,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 48,
            ),
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 1100
                        ? 4
                        : constraints.maxWidth >= 720
                            ? 2
                            : 1;

                    return GridView.count(
                      crossAxisCount: columns,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: columns == 1 ? 2.6 : 1.4,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SENTINEL TACTICAL',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: scheme.onSurface,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Connecting the tactical community to elite training environments. We are the premier platform for professional-grade shooting experiences and tactical education.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
                                height: 1.7,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                _footerIcon(theme, Icons.public),
                                const SizedBox(width: 12),
                                _footerIcon(theme, Icons.photo_camera_outlined),
                                const SizedBox(width: 12),
                                _footerIcon(theme, Icons.play_circle_outline),
                              ],
                            ),
                          ],
                        ),
                        _footerLinks(
                          theme,
                          title: 'PLATFORM',
                          items: const [
                            'Search Ranges',
                            'Browse Events',
                            'Safety Standards',
                          ],
                        ),
                        _footerLinks(
                          theme,
                          title: 'PARTNERS',
                          items: const [
                            'List Your Range',
                            'Partner Dashboard',
                            'Sponsorships',
                          ],
                        ),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       'GLOBAL PRESENCE',
                        //       style: theme.textTheme.labelMedium?.copyWith(
                        //         color: scheme.primary,
                        //         fontWeight: FontWeight.w900,
                        //         letterSpacing: 1.2,
                        //       ),
                        //     ),
                        //     const SizedBox(height: 16),
                        //     Text(
                        //       'Serving over 500 locations\nAcross 48 States\nHeadquarters: Phoenix, AZ',
                        //       style: theme.textTheme.bodyMedium?.copyWith(
                        //         color: scheme.onSurfaceVariant,
                        //         height: 1.8,
                        //       ),
                        //     ),
                        //     const SizedBox(height: 16),
                        //     Container(
                        //       height: 96,
                        //       decoration: BoxDecoration(
                        //         color: scheme.surfaceContainerHighest,
                        //         borderRadius: BorderRadius.circular(12),
                        //         border: Border.all(
                        //           color:
                        //               scheme.outlineVariant.withOpacity(0.25),
                        //         ),
                        //       ),
                        //       child: Center(
                        //         child: Icon(
                        //           Icons.map_outlined,
                        //           color: scheme.primary.withOpacity(0.75),
                        //           size: 32,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 24),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: scheme.outlineVariant.withOpacity(0.30),
                      ),
                    ),
                  ),
                  child: Text(
                    '© 2024 SENTINEL TACTICAL NETWORK. ALL RIGHTS RESERVED.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                      );
                    }

                    return Text('V${snapshot.data?.version}');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _footerIcon(ThemeData theme, IconData icon) {
    final scheme = theme.colorScheme;

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: scheme.onSurfaceVariant, size: 18),
    );
  }

  Widget _footerLinks(
    ThemeData theme, {
    required String title,
    required List<String> items,
  }) {
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelMedium?.copyWith(
            color: scheme.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              item.toUpperCase(),
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ),
      ],
    );
  }
}
