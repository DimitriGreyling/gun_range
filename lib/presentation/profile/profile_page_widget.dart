import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/presentation/widgets/v2/gradient_button.dart';
import 'package:gun_range_app/presentation/widgets/v2/top_bar_widget.dart';
import 'package:gun_range_app/providers/auth_state_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePageWidget extends ConsumerStatefulWidget {
  const ProfilePageWidget({super.key});

  @override
  ConsumerState<ProfilePageWidget> createState() => _ProfilePageWidgetState();
}

class _ProfilePageWidgetState extends ConsumerState<ProfilePageWidget> {
  static const String _memberImageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuB9BWBFPPR9rgMifqjdVhzvXW3vP3bQjvQI5hz4iyuTEbgVx2AMlJ1IMxglyVu5Xnqi0jILhRGt4r8G91M1Aq1rGSsMx5ki_nXwrRJVnwIGyz7hKan_2WXxEmYxNDe_aBbnyZwjElLjUjVq-j4qkD-_9OlZAcm0dnWs0DqnWS6zAF-JxZGFNCzHkD46pzlDv0aWuslkVFFGZlvdl0rSLQdQ1pg4hmiosC4Buk3tZdgrBtsXM7dJ7Fj0R2ntVVqCL4zNcgHBVrKgtP-w';

  static const List<_HeroMetric> _heroMetrics = [
    _HeroMetric(
      label: 'Range Temp',
      value: '72°F',
      trailing: '/ OPTIMAL',
    ),
    _HeroMetric(
      label: 'Active Lanes',
      value: '14',
      trailing: '/ 24',
    ),
    _HeroMetric(
      label: 'Humidity',
      value: '42%',
    ),
  ];

  static const List<_ProtocolItem> _protocols = [
    _ProtocolItem(
      title: 'Eye & Ear Protection',
      description: 'Must be worn at all times while behind the firing line.',
    ),
    _ProtocolItem(
      title: 'Weapon Manipulation',
      description: 'No drawing from holsters unless holster-qualified.',
    ),
  ];

  static const List<_TrainingHistoryRow> _historyRows = [
    _TrainingHistoryRow(
      date: 'Oct 12, 2024',
      sessionType: 'Pistol Fundamental I',
      status: 'Completed',
      duration: '60m',
      archived: false,
    ),
    _TrainingHistoryRow(
      date: 'Oct 05, 2024',
      sessionType: 'Dynamic Movement',
      status: 'Completed',
      duration: '90m',
      archived: false,
    ),
    _TrainingHistoryRow(
      date: 'Sep 28, 2024',
      sessionType: 'Advanced Low Light',
      status: 'Archived',
      duration: '120m',
      archived: true,
    ),
  ];

  static const List<String> _operationsLinks = [
    'Safety Protocols',
    'Range Rules',
    'Training Modules',
  ];

