import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/presentation/widgets/v2/footer_widget.dart';
import 'package:gun_range_app/presentation/widgets/v2/gradient_button.dart';
import 'package:gun_range_app/presentation/widgets/v2/search_field_widget.dart';
import 'package:gun_range_app/presentation/widgets/v2/top_bar_widget.dart';

class RangesScreenV2 extends ConsumerStatefulWidget {
  const RangesScreenV2({super.key});

  @override
  ConsumerState<RangesScreenV2> createState() => _RangesScreenV2State();
}

class _RangesScreenV2State extends ConsumerState<RangesScreenV2> {
  final List<_Facility> _facilities = const [
    _Facility(
      name: 'Blackwood Precision',
      distance: '12.4 MI',
      description:
          'High-end outdoor ballistic testing facility featuring dynamic steel targets and a dedicated long-range precision deck.',
      rating: '4.9 (210)',
      statusLabel: 'LANES AVAILABLE',
      statusColorKind: _StatusColorKind.available,
      tags: ['1000YD LANE', 'UP TO .50 BMG'],
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC8_1LTguaWPH8ZL3Kx-KOOrzyuYpU4HOKAHZz6gy-zq1yVPV4AiCnrQ4noUHxOBEA-SKG15wTPFe3g-2SF7pzAaaj4aXCrF9tANbihNzx44JP3JOTZP7wozBTr0_z-2llkVhppuDAlMs-uGSBTjsz76TTKkveM42SnRaUk3NOJdW56ErlOF9fkPBH82YbYj_LI3x2DqGUmG8SRr19sR0ugT8kC87yGt63gX1xItZFfCr1wGCyaFpCSM2rpfCH1olY5vVibmIbcMaje',
    ),
    _Facility(
      name: 'The Foundry Urban',
      distance: '4.2 MI',
      description:
          'Modular indoor shoot-house environments designed for civilian tactical training and professional close-quarters drills.',
      rating: '4.7 (154)',
      statusLabel: 'FULLY OCCUPIED',
      statusColorKind: _StatusColorKind.full,
      tags: ['DYNAMIC ROOMS', 'CQB SPECIALIST'],
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDhYMKPepOQ7y5aUKDOb8VAnjDATFtuRITb5WZFGJ47e_7cPwjVGXwxZT9EWKkwNTvcdjTHoUY03IpGpsI3lkm1qBjh6yrlrrCwfOJZHM2MBjLeJEdGZmyov7gR0sM-yb5mhANbt-t0mgsLQwSExw7VhZ03PEEMBcBhI8oNH4FAlAUax42XJzHxfnZn3CS9W37JmdkhnvyjjjFmTPFi55zSFZnKWGnV2RkPeTVoqblOIAN52asezz2_OC9Lp0Gr8YMG032oot7gtrI_',
    ),
    _Facility(
      name: 'Apex Ballistics',
      distance: '45.8 MI',
      description:
          'Premier destination for extreme long-range shooting with integrated wind-call analytics and spotter assistance.',
      rating: '5.0 (89)',
      statusLabel: 'LANES AVAILABLE',
      statusColorKind: _StatusColorKind.available,
      tags: ['ELR (2 MILE)', 'VIP LODGING'],
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAo43KEALNcjAMi7CEI3c0ZqIK7D99yz2fNQyKEeM6IrErQXetL3B0Bq-q2GSEN2zL0v5FczaMbmRThVWLhQX8VpsyIXkpUNYxHFY5ZJbDD1PFS-Lfy4_g8esdx-r9hAfbdfqW0ye0_0CQvtf-zW9bTvNbAgPENwO7t_Zjxtd5XHtlJmDZ9a3ERarXXNfdyji-gaQP5h6hPi4NadvFSeyUQvzw4YTncSJLoem1ThKawlL1WN7398w-GQFHcWMN0O52v8CnlNYZJtwhP',
    ),
  ];

