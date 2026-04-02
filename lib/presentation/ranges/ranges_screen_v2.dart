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
  String _proximity = 'Nearby (25mi)';
  String _depth = 'Pistol (25yd)';
  String _caliber = 'Up to .45 ACP';
  bool _gridSelected = true;

  final TextEditingController _locationController = TextEditingController();
  String? _selectedActivityValue;
  DateTime? _dateSelected;
  
  // Track if initial data has been loaded
  bool _initialDataLoaded = false;

  @override
  void initState() {
    super.initState();
    
    // Set initial values from widget parameters
    _locationController.text = widget.location ?? '';
    _selectedActivityValue = widget.activityId;
    _dateSelected = widget.availableDate;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    if (_initialDataLoaded) return;
    
    final lookupState = ref.read(lookupViewModelProvider);
    final rangeState = ref.read(rangeViewModelProvider);
    
    // Only load lookups if not already loaded
    if (lookupState.lookups == null || lookupState.lookups!.isEmpty) {
      ref
          .read(lookupViewModelProvider.notifier)
          .getLookupsByListValue(listValue: 'RANGE_TYPE');
    }
    
    // Only search ranges if not already loaded or if parameters are different
    if (rangeState.foundRanges == null || rangeState.isLoading == false) {
      ref.read(rangeViewModelProvider.notifier).searchRanges(
        availableDate: _dateSelected,
        activityId: _selectedActivityValue,
        location: _locationController.text,
      );
    }
    
    _initialDataLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Use select to minimize rebuilds
    final isLoading = ref.watch(rangeViewModelProvider.select((state) => state.isLoading));

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Column(
        children: [
          const TopBarWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHero(context: context, isLoading: isLoading),
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
        // Use select to watch only the loading state and lookups
        final lookupLoading = ref.watch(lookupViewModelProvider.select((state) => state.isLoading));
        final lookups = ref.watch(lookupViewModelProvider.select((state) => state.lookups));

        if (lookupLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final fields = [
          SearchField(
            label: 'ACTIVITY',
            child: DropdownButtonFormField<String>(
              value: _selectedActivityValue,
              hint: Text(isLoading == true ? 'SEARCHING...' : 'ACTIVITY'),
              items: lookups != null && lookups.isNotEmpty
                  ? lookups.map((lookup) {
                      return DropdownMenuItem(
                          value: lookup.id,
                          child: Text(lookup.lookupDescription ?? ''));
                    }).toList()
                  : [],
              onChanged: isLoading == true
                  ? null
                  : (value) {
                      setState(() {
                        _selectedActivityValue = value;
                      });
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
                      final date = await _pickDate();
                      if (date != null) {
                        setState(() {
                          _dateSelected = date;
                        });
                      }
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
              child: lookupLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : isWide
                      ? Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(child: fields[0]),
                                  _ghostDivider(theme),
                                  Expanded(child: fields[1]),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            GradientButton(
                              label: isLoading == true ? 'SEARCHING...' : 'SEARCH',
                              icon: Icons.search,
                              large: true,
                              onPressed: isLoading == true ? null : _performSearch,
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
                            const SizedBox(height: 12),
                            GradientButton(
                              label: isLoading == true ? 'SEARCHING...' : 'SEARCH',
                              icon: Icons.search,
                              large: true,
                              onPressed: isLoading == true ? null : _performSearch,
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

  void _performSearch() {
    ref.read(rangeViewModelProvider.notifier).searchRanges(
      availableDate: _dateSelected,
      activityId: _selectedActivityValue,
      location: _locationController.text,
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
                const SizedBox(height: 20),
                Consumer(
                  builder: (context, ref, child) {
                    // Use select to watch only necessary parts
                    final isLoading = ref.watch(rangeViewModelProvider.select((state) => state.isLoading));
                    final foundRanges = ref.watch(rangeViewModelProvider.select((state) => state.foundRanges));

                    if (isLoading == true) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (foundRanges == null || foundRanges.isEmpty) {
                      return const Text('No Ranges found');
                    }

                    if (_gridSelected) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: foundRanges.length,
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 360,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          final item = foundRanges[index];
                          return _FacilityCardWidget(
                            key: ValueKey(item.id), // Add key for better performance
                            facility: item,
                          );
                        },
                      );
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: foundRanges.map((range) {
                          return Container(
                            width: 300,
                            margin: const EdgeInsets.only(right: 16),
                            child: _FacilityCardWidget(
                              key: ValueKey(range.id), // Add key for better performance
                              facility: range,
                            ),
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
              final isLoading = ref.watch(rangeViewModelProvider.select((state) => state.isLoading));
              final rangeCount = ref.watch(rangeViewModelProvider.select((state) => state.foundRanges?.length ?? 0));
              
              final message = isLoading == true
                  ? 'Loading facilities...'
                  : '$rangeCount OPERATIONAL FACILITY FOUND';
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
            if (_gridSelected) return;
            setState(() => _gridSelected = true);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }
}

// Optimized Facility Card Widget
class _FacilityCardWidget extends ConsumerWidget {
  final Range facility;
  
  const _FacilityCardWidget({
    super.key,
    required this.facility,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isWide = MediaQuery.sizeOf(context).width >= 980;

    return MouseRegion(
      cursor: MouseCursor.defer,
      child: InkWell(
        onTap: () {
          _showRangeDetailDialog(context: context, rangeId: facility.id ?? '');
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
                      child: facility.nspImage == null
                          ? Image.asset(
                              'assets/no_image_found.png',
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              facility.nspImage!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/no_image_found.png',
                                  fit: BoxFit.cover,
                                );
                              },
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
                        child: InkWell(
                          onTap: () {
                            // Handle favorite action
                          },
                          child: Icon(
                            Icons.favorite_border_outlined,
                            color: scheme.error,
                            size: 20,
                          ),
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
                          if (facility.facilities != null)
                            ...facility.facilities!.map((facilityItem) {
                              // Use the cached provider instead of FutureBuilder
                              return Consumer(
                                builder: (context, ref, child) {
                                  final lookupAsync = ref.watch(
                                    lookupValueProvider(facilityItem.facilityId ?? ''),
                                  );
                                  
                                  return lookupAsync.when(
                                    data: (value) => TagPill(
                                      label: value,
                                      background: scheme.primaryContainer.withOpacity(0.92),
                                      foreground: scheme.onPrimary,
                                    ),
                                    loading: () => TagPill(
                                      label: '',
                                      isLoading: true,
                                      background: scheme.primaryContainer.withOpacity(0.92),
                                      foreground: scheme.onPrimary,
                                    ),
                                    error: (error, stackTrace) => TagPill(
                                      label: 'Error',
                                      background: scheme.errorContainer,
                                      foreground: scheme.onError,
                                    ),
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
                              facility.name?.toUpperCase() ?? '',
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
                          // Use cached distance provider
                          Consumer(
                            builder: (context, ref, child) {
                              final distanceAsync = ref.watch(distanceProvider(facility));
                              
                              return distanceAsync.when(
                                data: (distance) => Text(
                                  distance,
                                  style: isWide
                                      ? theme.textTheme.labelMedium?.copyWith(
                                          color: scheme.primary,
                                          fontWeight: FontWeight.w800,
                                        )
                                      : theme.textTheme.labelSmall?.copyWith(
                                          color: scheme.primary,
                                          fontWeight: FontWeight.w800,
                                        ),
                                ),
                                loading: () => const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 1),
                                ),
                                error: (error, stackTrace) => Text(
                                  'DIST: N/A',
                                  style: isWide
                                      ? theme.textTheme.labelMedium?.copyWith(
                                          color: scheme.primary,
                                          fontWeight: FontWeight.w800,
                                        )
                                      : theme.textTheme.labelSmall?.copyWith(
                                          color: scheme.primary,
                                          fontWeight: FontWeight.w800,
                                        ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        facility.description ?? '',
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
                            TextButton.icon(
                              onPressed: () {
                                // Handle booking
                              },
                              iconAlignment: IconAlignment.end,
                              icon: const Icon(Icons.bookmark_add_outlined, size: 20),
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

  void _showRangeDetailDialog({required BuildContext context, required String rangeId}) {
    final theme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) {
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
                RangeDetail(rangeId: rangeId),
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
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      icon: Icon(
                        Icons.close,
                        color: theme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
          color: selected ? scheme.surfaceContainerHigh : scheme.surfaceContainer,
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