  static const List<String> _supportLinks = [
    'Contact Support',
    'Privacy Policy',
    'Terms of Service',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final user = ref.watch(authUserProvider).valueOrNull;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              scheme.surface,
              scheme.surfaceContainerLowest,
            ],
          ),
        ),
        child: Column(
          children: [
            const TopBarWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildMainContent(theme: theme, user: user),
                    _buildFooter(theme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(ThemeData theme) {
    final scheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface.withOpacity(0.92),
        border: Border(
          bottom: BorderSide(
            color: scheme.surfaceContainerHighest.withOpacity(0.30),
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
                horizontal: _horizontalPadding(context),
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
                    spacing: 28,
                    runSpacing: 12,
                    children: [
                      Text(
                        'SENTINEL TACTICAL',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Wrap(
                        spacing: 20,
                        runSpacing: 8,
                        children: [
                          _navItem(theme, 'HOME'),
                          _navItem(theme, 'BOOKING'),
                          _navItem(theme, 'PLANS'),
                          _navItem(theme, 'DASHBOARD', active: true),
                        ],
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      GradientButton(
                        label: 'RESERVE LANE',
                        onPressed: () {},
                      ),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerLow,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.account_circle_outlined,
                          color: scheme.onSurfaceVariant,
                        ),
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
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMainContent({required ThemeData theme, User? user}) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            _horizontalPadding(context),
            40,
            _horizontalPadding(context),
            64,
          ),
          child: Column(
            children: [
              _buildHero(theme: theme, user: user),
              const SizedBox(height: 32),
              _buildDashboard(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero({required ThemeData theme, User? user}) {
    final scheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 1100;

        return Flex(
          direction: stacked ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: stacked ? 0 : 8,
              child: Padding(
                padding: EdgeInsets.only(right: stacked ? 0 : 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: scheme.outlineVariant.withOpacity(0.20),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: scheme.tertiary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'LIVE SYSTEM ACTIVE',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: scheme.tertiary,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'WELCOME BACK,\n',
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontSize: constraints.maxWidth >= 900 ? 72 : 50,
                              fontWeight: FontWeight.w900,
                              height: 0.95,
                            ),
                          ),
                          TextSpan(
                            text: 'OPERATOR 041',
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontSize: constraints.maxWidth >= 900 ? 72 : 50,
                              fontWeight: FontWeight.w900,
                              height: 0.95,
                              color: scheme.primaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Wrap(
                      spacing: 32,
                      runSpacing: 20,
                      children: _heroMetrics
                          .map((metric) => _buildHeroMetric(theme, metric))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            if (stacked) const SizedBox(height: 28),
            Expanded(
              flex: stacked ? 0 : 4,
              child: _buildMemberCard(theme: theme, user: user),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeroMetric(ThemeData theme, _HeroMetric metric) {
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          metric.label.toUpperCase(),
          style: theme.textTheme.labelMedium?.copyWith(
            color: scheme.outlineVariant,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 6),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: metric.value,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (metric.trailing != null)
                TextSpan(
                  text: ' ${metric.trailing}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.outlineVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMemberCard({required ThemeData theme, User? user}) {
    final scheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            scheme.primary,
            scheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: scheme.primaryContainer.withOpacity(0.24),
            blurRadius: 36,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: scheme.outlineVariant.withOpacity(0.12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: scheme.primary.withOpacity(0.20),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      _memberImageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'VIP TIER',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'EXP 12/25',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: scheme.outlineVariant,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.6,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 36),
              _detailBlock(
                theme,
                label: 'Member Name',
                value: user?.userMetadata != null && user?.userMetadata?['full_name'] != null ? user?.userMetadata!['full_name'] : 'UNKNOWN',
                useHeadline: true,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _detailBlock(
                      theme,
                      label: 'Assigned ID',
                      value: 'ST-88902-X',
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _detailBlock(
                      theme,
                      label: 'Classification',
                      value: 'MARKSMAN L2',
                      alignEnd: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailBlock(
    ThemeData theme, {
    required String label,
    required String value,
    bool alignEnd = false,
    bool useHeadline = false,
  }) {
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelMedium?.copyWith(
            color: scheme.outlineVariant,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.6,
          ),
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: useHeadline
              ? theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                )
              : theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                  letterSpacing: 0.8,
                ),
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        ),
      ],
    );
  }

  Widget _buildDashboard(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 1100;

        return Flex(
          direction: stacked ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: stacked ? 0 : 4,
              child: Column(
                children: [
                  _buildSafetyProtocolsCard(theme),
                  const SizedBox(height: 24),
                  _buildQuickStatsCard(theme),
                ],
              ),
            ),
            SizedBox(width: stacked ? 0 : 24, height: stacked ? 24 : 0),
            Expanded(
              flex: stacked ? 0 : 8,
              child: Column(
                children: [
                  _buildUpcomingSessionCard(theme),
                  const SizedBox(height: 24),
                  _buildTrainingHistoryCard(theme),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSafetyProtocolsCard(ThemeData theme) {
    final scheme = theme.colorScheme;

    return _panel(
      theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.gavel_rounded,
                color: scheme.primary,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'SAFETY PROTOCOLS',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          for (final item in _protocols) ...[
            _buildProtocolTile(theme, item),
            if (item != _protocols.last) const SizedBox(height: 12),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              child: Text(
                'REVIEW FULL PROTOCOL',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurface,
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

  Widget _buildProtocolTile(ThemeData theme, _ProtocolItem item) {
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: scheme.tertiary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: scheme.tertiary,
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.check_rounded,
              color: scheme.tertiary,
              size: 14,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title.toUpperCase(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsCard(ThemeData theme) {
    return _panel(
      theme,
      child: Row(
        children: [
          Expanded(
            child: _statTile(
              theme,
              label: 'LAST SCORE',
              value: '94.2',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _statTile(
              theme,
              label: 'RANK',
              value: '#12',
            ),
          ),
        ],
      ),
    );
  }

  Widget _statTile(
    ThemeData theme, {
    required String label,
    required String value,
  }) {
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.outlineVariant,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingSessionCard(ThemeData theme) {
    final scheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: scheme.outlineVariant.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(28),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final stacked = constraints.maxWidth < 760;

                return Flex(
                  direction: stacked ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: stacked
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.primaryContainer.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'UPCOMING SESSION',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: scheme.primaryContainer,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'TACTICAL CARBINE DRILLS',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontSize: 38,
                              fontWeight: FontWeight.w800,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 20,
                            runSpacing: 10,
                            children: [
                              _metaItem(
                                theme,
                                icon: Icons.calendar_today_rounded,
                                label: 'Oct 24, 2024',
                              ),
                              _metaItem(
                                theme,
                                icon: Icons.schedule_rounded,
                                label: '14:00 - 15:30',
                              ),
                              _metaItem(
                                theme,
                                icon: Icons.location_on_rounded,
                                label: 'LANE 08',
                                highlighted: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: stacked ? 0 : 24,
                      height: stacked ? 24 : 0,
                    ),
                    Container(
                      width: stacked ? double.infinity : 190,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest.withOpacity(0.32),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'COUNTDOWN',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: scheme.outlineVariant,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '18:42:05',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'HRS : MIN : SEC',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: scheme.onSurfaceVariant.withOpacity(0.65),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.75,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        scheme.primary,
                        scheme.primaryContainer,
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaItem(
    ThemeData theme, {
    required IconData icon,
    required String label,
    bool highlighted = false,
  }) {
    final scheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color:
              highlighted ? scheme.primaryContainer : scheme.onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color:
                highlighted ? scheme.primaryContainer : scheme.onSurfaceVariant,
            fontWeight: highlighted ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingHistoryCard(ThemeData theme) {
    final scheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: scheme.outlineVariant.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(28),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'TRAINING HISTORY',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Wrap(
                  spacing: 12,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'VIEW ALL',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'FILTER',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final tableWidth =
                  constraints.maxWidth < 820 ? 820.0 : constraints.maxWidth;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Column(
                    children: [
                      Container(
                        color: scheme.surfaceContainerHighest.withOpacity(0.20),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 18,
                        ),
                        child: Row(
                          children: [
                            _tableHeader(theme, 'Date', flex: 2),
                            _tableHeader(theme, 'Session Type', flex: 3),
                            _tableHeader(theme, 'Status', flex: 2),
                            _tableHeader(theme, 'Duration', flex: 1),
                            _tableHeader(theme, 'Review',
                                flex: 1, alignEnd: true),
                          ],
                        ),
                      ),
                      for (final row in _historyRows)
                        _buildHistoryRow(theme, row),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _tableHeader(
    ThemeData theme,
    String label, {
    required int flex,
    bool alignEnd = false,
  }) {
    final scheme = theme.colorScheme;

    return Expanded(
      flex: flex,
      child: Text(
        label.toUpperCase(),
        textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        style: theme.textTheme.labelMedium?.copyWith(
          color: scheme.outlineVariant,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.6,
        ),
      ),
    );
  }

  Widget _buildHistoryRow(ThemeData theme, _TrainingHistoryRow row) {
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: scheme.outlineVariant.withOpacity(0.10),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              row.date,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              row.sessionType.toUpperCase(),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _statusChip(theme, row),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              row.duration,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.download_rounded,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusChip(ThemeData theme, _TrainingHistoryRow row) {
    final scheme = theme.colorScheme;
    final background = row.archived
        ? scheme.surfaceContainerHighest
        : scheme.tertiary.withOpacity(0.12);
    final foreground = row.archived ? scheme.onSurfaceVariant : scheme.tertiary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        row.status.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildFooter(ThemeData theme) {
    final scheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      color: scheme.surfaceContainerLow,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              _horizontalPadding(context),
              56,
              _horizontalPadding(context),
              32,
            ),
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 980 ? 4 : 2;
                    final twoRows = constraints.maxWidth < 720;

                    if (twoRows) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _footerBrand(theme),
                          const SizedBox(height: 28),
                          _footerLinkGroup(
                            theme,
                            title: 'OPERATIONS',
                            items: _operationsLinks,
                          ),
                          const SizedBox(height: 28),
                          _footerLinkGroup(
                            theme,
                            title: 'SUPPORT',
                            items: _supportLinks,
                          ),
                          const SizedBox(height: 28),
                          _footerSecurity(theme),
                        ],
                      );
                    }

                    return GridView.count(
                      crossAxisCount: columns,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: columns == 4 ? 1.5 : 2.3,
                      children: [
                        _footerBrand(theme),
                        _footerLinkGroup(
                          theme,
                          title: 'OPERATIONS',
                          items: _operationsLinks,
                        ),
                        _footerLinkGroup(
                          theme,
                          title: 'SUPPORT',
                          items: _supportLinks,
                        ),
                        _footerSecurity(theme),
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
                        color: scheme.surfaceContainerHighest.withOpacity(0.30),
                      ),
                    ),
                  ),
                  child: Text(
                    '© 2024 SENTINEL PRECISION RANGE. ALL RIGHTS RESERVED.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _footerBrand(ThemeData theme) {
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SENTINEL PRECISION',
          style: theme.textTheme.titleLarge?.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 280),
          child: Text(
            'Elite firearms training and tactical facility for professional operators and civilian enthusiasts.',
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              height: 1.8,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _footerLinkGroup(
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
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: 18),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              item.toUpperCase(),
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
      ],
    );
  }

  Widget _footerSecurity(ThemeData theme) {
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SECURE FEED',
          style: theme.textTheme.labelMedium?.copyWith(
            color: scheme.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            _footerIcon(theme, Icons.rss_feed_rounded),
            const SizedBox(width: 12),
            _footerIcon(theme, Icons.lock_outline_rounded),
            const SizedBox(width: 12),
            _footerIcon(theme, Icons.shield_outlined),
          ],
        ),
      ],
    );
  }

  Widget _footerIcon(ThemeData theme, IconData icon) {
    final scheme = theme.colorScheme;

    return Icon(
      icon,
      color: scheme.onSurfaceVariant,
      size: 22,
    );
  }

  Widget _panel(ThemeData theme, {required Widget child}) {
    final scheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: scheme.outlineVariant.withOpacity(0.08),
        ),
      ),
      child: child,
    );
  }

  double _horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1400) return 48;
    if (width >= 1024) return 32;
    return 20;
  }
}

class _HeroMetric {
  const _HeroMetric({
    required this.label,
    required this.value,
    this.trailing,
  });

  final String label;
  final String value;
  final String? trailing;
}

class _ProtocolItem {
  const _ProtocolItem({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

class _TrainingHistoryRow {
  const _TrainingHistoryRow({
    required this.date,
    required this.sessionType,
    required this.status,
    required this.duration,
    required this.archived,
  });

  final String date;
  final String sessionType;
  final String status;
  final String duration;
  final bool archived;
}
