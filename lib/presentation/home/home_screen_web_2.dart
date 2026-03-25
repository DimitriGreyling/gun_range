import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gun_range_app/data/models/v2/widget_models.dart';
import 'package:gun_range_app/presentation/widgets/v2/category_card_widget.dart';
import 'package:gun_range_app/presentation/widgets/v2/event_card_widget.dart';
import 'package:gun_range_app/presentation/widgets/v2/footer_widget.dart';
import 'package:gun_range_app/presentation/widgets/v2/gradient_button.dart';
import 'package:gun_range_app/presentation/widgets/v2/search_field_widget.dart';
import 'package:gun_range_app/presentation/widgets/v2/tier_card_widget.dart';
import 'package:gun_range_app/presentation/widgets/v2/top_bar_widget.dart';

class HomeScreenWeb2 extends ConsumerStatefulWidget {
  const HomeScreenWeb2({super.key});

  @override
  ConsumerState<HomeScreenWeb2> createState() => _HomeScreenWeb2State();
}

class _HomeScreenWeb2State extends ConsumerState<HomeScreenWeb2> {
  final List<CategoryItem> _categories = const [
    CategoryItem(
      title: 'Indoor Ranges',
      subtitle: '240+ Facilities',
      imageUrl: 'assets/indoor_range_2.png',
    ),
    CategoryItem(
      title: 'Outdoor Long Range',
      subtitle: '115+ Facilities',
      imageUrl: 'assets/outdoor_range_2.png',
    ),
    // CategoryItem(
    //   title: 'Dynamic Shoot Houses',
    //   subtitle: '38 Facilities',
    //   tint: Color(0x33FFB59C),
    // ),
    // CategoryItem(
    //   title: 'Tactical Training Centers',
    //   subtitle: '86 Facilities',
    //   tint: Color(0x33A0D663),
    // ),
  ];

  final List<EventItem> _events = const [
    EventItem(
      tag: 'Competition',
      title: 'Regional Multi-Gun Challenge',
      date: 'Oct 24, 2024',
      description:
          'Annual 3-gun competition featuring professional stages and exclusive hardware prizes.',
      tagColorSeed: Colors.orange,
    ),
    EventItem(
      tag: 'Clinic',
      title: 'Night Vision Fundamentals',
      date: 'Nov 02, 2024',
      description:
          'Intensive seminar focusing on active IR employment and movement under NODs.',
      tagColorSeed: Colors.green,
    ),
    EventItem(
      tag: 'Seminar',
      title: 'Long-Range Ballistics Masterclass',
      date: 'Dec 15, 2024',
      description:
          'Advanced course on environmentals, spin drift, and cold-bore precision at 1000m+.',
      tagColorSeed: Colors.deepOrange,
    ),
  ];

  final List<BenefitItem> _benefits = const [
    BenefitItem(
      icon: Icons.location_on_outlined,
      title: '500+ Verified Ranges',
      description:
          'The largest curated network of shooting facilities across the nation, all vetted for quality and professional service.',
    ),
    BenefitItem(
      icon: Icons.shield_outlined,
      title: 'Verified Safety',
      description:
          'Every range in our network adheres to strict safety audits and certified Range Safety Officer protocols.',
    ),
    BenefitItem(
      icon: Icons.workspace_premium_outlined,
      title: 'Exclusive Event Access',
      description:
          'Members gain early access to high-demand tactical clinics and national-level shooting competitions.',
    ),
  ];

