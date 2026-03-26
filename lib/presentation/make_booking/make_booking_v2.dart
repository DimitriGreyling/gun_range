import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/presentation/widgets/v2/footer_widget.dart';
import 'package:gun_range_app/presentation/widgets/v2/gradient_button.dart';
import 'package:gun_range_app/presentation/widgets/v2/top_bar_widget.dart';

class MakeBookingV2 extends ConsumerStatefulWidget {
  const MakeBookingV2({super.key});

  @override
  ConsumerState<MakeBookingV2> createState() => _MakeBookingV2State();
}

class _MakeBookingV2State extends ConsumerState<MakeBookingV2> {
  final List<_CategoryOption> _categories = const [
    _CategoryOption(
      title: 'Pistol',
      subtitle: '25YD PRECISION LANES',
      icon: Icons.gps_fixed,
    ),
    _CategoryOption(
      title: 'Rifle',
      subtitle: '100YD CALIBRATED LANES',
      icon: Icons.track_changes,
    ),
    _CategoryOption(
      title: 'Tactical',
      subtitle: 'DYNAMIC SHOOT HOUSES',
      icon: Icons.security,
    ),
  ];

  final List<_TimeSlot> _timeSlots = const [
    _TimeSlot(label: '09:00', status: _SlotStatus.available),
    _TimeSlot(label: '11:30', status: _SlotStatus.selected),
    _TimeSlot(label: '13:00', status: _SlotStatus.full),
    _TimeSlot(label: '15:30', status: _SlotStatus.available),
    _TimeSlot(label: '18:00', status: _SlotStatus.available),
    _TimeSlot(label: '20:30', status: _SlotStatus.available),
  ];

