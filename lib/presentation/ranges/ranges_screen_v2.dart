import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gun_range_app/core/constants/general_constants.dart';
import 'package:gun_range_app/data/models/range.dart';
import 'package:gun_range_app/presentation/range_detail.dart';
import 'package:gun_range_app/presentation/tag_pill_widget.dart';
import 'package:gun_range_app/presentation/widgets/v2/footer_widget.dart';
import 'package:gun_range_app/presentation/widgets/v2/gradient_button.dart';
import 'package:gun_range_app/presentation/widgets/v2/search_field_widget.dart';
import 'package:gun_range_app/presentation/widgets/v2/top_bar_widget.dart';
import 'package:gun_range_app/providers/viewmodel_providers.dart';
import 'package:gun_range_app/viewmodels/lookup_vm.dart';
import 'package:intl/intl.dart';

class RangesScreenV2 extends ConsumerStatefulWidget {
  final DateTime? availableDate;
  final String? location;
  final String? activityId;

  const RangesScreenV2({
    super.key,
    this.location,
    this.activityId,
    this.availableDate,
  });

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

  final TextEditingController _locationController = TextEditingController();
  String? _selectedActivityValue;
  DateTime? _dateSelected;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(lookupViewModelProvider.notifier)
          .getLookupsByListValue(listValue: 'RANGE_TYPE');
      ref.read(rangeViewModelProvider.notifier).searchRanges(
            availableDate: _dateSelected,
            activityId: _selectedActivityValue,
            location: _locationController.text,
          );
    });

    _locationController.text = widget.location ?? '';
    _selectedActivityValue = widget.activityId;
    _dateSelected = widget.availableDate;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final rangeState = ref.watch(rangeViewModelProvider);

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Column(
        children: [
          const TopBarWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHero(context: context, isLoading: rangeState.isLoading),
                  _buildFacilitiesSection(context: context),
                  const FooterWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero({required BuildContext context, bool? isLoading = false}) {
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
                    // _buildFilterPanel(context),
                    _buildSearchPanel(theme: theme, isLoading: isLoading),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchPanel({
    required ThemeData theme,
    bool? isLoading = false,
  }) {
    final scheme = theme.colorScheme;
    final isWide = MediaQuery.sizeOf(context).width >= 980;

    return Consumer(
      builder: (context, ref, child) {
        final lookupState = ref.watch(lookupViewModelProvider);

        if (lookupState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final fields = [
          // SearchField(
          //   label: 'LOCATION',
          //   child: TextField(
          //     enabled: isLoading != true,
          //     controller: isLoading == true
          //         ? TextEditingController(text: 'SEARCHING...')
          //         : _locationController,
          //     decoration: InputDecoration(
          //       hintText:
          //           isLoading == true ? 'SEARCHING...' : 'Province or City',
          //       hintStyle: theme.textTheme.titleLarge?.copyWith(
          //         color: scheme.onSurfaceVariant,
          //       ),
          //       isDense: true,
          //       contentPadding: EdgeInsets.zero,
          //       border: InputBorder.none,
          //       enabledBorder: InputBorder.none,
          //       focusedBorder: InputBorder.none,
          //       filled: false,
          //     ),
          //     style: theme.textTheme.titleLarge?.copyWith(
          //       fontWeight: FontWeight.w700,
          //       color: isLoading == true
          //           ? scheme.onSurfaceVariant
          //           : scheme.onSurface,
          //     ),
          //   ),
          // ),
          SearchField(
            label: 'ACTIVITY',
            child: DropdownButtonFormField<String>(
              value: _selectedActivityValue,
              hint: Text(isLoading == true ? 'SEARCHING...' : 'ACTIVITY'),
              items:
                  lookupState.lookups != null && lookupState.lookups!.isNotEmpty
                      ? lookupState.lookups!.map((lookup) {
                          return DropdownMenuItem(
                              value: lookup.id,
                              child: Text(lookup.lookupDescription ?? ''));
                        }).toList()
                      : [],
              onChanged: isLoading == true
                  ? null
                  : (value) {
                      _selectedActivityValue = value;
                    },
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
                color: isLoading == true
                    ? scheme.onSurfaceVariant
                    : scheme.onSurface,
              ),
              iconEnabledColor: scheme.primary,
            ),
          ),
          MouseRegion(
            cursor: MouseCursor.defer,
            child: InkWell(
              onTap: isLoading == true
                  ? null
                  : () async {
                      _dateSelected = await _pickDate();

                      setState(() {});
                    },
              child: SearchField(
                label: isLoading == true ? 'SEARCHING...' : 'AVAILABLE DATE',
                child: Text(
                  isLoading == true
                      ? 'SEARCHING...'
                      : _dateSelected != null
                          ? DateFormat(GeneralConstants.dateFormat)
                              .format(_dateSelected!)
                          : 'SELECT DATE',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isLoading == true
                        ? scheme.onSurfaceVariant
                        : _dateSelected == null
                            ? scheme.onSurfaceVariant
                            : scheme.onSurface,
                  ),
                ),
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
              child: lookupState.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : isWide
                      ? Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  // Expanded(child: fields[0]),
                                  // _ghostDivider(theme),
                                  Expanded(child: fields[0]),
                                  _ghostDivider(theme),
                                  Expanded(child: fields[1]),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            GradientButton(
                              label:
                                  isLoading == true ? 'SEARCHING...' : 'SEARCH',
                              icon: Icons.search,
                              large: true,
                              onPressed: isLoading == true ? null : () {},
                              tone: isLoading == true
                                  ? GradientButtonTone.secondary
                                  : GradientButtonTone.primary,
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
                            // fields[2],
                            const SizedBox(height: 12),
                            GradientButton(
                              label:
                                  isLoading == true ? 'SEARCHING...' : 'SEARCH',
                              icon: Icons.search,
                              large: true,
                              onPressed: isLoading == true ? null : () {},
                              tone: isLoading == true
                                  ? GradientButtonTone.secondary
                                  : GradientButtonTone.primary,
                            ),
                          ],
                        ),
            ),
          ),
        );
      },
    );
  }

  Widget _softSpacer(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 1,
      color: theme.colorScheme.outlineVariant.withOpacity(0.15),
    );
  }

  Widget _ghostDivider(ThemeData theme) {
    return Container(
      width: 1,
      height: 52,
      color: theme.colorScheme.outlineVariant.withOpacity(0.20),
    );
  }

  Future<DateTime?> _pickDate() async {
    final dateSelected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
    );
    return dateSelected;
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

  Widget _buildFacilitiesSection({required BuildContext context}) {
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
                const SizedBox(
                  height: 20,
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final rangeState = ref.watch(rangeViewModelProvider);

                    if (rangeState.isLoading == true) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (_gridSelected) {
                      if (rangeState.foundRanges != null &&
                          rangeState.foundRanges!.length > 1) {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: rangeState.foundRanges?.length ?? 0,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 360,
                            crossAxisSpacing: 24,
                            mainAxisSpacing: 24,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) {
                            final item = rangeState?.foundRanges?[index];

                            return _FacilityCardWidget(
                                facility: item ?? Range());
                          },
                        );
                      }

                      if (rangeState.foundRanges == null ||
                          rangeState.foundRanges!.isEmpty) {
                        return const Text('No Ranges found');
                      }
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: rangeState.foundRanges!.map((range) {
                          return Container(
                            width: 300,
                            margin: const EdgeInsets.only(right: 16),
                            child: _FacilityCardWidget(facility: range),
                          );
                        }).toList(),
                      ),
                    );
                  },
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
          Consumer(
            builder: (context, ref, child) {
              final rangeState = ref.watch(rangeViewModelProvider);
              final message = rangeState.isLoading == true
                  ? 'Loading facilities...'
                  : '${rangeState.foundRanges?.length ?? 0} OPERATIONAL FACILITY FOUND';
              return Text(
                message,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.6,
                ),
              );
            },
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
            if (_gridSelected) {
              return;
            }

            setState(() => _gridSelected = true);
          },
        ),
        // const SizedBox(width: 8),
        // _ToggleButton(
        //   selected: !_gridSelected,
        //   icon: Icons.map_outlined,
        //   onTap: () {
        //     setState(() => _gridSelected = false);
        //   },
        // ),
      ],
    );
  }
}