  final List<TierItem> _tiers = const [
    TierItem(
      label: 'Base Level',
      name: 'Standard',
      price: '\$29',
      cta: 'Select Tier',
      features: [
        'Verified Booking Profile',
        'Community Forum Access',
        '5% Off Network Ammo',
      ],
    ),
    TierItem(
      label: 'Professional',
      name: 'Elite',
      price: '\$89',
      cta: 'Get Elite Access',
      highlighted: true,
      badge: 'Recommended',
      features: [
        '0% Platform Booking Fees',
        'Priority Event Registration',
        '15% Off Gear Partners',
        '1 Free Pro Clinic / Year',
      ],
    ),
    TierItem(
      label: 'Executive',
      name: 'Platinum',
      price: '\$199',
      cta: 'Select Tier',
      features: [
        'Concierge Support',
        'Private Event Invitations',
        'National Reciprocity Perks',
        'Unlimited Guest Passes',
      ],
    ),
  ];

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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TopBarWidget(),
            _buildHeroSection(theme, horizontalPadding),
            _buildCategoriesSection(theme, horizontalPadding),
            _buildEventsSection(theme, horizontalPadding),
            _buildBenefitsSection(theme, horizontalPadding),
            _buildMembershipSection(theme, horizontalPadding),
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(ThemeData theme, double horizontalPadding) {
    final scheme = theme.colorScheme;
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    return Container(
      color: scheme.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 40,
            ),
            child: Container(
              constraints: const BoxConstraints(minHeight: 400),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(24),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            scheme.surface.withOpacity(0.55),
                            scheme.surface.withOpacity(0.80),
                            scheme.surface,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 56,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: scheme.primary.withOpacity(0.20),
                            ),
                          ),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 10,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: scheme.tertiary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Text(
                                'NETWORK STATUS: 542 FACILITIES ONLINE',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: scheme.primary,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: [
                              TextSpan(
                                text: 'DISCOVER & BOOK',
                                style: theme.textTheme.displayLarge?.copyWith(
                                  fontSize: isWide ? 86 : 56,
                                  height: 0.92,
                                  fontWeight: FontWeight.w800,
                                  color: scheme.onSurface,
                                ),
                              ),
                              TextSpan(
                                text: '\nELITE TACTICAL',
                                style: theme.textTheme.displayLarge?.copyWith(
                                  fontSize: isWide ? 86 : 56,
                                  height: 0.92,
                                  fontWeight: FontWeight.w800,
                                  color: scheme.primaryContainer,
                                ),
                              ),
                              TextSpan(
                                text: '\nEXPERIENCES.',
                                style: theme.textTheme.displayLarge?.copyWith(
                                  fontSize: isWide ? 86 : 56,
                                  height: 0.92,
                                  fontWeight: FontWeight.w800,
                                  color: scheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 36),
                        _buildSearchPanel(theme),
                        const SizedBox(height: 24),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 760),
                          child: Text(
                            'Book shooting ranges, tactical courses, and professional training experiences across South Africa.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: scheme.onSurfaceVariant,
                              height: 1.7,
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
        ),
      ),
    );
  }

  Widget _buildSearchPanel(ThemeData theme) {
    final scheme = theme.colorScheme;
    final isWide = MediaQuery.sizeOf(context).width >= 980;
    TextEditingController locationController = TextEditingController();

    final fields = [
      SearchField(
        label: 'LOCATION',
        child: TextField(
          controller: locationController,
          decoration: InputDecoration(
            hintText: 'Province or City',
            hintStyle: theme.textTheme.titleLarge?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
          ),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
        ),
      ),
      SearchField(
        label: 'ACTIVITY',
        child: DropdownButtonFormField<String>(
          value: 'Indoor Lane',
          items: const [
            DropdownMenuItem(value: 'Indoor Lane', child: Text('Indoor Lane')),
            DropdownMenuItem(
                value: 'Outdoor Range', child: Text('Outdoor Range')),
            DropdownMenuItem(
              value: 'Dynamic Training',
              child: Text('Dynamic Training'),
            ),
            DropdownMenuItem(value: 'Competition', child: Text('Competition')),
          ],
          onChanged: (_) {},
          decoration: const InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          dropdownColor: scheme.surfaceContainerHigh,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
          iconEnabledColor: scheme.primary,
        ),
      ),
      SearchField(
        label: 'DATE',
        child: TextField(
          decoration: const InputDecoration(
            hintText: 'Select Date',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
        ),
      ),
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1060),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHigh.withOpacity(0.82),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: scheme.outlineVariant.withOpacity(0.25),
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withOpacity(0.35),
                blurRadius: 32,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: isWide
              ? Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: fields[0]),
                          _ghostDivider(theme),
                          Expanded(child: fields[1]),
                          _ghostDivider(theme),
                          Expanded(child: fields[2]),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    GradientButton(
                      label: 'SEARCH',
                      icon: Icons.search,
                      large: true,
                      onPressed: () {
                        context.goNamed('ranges', queryParameters: {
                          'location': locationController.text,
                        },);
                      },
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    fields[0],
                    _softSpacer(theme),
                    fields[1],
                    _softSpacer(theme),
                    fields[2],
                    const SizedBox(height: 12),
                    GradientButton(
                      label: 'SEARCH',
                      icon: Icons.search,
                      large: true,
                      onPressed: () {
                        context.goNamed('ranges', queryParameters: {
                          'location': locationController.text,
                        });
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(ThemeData theme, double horizontalPadding) {
    return _sectionShell(
      theme: theme,
      horizontalPadding: horizontalPadding,
      background: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            theme,
            eyebrow: 'NAVIGATION HUB',
            title: 'Browse Categories',
            trailing: TextButton(
              onPressed: () {},
              child: Text(
                'VIEW ALL CATEGORIES',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1200
                  ? 4
                  : constraints.maxWidth >= 800
                      ? 2
                      : 1;

              return GridView.builder(
                itemCount: _categories.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1.05,
                ),
                itemBuilder: (context, index) {
                  final item = _categories[index];
                  return CategoryCard(item: item);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEventsSection(ThemeData theme, double horizontalPadding) {
    return _sectionShell(
      theme: theme,
      horizontalPadding: horizontalPadding,
      background: theme.colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            theme,
            eyebrow: 'FEATURED EXPERIENCE',
            title: 'Upcoming Events',
          ),
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1100
                  ? 3
                  : constraints.maxWidth >= 720
                      ? 2
                      : 1;

              return GridView.builder(
                itemCount: _events.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  return EventCard(item: _events[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsSection(ThemeData theme, double horizontalPadding) {
    final scheme = theme.colorScheme;

    return _sectionShell(
      theme: theme,
      horizontalPadding: horizontalPadding,
      background: scheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 20,
            spacing: 20,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'THE SENTINEL ADVANTAGE',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Why Book With Us',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 52,
                        fontWeight: FontWeight.w800,
                        color: scheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Text(
                  'We partner with the world\'s most sophisticated training centers to provide a seamless, secure, and professional booking experience for the dedicated enthusiast.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.7,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1100
                  ? 3
                  : constraints.maxWidth >= 720
                      ? 2
                      : 1;

              return GridView.builder(
                itemCount: _benefits.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final item = _benefits[index];
                  return Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border(
                        top: BorderSide(
                          color: scheme.primary.withOpacity(0.25),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(item.icon, color: scheme.primary, size: 36),
                        const SizedBox(height: 20),
                        Text(
                          item.title.toUpperCase(),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipSection(ThemeData theme, double horizontalPadding) {
    final scheme = theme.colorScheme;

    return _sectionShell(
      theme: theme,
      horizontalPadding: horizontalPadding,
      background: scheme.surfaceContainerLowest,
      child: Column(
        children: [
          Text(
            'Join the Community',
            textAlign: TextAlign.center,
            style: theme.textTheme.displayLarge?.copyWith(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'ELEVATE YOUR ACCESS WITH OUR PLATFORM-WIDE MEMBERSHIP TIERS.',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1100
                  ? 3
                  : constraints.maxWidth >= 720
                      ? 2
                      : 1;

              return GridView.builder(
                itemCount: _tiers.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (context, index) {
                  final item = _tiers[index];
                  return TierCard(item: item);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionShell({
    required ThemeData theme,
    required double horizontalPadding,
    required Color background,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      color: background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 56,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(
    ThemeData theme, {
    required String eyebrow,
    required String title,
    Widget? trailing,
  }) {
    final scheme = theme.colorScheme;

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      runSpacing: 16,
      spacing: 16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eyebrow,
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.6,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.headlineLarge?.copyWith(
                fontSize: 52,
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _ghostDivider(ThemeData theme) {
    return Container(
      width: 1,
      height: 52,
      color: theme.colorScheme.outlineVariant.withOpacity(0.20),
    );
  }

  Widget _softSpacer(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 1,
      color: theme.colorScheme.outlineVariant.withOpacity(0.15),
    );
  }
}