  String _proximity = 'Nearby (25mi)';
  String _depth = 'Pistol (25yd)';
  String _caliber = 'Up to .45 ACP';
  bool _gridSelected = true;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Column(
        children: [
          const TopBarWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHero(context),
                  _buildFacilitiesSection(context),
                  _buildMapSection(context),
                  const FooterWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width >= 1400
        ? 48.0
        : width >= 1024
            ? 32.0
            : 20.0;

    return SizedBox(
      height: width >= 900 ? 520 : 640,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuD7hVa_VsXdo_HCaSgGx_-WXK1XWOaEgC-TFoJlsNe9YEyjhIvp9XtaRsaCPrWVfj1vq3uhrmSNt_XutX8haQGL-s4y6148gsuiDdG-V38OBz5pZ0V6YNB6X8flgx4knBsXqW_0OIWgiCIJc0znhkcO6i7Ehdf8B5Ll4CfYWJQXu7DPL321YsjeACkAmw-PG-K3EbmFN9OE1rVe1Ei0qCHRHILM9nPNCMhZpH3kMx_LMZ8g-NOfEovDY9xbCgNfkVTK0S7UJOOUpvR8',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.45),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    scheme.surface.withOpacity(0.82),
                    Colors.transparent,
                    scheme.surface,
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1600),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  48,
                  horizontalPadding,
                  48,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 820),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RANGE DISCOVERY',
                            style: theme.textTheme.displayLarge?.copyWith(
                              fontSize: width >= 1100 ? 64 : 46,
                              fontWeight: FontWeight.w800,
                              height: 0.95,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Locate elite ballistic facilities engineered for high-precision training and tactical proficiency.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: scheme.onSurfaceVariant,
                              height: 1.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildFilterPanel(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 1120),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: scheme.surfaceBright.withOpacity(0.62),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.06),
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withOpacity(0.35),
                blurRadius: 24,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 920;

              if (compact) {
                return Column(
                  children: [
                    _buildFilterField(
                      context,
                      label: 'PROXIMITY',
                      value: _proximity,
                      items: const [
                        'Nearby (25mi)',
                        'Regional (100mi)',
                        'Global Search',
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _proximity = value);
                      },
                      icon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 12),
                    _buildFilterField(
                      context,
                      label: 'RANGE DEPTH',
                      value: _depth,
                      items: const [
                        'Pistol (25yd)',
                        'Rifle (100yd+)',
                        'Long Range (1000yd+)',
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _depth = value);
                      },
                      icon: Icons.straighten,
                    ),
                    const SizedBox(height: 12),
                    _buildFilterField(
                      context,
                      label: 'MAX CALIBER',
                      value: _caliber,
                      items: const [
                        'Up to .45 ACP',
                        'Up to .308 WIN',
                        'Heavy (.50 BMG)',
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _caliber = value);
                      },
                      icon: Icons.gps_fixed,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: GradientButton(
                        label: 'DEPLOY SEARCH',
                        onPressed: () {},
                        icon: Icons.search,
                        large: true,
                      ),
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: _buildFilterField(
                      context,
                      label: 'PROXIMITY',
                      value: _proximity,
                      items: const [
                        'Nearby (25mi)',
                        'Regional (100mi)',
                        'Global Search',
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _proximity = value);
                      },
                      icon: Icons.location_on_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFilterField(
                      context,
                      label: 'RANGE DEPTH',
                      value: _depth,
                      items: const [
                        'Pistol (25yd)',
                        'Rifle (100yd+)',
                        'Long Range (1000yd+)',
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _depth = value);
                      },
                      icon: Icons.straighten,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildFilterField(
                      context,
                      label: 'MAX CALIBER',
                      value: _caliber,
                      items: const [
                        'Up to .45 ACP',
                        'Up to .308 WIN',
                        'Heavy (.50 BMG)',
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _caliber = value);
                      },
                      icon: Icons.gps_fixed,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 72,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: double.infinity,
                          child: GradientButton(
                            label: 'DEPLOY SEARCH',
                            onPressed: () {},
                            icon: Icons.search,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterField(
    BuildContext context, {
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SearchField(
      label: label,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: scheme.primary, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  isExpanded: true,
                  dropdownColor: scheme.surfaceContainerHigh,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                  items: items
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilitiesSection(BuildContext context) {
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
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              64,
              horizontalPadding,
              80,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final stacked = constraints.maxWidth < 760;

                    if (stacked) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFacilitiesHeader(theme),
                          const SizedBox(height: 18),
                          _buildViewToggle(theme),
                        ],
                      );
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(child: _buildFacilitiesHeader(theme)),
                        const SizedBox(width: 20),
                        _buildViewToggle(theme),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 28),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 1200
                        ? 3
                        : constraints.maxWidth >= 760
                            ? 2
                            : 1;

                    return GridView.builder(
                      itemCount: _facilities.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: columns == 1 ? 1.05 : 0.78,
                      ),
                      itemBuilder: (context, index) {
                        return _FacilityCard(facility: _facilities[index]);
                      },
                    );
                  },
                ),
                const SizedBox(height: 28),
                Center(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: scheme.surfaceContainerHighest,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 18,
                      ),
                    ),
                    child: Text(
                      'LOAD MORE OPERATIONAL ZONES',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.8,
                      ),
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