class _FacilityCardWidget extends ConsumerStatefulWidget {
  final Range facility;
  const _FacilityCardWidget({
    super.key,
    required this.facility,
  });

  @override
  ConsumerState<_FacilityCardWidget> createState() => _FacilityCardState();
}

class _FacilityCardState extends ConsumerState<_FacilityCardWidget> {
  // const _FacilityCard({
  //   required this.facility,
  // });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isWide = MediaQuery.sizeOf(context).width >= 980;

    final statusColor = scheme.tertiary;
    //  switch (facility.statusColorKind) {
    //   _StatusColorKind.available => scheme.tertiary,
    //   _StatusColorKind.full => scheme.error,
    // };

    return MouseRegion(
      cursor: MouseCursor.defer,
      child: InkWell(
        onTap: () {
          _showRangeDetailDialog(rangeId: widget.facility.id ?? '');

          // context.goNamed('range-details', pathParameters: {
          //   'id': widget.facility.id ?? '',
          // });
        },
        child: Container(
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
                      child: widget.facility.nspImage == null
                          ? Image.asset(
                              'assets/no_image_found.png',
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              widget.facility.nspImage!,
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
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.surface.withOpacity(0.82),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MouseRegion(
                              cursor: MouseCursor.defer,
                              child: InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.favorite_border_outlined,
                                  color: scheme.error,
                                  size: 20,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 4),
                            // Text(
                            //   '3.5', //facility.rating,//TODO:: ADD RATING
                            //   style: theme.textTheme.labelMedium?.copyWith(
                            //     color: scheme.onSurface,
                            //     fontWeight: FontWeight.w900,
                            //     letterSpacing: 0.8,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 0,
                      child: Wrap(
                        spacing: 0,
                        runSpacing: 5,
                        children: [
                          if (widget.facility.facilities != null)
                            ...widget.facility.facilities!.map((facility) {
                              return FutureBuilder(
                                future: ref
                                    .read(lookupViewModelProvider.notifier)
                                    .loadLookupValueById(
                                        id: facility.facilityId ?? ''),
                                builder: (context, snapshot) {
                                  return TagPill(
                                    label: snapshot.data ?? '',
                                    isLoading: snapshot.connectionState ==
                                        ConnectionState.waiting,
                                    background: scheme.primaryContainer
                                        .withOpacity(0.92),
                                    foreground: scheme.onPrimary,
                                  );
                                },
                              );
                            }),
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
                              widget.facility.name?.toUpperCase() ?? '',
                              style: isWide
                                  ? theme.textTheme.titleLarge?.copyWith(
                                      color: scheme.onSurface,
                                      fontWeight: FontWeight.w800,
                                    )
                                  : theme.textTheme.titleSmall?.copyWith(
                                      color: scheme.onSurface,
                                      fontWeight: FontWeight.w800,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          FutureBuilder(
                            future: ref
                                .read(rangeViewModelProvider.notifier)
                                .getDistanceBetweenLocations(widget.facility),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ),
                                  ),
                                );
                              }

                              return Text(
                                widget.facility.nspDistanceInKilometers != null
                                    ? 'DIST: ${widget.facility.nspDistanceInKilometers} KM'
                                    : 'DIST: N/A',
                                style: isWide
                                    ? theme.textTheme.labelMedium?.copyWith(
                                        color: scheme.primary,
                                        fontWeight: FontWeight.w800,
                                      )
                                    : theme.textTheme.labelSmall?.copyWith(
                                        color: scheme.primary,
                                        fontWeight: FontWeight.w800,
                                      ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.facility.description ?? '',
                        maxLines: isWide ? 3 : 1,
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Container(
                            //   width: 8,
                            //   height: 8,
                            //   decoration: BoxDecoration(
                            //     shape: BoxShape.circle,
                            //     color: statusColor,
                            //   ),
                            // ),
                            // const SizedBox(width: 8),
                            // Expanded(
                            //   child: Text(
                            //     'STATUS', // facility.statusLabel,//TODO: ADD STATUS
                            //     style: theme.textTheme.labelMedium?.copyWith(
                            //       color: statusColor,
                            //       fontWeight: FontWeight.w900,
                            //       letterSpacing: 1.2,
                            //     ),
                            //   ),
                            // ),
                            TextButton.icon(
                              onPressed: () {},
                              iconAlignment: IconAlignment.end,
                              onHover: (_) {},
                              icon: const Icon(Icons.bookmark_add_outlined,
                                  size: 20),
                              label: Text(
                                'BOOK NOW',
                                style: isWide
                                    ? theme.textTheme.labelMedium?.copyWith(
                                        color: scheme.primary,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.4,
                                      )
                                    : theme.textTheme.labelSmall?.copyWith(
                                        color: scheme.primary,
                                        fontWeight: FontWeight.w800,
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
        ),
      ),
    );
  }

  void _showRangeDetailDialog({required String? rangeId}) {
    final theme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        final screenSize = MediaQuery.of(context).size;
        final dialogWidth = screenSize.width > 768
            ? screenSize.width * 0.7
            : screenSize.width * 0.9;
        final dialogHeight = screenSize.height * 0.8;

        return Dialog(
          child: SizedBox(
              width: dialogWidth,
              height: dialogHeight,
              child: Stack(
                children: [
                  RangeDetail(
                    rangeId: rangeId,
                  ),
                  Positioned(
                    top: 0,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: theme.surface.withOpacity(0.82),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: Icon(
                          Icons.close,
                          color: theme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        );
      },
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
          color:
              selected ? scheme.surfaceContainerHigh : scheme.surfaceContainer,
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