  int _selectedCategoryIndex = 1;
  int _selectedDay = 5;
  String _selectedMonthLabel = 'September 2024';
  String _selectedTime = '11:30';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

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
                    _buildMainContent(theme),
                    const FooterWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(ThemeData theme) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width >= 1400
        ? 48.0
        : width >= 1024
            ? 32.0
            : 20.0;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1600),
        child: Padding(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 40, horizontalPadding, 64),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final twoColumns = constraints.maxWidth >= 1100;

              return twoColumns
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 8,
                          child: _buildBookingColumn(theme),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          flex: 4,
                          child: _buildMissionBrief(theme),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBookingColumn(theme),
                        const SizedBox(height: 32),
                        _buildMissionBrief(theme),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBookingColumn(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHero(theme),
        const SizedBox(height: 40),
        _buildCategorySection(theme),
        const SizedBox(height: 40),
        _buildDateTimeSection(theme),
      ],
    );
  }

  Widget _buildHero(ThemeData theme) {
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STEP 01 / CONFIG',
          style: theme.textTheme.labelMedium?.copyWith(
            color: scheme.primary,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'SECURE YOUR PRECISION LANE',
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 44,
            fontWeight: FontWeight.w800,
            height: 1.0,
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Text(
            'Configure your tactical environment. Select from our calibrated lanes and premium training categories using the same Sentinel system styling already established in the site.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: scheme.onSurfaceVariant,
              height: 1.7,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(theme, '01. SELECT ARSENAL CATEGORY'),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 900
                ? 3
                : constraints.maxWidth >= 560
                    ? 2
                    : 1;

            return GridView.builder(
              itemCount: _categories.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.18,
              ),
              itemBuilder: (context, index) {
                final item = _categories[index];
                final selected = index == _selectedCategoryIndex;

                return _SelectionCard(
                  selected: selected,
                  icon: item.icon,
                  title: item.title,
                  subtitle: item.subtitle,
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildDateTimeSection(ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 860;

        return stacked
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCalendarPanel(theme),
                  const SizedBox(height: 32),
                  _buildTimePanel(theme),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCalendarPanel(theme)),
                  const SizedBox(width: 28),
                  Expanded(child: _buildTimePanel(theme)),
                ],
              );
      },
    );
  }

  Widget _buildCalendarPanel(ThemeData theme) {
    final scheme = theme.colorScheme;
    final days = <int?>[
      null,
      null,
      null,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(theme, '02. DEPLOYMENT DATE'),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: scheme.outlineVariant.withOpacity(0.22),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    _selectedMonthLabel.toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const Spacer(),
                  _CalendarChevron(icon: Icons.chevron_left, onTap: () {}),
                  const SizedBox(width: 8),
                  _CalendarChevron(icon: Icons.chevron_right, onTap: () {}),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  _WeekDayLabel('M'),
                  _WeekDayLabel('T'),
                  _WeekDayLabel('W'),
                  _WeekDayLabel('T'),
                  _WeekDayLabel('F'),
                  _WeekDayLabel('S'),
                  _WeekDayLabel('S'),
                ],
              ),
              const SizedBox(height: 12),
              GridView.builder(
                itemCount: days.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.15,
                ),
                itemBuilder: (context, index) {
                  final day = days[index];
                  final disabled = day == null;
                  final selected = day == _selectedDay;

                  return InkWell(
                    onTap: disabled
                        ? null
                        : () {
                            setState(() {
                              _selectedDay = day;
                            });
                          },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected
                            ? scheme.primary
                            : disabled
                                ? Colors.transparent
                                : scheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                        border: !selected && !disabled
                            ? Border.all(
                                color: scheme.outlineVariant.withOpacity(0.15),
                              )
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        day == null ? '' : day.toString().padLeft(2, '0'),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: selected
                              ? scheme.onPrimary
                              : disabled
                                  ? scheme.onSurfaceVariant.withOpacity(0.28)
                                  : scheme.onSurface,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimePanel(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(theme, '03. OPERATIONAL TIME'),
        const SizedBox(height: 20),
        GridView.builder(
          itemCount: _timeSlots.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 2.3,
          ),
          itemBuilder: (context, index) {
            final slot = _timeSlots[index];
            final selected = slot.label == _selectedTime;
            final disabled = slot.status == _SlotStatus.full;

            return _TimeSlotCard(
              slot: slot,
              selected: selected,
              disabled: disabled,
              onTap: disabled
                  ? null
                  : () {
                      setState(() {
                        _selectedTime = slot.label;
                      });
                    },
            );
          },
        ),
      ],
    );
  }

  Widget _buildMissionBrief(ThemeData theme) {
    final scheme = theme.colorScheme;
    final selectedCategory = _categories[_selectedCategoryIndex];

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: scheme.outlineVariant.withOpacity(0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.35),
            blurRadius: 32,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 4,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
              gradient: LinearGradient(
                colors: [
                  scheme.primary,
                  scheme.primaryContainer,
                  scheme.primary,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'MISSION BRIEF',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.verified_user_outlined,
                      color: scheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                _BriefItem(
                  icon: Icons.track_changes,
                  eyebrow: 'ASSET CLASS',
                  title: '${selectedCategory.title.toUpperCase()} LANE',
                  detail: 'Range Echo / Calibrated Station',
                ),
                const SizedBox(height: 20),
                _BriefItem(
                  icon: Icons.schedule,
                  eyebrow: 'OPERATIONAL WINDOW',
                  title: 'SEPT ${_selectedDay.toString().padLeft(2, '0')} @ $_selectedTime',
                  detail: 'Duration: 90 Minute Session',
                ),
                const SizedBox(height: 20),
                const _BriefItem(
                  icon: Icons.person_outline,
                  eyebrow: 'PERSONNEL',
                  title: '1 OPERATOR',
                  detail: 'Safety briefing required',
                ),
                const SizedBox(height: 28),
                Container(
                  height: 1,
                  color: scheme.outlineVariant.withOpacity(0.22),
                ),
                const SizedBox(height: 20),
                _CostRow(label: 'Lane Rental', value: '\$45.00'),
                const SizedBox(height: 12),
                _CostRow(label: 'Range Supervision', value: '\$15.00'),
                const SizedBox(height: 18),
                Container(
                  height: 1,
                  color: scheme.outlineVariant.withOpacity(0.22),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Text(
                      'TOTAL DUES',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$60.00',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: GradientButton(
                    label: 'CONFIRM DEPLOYMENT',
                    onPressed: () {},
                    large: true,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'SUBJECT TO SENTINEL RANGE SAFETY PROTOCOLS',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant.withOpacity(0.72),
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(ThemeData theme, String label) {
    return Text(
      label,
      style: theme.textTheme.labelMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.6,
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  const _SelectionCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected ? scheme.surfaceContainer : scheme.surfaceContainerLow,
          border: Border.all(
            color: selected
                ? scheme.primary
                : scheme.outlineVariant.withOpacity(0.14),
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: scheme.shadow.withOpacity(0.26),
                    blurRadius: 26,
                    offset: const Offset(0, 16),
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: selected
                        ? scheme.primary
                        : scheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    selected ? Icons.check : icon,
                    color: selected ? scheme.onPrimary : scheme.primary,
                    size: 18,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                icon,
                color: scheme.primary.withOpacity(0.9),
                size: 34,
              ),
              const SizedBox(height: 18),
              Text(
                title.toUpperCase(),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: selected ? scheme.primary : scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeSlotCard extends StatelessWidget {
  const _TimeSlotCard({
    required this.slot,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  final _TimeSlot slot;
  final bool selected;
  final bool disabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final Color accent = switch (slot.status) {
      _SlotStatus.available => scheme.tertiary,
      _SlotStatus.selected => scheme.primary,
      _SlotStatus.full => scheme.error,
    };

    final String statusLabel = switch (slot.status) {
      _SlotStatus.available => 'AVAILABLE',
      _SlotStatus.selected => 'SELECTED',
      _SlotStatus.full => 'FULL',
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        decoration: BoxDecoration(
          color: selected ? scheme.surfaceContainer : scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? scheme.primary
                : scheme.outlineVariant.withOpacity(0.16),
          ),
        ),
        child: Opacity(
          opacity: disabled ? 0.45 : 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Text(
                  slot.label,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: selected ? scheme.primary : scheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Text(
                  statusLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: accent,
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
}

class _BriefItem extends StatelessWidget {
  const _BriefItem({
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String eyebrow;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: scheme.primary, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                detail,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CostRow extends StatelessWidget {
  const _CostRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelMedium,
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.labelMedium,
        ),
      ],
    );
  }
}

class _CalendarChevron extends StatelessWidget {
  const _CalendarChevron({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: scheme.primary),
      ),
    );
  }
}

class _WeekDayLabel extends StatelessWidget {
  const _WeekDayLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Center(
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

class _CategoryOption {
  const _CategoryOption({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}

class _TimeSlot {
  const _TimeSlot({
    required this.label,
    required this.status,
  });

  final String label;
  final _SlotStatus status;
}

enum _SlotStatus {
  available,
  selected,
  full,
}