  Widget _buildFacilitiesHeader(ThemeData theme) {
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: scheme.primaryContainer,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VERIFIED TACTICAL FACILITIES',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '24 OPERATIONAL NODES FOUND',
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle(ThemeData theme) {
    final scheme = theme.colorScheme;

    return Row(
      children: [
        _ToggleButton(
          selected: _gridSelected,
          icon: Icons.grid_view_rounded,
          onTap: () {
            setState(() => _gridSelected = true);
          },
        ),
        const SizedBox(width: 8),
        _ToggleButton(
          selected: !_gridSelected,
          icon: Icons.map_outlined,
          onTap: () {
            setState(() => _gridSelected = false);
          },
        ),
      ],
    );
  }

  Widget _buildMapSection(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
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
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            64,
            horizontalPadding,
            72,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 1080;

              final mapPreview = _buildMapPreview(theme);
              final copyBlock = _buildMapCopy(theme);

              return stacked
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        mapPreview,
                        const SizedBox(height: 32),
                        copyBlock,
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: mapPreview),
                        const SizedBox(width: 40),
                        Expanded(child: copyBlock),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMapPreview(ThemeData theme) {
    final scheme = theme.colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -24,
          left: -24,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.primaryContainer.withOpacity(0.16),
              boxShadow: [
                BoxShadow(
                  color: scheme.primaryContainer.withOpacity(0.20),
                  blurRadius: 80,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuB_S2LKz7ljM73QeV-MVbd427q0YF-6h75ZJTI4duymCHqxqmZQejpsJ_UAm3J80tVESPNajSLQ_2toOk6IBzKf7rYtpWv73AmH3B7z2_fRCLB2cCZuhoAt9cD63X8wiNgtvOV-jHuBqbvOrPqnvp1hDLRWvwlxn0pu-NYgViH_RR_FZb_11t_0lp8ifYRB8hWdpq8j9dxm-9ZHD0HnC_WMzuH05hlL5NwAOnAuwqDQg-gcnSOnPhc63Tyh9eRza4jd5jbfnULhlfUb',
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.20),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer.withOpacity(0.06),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapCopy(ThemeData theme) {
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 4,
          color: scheme.primaryContainer,
        ),
        const SizedBox(height: 20),
        Text(
          'VISUAL INTELLIGENCE\nOPERATIONAL MAP VIEW',
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 44,
            fontWeight: FontWeight.w800,
            height: 0.95,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Experience a new way to scout. The mapping layer can surface climate conditions, elevation context, and current lane occupancy without breaking your current design language.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: scheme.onSurfaceVariant,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 24),
        const _MapFeatureRow(
          icon: Icons.cloud_outlined,
          title: 'REAL-TIME ATMOSPHERIC DATA',
          description: 'Check DA and wind speeds at range location.',
        ),
        const SizedBox(height: 16),
        const _MapFeatureRow(
          icon: Icons.history,
          title: 'HISTORICAL LANE AVAILABILITY',
          description: 'Predict peak hours using 30-day usage metrics.',
        ),
        const SizedBox(height: 26),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            backgroundColor: scheme.surfaceContainerHighest,
          ),
          child: Text(
            'LAUNCH INTERACTIVE MAP',
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurface,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _FacilityCard extends StatelessWidget {
  const _FacilityCard({
    required this.facility,
  });

  final _Facility facility;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final statusColor = switch (facility.statusColorKind) {
      _StatusColorKind.available => scheme.tertiary,
      _StatusColorKind.full => scheme.error,
    };

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    facility.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.08),
                          Colors.black.withOpacity(0.30),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.surface.withOpacity(0.82),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          color: scheme.tertiary,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          facility.rating,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _TagPill(
                        label: facility.tags.first,
                        background: scheme.primaryContainer.withOpacity(0.92),
                        foreground: scheme.onPrimary,
                      ),
                      if (facility.tags.length > 1)
                        _TagPill(
                          label: facility.tags[1],
                          background: scheme.surfaceBright.withOpacity(0.92),
                          foreground: scheme.onSurface,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          facility.name.toUpperCase(),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        facility.distance,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    facility.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.6,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.only(top: 18),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            facility.statusLabel,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          iconAlignment: IconAlignment.end,
                          onHover: (_) {},
                          icon: const Icon(Icons.arrow_forward, size: 16),
                          label: Text(
                            'VIEW DETAILS',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
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

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: selected
              ? scheme.surfaceContainerHigh
              : scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
          size: 20,
        ),
      ),
    );
  }
}

class _MapFeatureRow extends StatelessWidget {
  const _MapFeatureRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

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
            color: scheme.surfaceContainer,
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
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Facility {
  const _Facility({
    required this.name,
    required this.distance,
    required this.description,
    required this.rating,
    required this.statusLabel,
    required this.statusColorKind,
    required this.tags,
    required this.imageUrl,
  });

  final String name;
  final String distance;
  final String description;
  final String rating;
  final String statusLabel;
  final _StatusColorKind statusColorKind;
  final List<String> tags;
  final String imageUrl;
}

enum _StatusColorKind {
  available,
  full,
}