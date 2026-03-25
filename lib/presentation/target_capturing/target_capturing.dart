import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/core/constants/app_colors.dart';
import 'package:gun_range_app/presentation/widgets/v2/gradient_button.dart';

class TargetCapturing extends ConsumerStatefulWidget {
  const TargetCapturing({super.key});

  @override
  ConsumerState<TargetCapturing> createState() => _TargetCapturingState();
}

class _TargetCapturingState extends ConsumerState<TargetCapturing> {
  static const _shotEntries = [
    _ShotEntry(
      index: '01',
      label: 'BULLSEYE (X)',
      coordinate: '0.12, -0.04',
      score: '10.0',
      leftFactor: 0.51,
      topFactor: 0.48,
      tone: _ShotTone.tertiary,
    ),
    _ShotEntry(
      index: '02',
      label: 'BULLSEYE (X)',
      coordinate: '-0.08, 0.02',
      score: '10.0',
      leftFactor: 0.49,
      topFactor: 0.52,
      tone: _ShotTone.tertiary,
    ),
    _ShotEntry(
      index: '03',
      label: 'INNER RING',
      coordinate: '0.45, 0.12',
      score: '9.8',
      leftFactor: 0.53,
      topFactor: 0.50,
      tone: _ShotTone.primary,
    ),
    _ShotEntry(
      index: '04',
      label: 'INNER RING',
      coordinate: '-0.22, -0.34',
      score: '9.6',
      leftFactor: 0.48,
      topFactor: 0.47,
      tone: _ShotTone.primary,
    ),
    _ShotEntry(
      index: '05',
      label: 'OUTER RING',
      coordinate: '1.12, 0.84',
      score: '8.4',
      leftFactor: 0.52,
      topFactor: 0.51,
      tone: _ShotTone.primaryContainer,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 1200;
    final isTablet = width >= 800;
    final horizontalPadding = isDesktop
        ? 32.0
        : isTablet
            ? 24.0
            : 16.0;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      scheme.surface,
                      scheme.surfaceContainerLow.withOpacity(0.55),
                      scheme.surface,
                    ],
                  ),
                ),
              ),
            ),
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      8,
                      horizontalPadding,
                      isTablet ? 32 : 96,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1480),
                        child: Column(
                          children: [
                            _buildTopNavigation(context),
                            const SizedBox(height: 24),
                            isDesktop
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: _buildSessionColumn(context),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        flex: 6,
                                        child: _buildTargetColumn(context),
                                      ),
                                      const SizedBox(width: 24),
                                      Expanded(
                                        flex: 3,
                                        child: _buildShotLog(context),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      _buildSessionColumn(context),
                                      const SizedBox(height: 20),
                                      _buildTargetColumn(context),
                                      const SizedBox(height: 20),
                                      _buildShotLog(context),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (!isTablet) _buildBottomNavigation(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavigation(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: scheme.surface.withOpacity(0.96),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.surfaceContainerHighest),
      ),
      child: Row(
        children: [
          Icon(Icons.menu, color: scheme.primary, size: 22),
          const SizedBox(width: 14),
          Text(
            'SENTINEL TACTICAL',
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.6,
            ),
          ),
          const Spacer(),
          if (isWide)
            Wrap(
              spacing: 24,
              children: const [
                _NavItem(label: 'Home', selected: true),
                _NavItem(label: 'Ranges'),
                _NavItem(label: 'Events'),
                _NavItem(label: 'Analysis'),
              ],
            ),
          if (isWide) const SizedBox(width: 24),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              shape: BoxShape.circle,
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Icon(
              Icons.person,
              color: scheme.onSurface,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionColumn(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.6,
                  ),
                  children: [
                    const TextSpan(text: 'Live String '),
                    TextSpan(
                      text: '04',
                      style: TextStyle(color: scheme.primaryContainer),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'STATUS: ACTIVE RECORDING',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  letterSpacing: 1.8,
                ),
              ),
            ],
          ),
        ),
        _buildSessionPanel(context),
        const SizedBox(height: 16),
        _buildStatCard(
          context,
          label: 'Group Size',
          value: '1.82',
          suffix: 'MOA',
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          context,
          label: 'Center Offset',
          value: '0.14"',
          suffix: 'LOW/LEFT',
        ),
        const SizedBox(height: 12),
        _buildStatCard(
          context,
          label: 'Current Score',
          value: '98/100',
          emphasize: true,
        ),
      ],
    );
  }

  Widget _buildSessionPanel(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border(
          left: BorderSide(color: scheme.primaryContainer, width: 2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SESSION PARAMETERS',
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 18),
          const _SessionField(label: 'Distance (Yards)', value: '25'),
          const SizedBox(height: 14),
          const _SessionField(label: 'Caliber', value: '9MM LUGER'),
          const SizedBox(height: 14),
          const _SessionField(
            label: 'Weapon Used',
            value: 'SENTINEL-X CUSTOM',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    String? suffix,
    bool emphasize = false,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
            emphasize ? scheme.surfaceContainerHigh : scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        border: emphasize
            ? Border(
                bottom: BorderSide(color: scheme.tertiary, width: 2),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: emphasize ? scheme.tertiary : scheme.onSurfaceVariant,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: (emphasize
                          ? theme.textTheme.displayLarge
                          : theme.textTheme.headlineLarge)
                      ?.copyWith(
                    fontSize: emphasize ? 40 : 30,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                if (suffix != null)
                  TextSpan(
                    text: '  $suffix',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetColumn(BuildContext context) {
    final isTablet = MediaQuery.sizeOf(context).width >= 800;

    return Column(
      children: [
        _buildTargetBoard(context),
        SizedBox(height: isTablet ? 24 : 18),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 14,
          runSpacing: 14,
          children: [
            GradientButton(
              label: 'SAVE SESSION',
              large: true,
              onPressed: () {},
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 18,
                ),
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'NEW STRING',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTargetBoard(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLowest,
          shape: BoxShape.circle,
          border: Border.all(color: scheme.surfaceContainerHighest),
          boxShadow: const [
            BoxShadow(
              color: Color(0xCC000000),
              blurRadius: 100,
              offset: Offset(0, 24),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: CustomPaint(
                painter: _TargetBoardPainter(theme: theme),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _CrosshairPainter(color: scheme.primary),
                ),
              ),
            ),
            for (final shot in _shotEntries)
              Positioned(
                left: shot.leftFactor * MediaQuery.sizeOf(context).width,
                top: shot.topFactor * MediaQuery.sizeOf(context).width,
                child: const SizedBox.shrink(),
              ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    for (final shot in _shotEntries)
                      Positioned(
                        left: constraints.maxWidth * shot.leftFactor - 8,
                        top: constraints.maxHeight * shot.topFactor - 8,
                        child: _ShotMarker(tone: shot.tone),
                      ),
                    Positioned(
                      left: 24,
                      bottom: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PRECISION TARGET V2.4',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Interactive Plotting Enabled',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 10,
                              color: scheme.onSurfaceVariant.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShotLog(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              border: Border(
                bottom: BorderSide(color: scheme.surfaceContainerHighest),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'SHOT LOG',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.6,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'AUTO-SYNC',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.primaryContainer,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 600),
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(12),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final shot = _shotEntries[index];
                return _ShotLogTile(shot: shot);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: _shotEntries.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextButton(
              onPressed: () {},
              child: Text(
                'CLEAR TARGET',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: scheme.surface.withOpacity(0.92),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: scheme.surfaceContainerHighest),
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withOpacity(0.45),
              blurRadius: 30,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomNavItem(
              icon: Icons.home_outlined,
              label: 'Home',
              color: scheme.onSurfaceVariant,
            ),
            _BottomNavItem(
              icon: Icons.my_location_outlined,
              label: 'Ranges',
              color: scheme.onSurfaceVariant,
            ),
            _BottomNavItem(
              icon: Icons.analytics_outlined,
              label: 'Analysis',
              color: scheme.primaryContainer,
              selected: true,
            ),
            _BottomNavItem(
              icon: Icons.person_outline,
              label: 'Profile',
              color: scheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionField extends StatelessWidget {
  const _SessionField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              letterSpacing: 1.6,
            ),
          ),
        ),
        TextFormField(
          initialValue: value,
          readOnly: true,
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: scheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _ShotLogTile extends StatelessWidget {
  const _ShotLogTile({required this.shot});

  final _ShotEntry shot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = switch (shot.tone) {
      _ShotTone.tertiary => scheme.tertiary,
      _ShotTone.primary => scheme.primary,
      _ShotTone.primaryContainer => scheme.primaryContainer,
    };

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          right: BorderSide(color: accent, width: 4),
        ),
      ),
      child: Row(
        children: [
          Text(
            shot.index,
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shot.label,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'COORD: ${shot.coordinate}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant.withOpacity(0.75),
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            shot.score,
            style: theme.textTheme.titleLarge?.copyWith(
              color: accent,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShotMarker extends StatelessWidget {
  const _ShotMarker({required this.tone});

  final _ShotTone tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = switch (tone) {
      _ShotTone.tertiary => scheme.tertiary,
      _ShotTone.primary => scheme.primary,
      _ShotTone.primaryContainer => scheme.primaryContainer,
    };

    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.45),
            blurRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: scheme.surface,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Text(
      label.toUpperCase(),
      style: theme.textTheme.labelMedium?.copyWith(
        color: selected ? scheme.primary : scheme.onSurfaceVariant,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.color,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? scheme.surfaceContainerLow : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _TargetBoardPainter extends CustomPainter {
  const _TargetBoardPainter({required this.theme});

  final ThemeData theme;

  @override
  void paint(Canvas canvas, Size size) {
    final scheme = theme.colorScheme;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2;

    final gridPaint = Paint()
      ..color = scheme.surfaceContainerHighest.withOpacity(0.55)
      ..strokeWidth = 1;

    const step = 24.0;
    for (double x = 0; x <= size.width; x += step) {
      for (double y = 0; y <= size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1, gridPaint);
      }
    }

    final outerPaint = Paint()
      ..color = AppColors.surfaceContainerLow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final middlePaint = Paint()
      ..color = AppColors.surfaceContainerLow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final innerFillPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.black,
          scheme.surfaceContainerHighest,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.55));
    final innerBorderPaint = Paint()
      ..color = scheme.surfaceContainerHighest
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    final bullRingPaint = Paint()
      ..color = scheme.primaryContainer.withOpacity(0.22)
      ..style = PaintingStyle.fill;
    final bullRingStroke = Paint()
      ..color = scheme.primaryContainer.withOpacity(0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final bullPaint = Paint()
      ..color = scheme.primaryContainer
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawCircle(center, radius * 0.45, outerPaint);
    canvas.drawCircle(center, radius * 0.35, middlePaint);
    canvas.drawCircle(center, radius * 0.26, innerFillPaint);
    canvas.drawCircle(center, radius * 0.26, innerBorderPaint);
    canvas.drawCircle(center, radius * 0.13, bullRingPaint);
    canvas.drawCircle(center, radius * 0.13, bullRingStroke);
    canvas.drawCircle(center, radius * 0.022, bullPaint);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    void paintRingLabel(String label, double y, Color color) {
      textPainter.text = TextSpan(
        text: label,
        style: theme.textTheme.titleLarge?.copyWith(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(center.dx - textPainter.width / 2, y),
      );
    }

    paintRingLabel(
        '7', size.height * 0.12, scheme.onSurfaceVariant.withOpacity(0.4));
    paintRingLabel(
        '8', size.height * 0.22, scheme.onSurfaceVariant.withOpacity(0.55));
    paintRingLabel('9', size.height * 0.32, scheme.onSurface);
    paintRingLabel('X', size.height * 0.38, scheme.primaryContainer);
  }

  @override
  bool shouldRepaint(covariant _TargetBoardPainter oldDelegate) => false;
}

class _CrosshairPainter extends CustomPainter {
  const _CrosshairPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color.withOpacity(0.10)
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      linePaint,
    );

    final ringPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.shortestSide * 0.08,
      ringPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CrosshairPainter oldDelegate) => false;
}

class _ShotEntry {
  const _ShotEntry({
    required this.index,
    required this.label,
    required this.coordinate,
    required this.score,
    required this.leftFactor,
    required this.topFactor,
    required this.tone,
  });

  final String index;
  final String label;
  final String coordinate;
  final String score;
  final double leftFactor;
  final double topFactor;
  final _ShotTone tone;
}

enum _ShotTone {
  tertiary,
  primary,
  primaryContainer,
}
