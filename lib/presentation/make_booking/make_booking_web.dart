import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/booking_configs.dart';
import 'package:gun_range_app/data/models/popup_position.dart';
import 'package:gun_range_app/data/models/range.dart';
import 'package:gun_range_app/data/repositories/booking_config_repository.dart';
import 'package:gun_range_app/domain/services/global_popup_service.dart';
import 'package:gun_range_app/presentation/widgets/booking_widget.dart';
import 'package:gun_range_app/providers/auth_state_provider.dart';
import 'package:gun_range_app/providers/make_booking_provider.dart';
import 'package:gun_range_app/providers/viewmodel_providers.dart';
import 'package:gun_range_app/viewmodels/booking_config_vm.dart';
import 'package:gun_range_app/viewmodels/make_booking_vm.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MakeBookingWeb extends ConsumerStatefulWidget {
  final String? rangeId;
  final Range? range;

  const MakeBookingWeb({Key? key, this.rangeId, this.range}) : super(key: key);

  @override
  ConsumerState<MakeBookingWeb> createState() => _MakeBookingWebState();
}

class _MakeBookingWebState extends ConsumerState<MakeBookingWeb> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  List<Widget> _stepContents = [];
  bool showGuestList = false;

  @override
  void initState() {
    super.initState();

    // Initialize ViewModel after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(makeBookingProvider.notifier)
          .initialize(widget.rangeId, widget.range);

      // Jump to saved page
      final currentPage = ref.read(makeBookingProvider).currentPageIndex;
      if (_pageController.hasClients && currentPage > 0) {
        _pageController.jumpToPage(currentPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch authentication state
    final authUserAsync = ref.watch(authUserProvider);
    final currentUser = authUserAsync.whenOrNull(data: (user) => user);

    // Watch booking state
    final makeBookingState = ref.watch(makeBookingProvider);

    //Watch booking configs state
    final bookingConfigsAsync = ref.watch(bookingConfigViewModelProvider);

    // Handle loading and error states
    if (authUserAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (authUserAsync.hasError) {
      return const Center(child: Text('Error loading user'));
    }

    if (currentUser == null) {
      return const Center(child: Text('Please log in to make a booking'));
    }

    // Show error message if any
    if (makeBookingState.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        GlobalPopupService.showError(
          title: 'Error',
          message: makeBookingState.errorMessage!,
        );
      });
    }

    // Populate content for steps
    _stepContents = [
      _buildGuestForm(
        context: context,
        makeBookingState: makeBookingState,
        currentUser: currentUser,
      ),
      BookingWidget(
        rangeId: widget.rangeId ?? makeBookingState.range?.id ?? '',
      ),
      FutureBuilder(
        future: _buildReviewStep(
          bookingConfigState: bookingConfigsAsync,
          makeBookingState: makeBookingState,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return snapshot.data as Widget;
        },
      )
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: PageView.builder(
        restorationId: 'booking_steps_pageview',
        padEnds: false,
        pageSnapping: false,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _stepContents.length,
        controller: _pageController,
        onPageChanged: (value) {
          makeBookingState.errorMessage = null;
          ref.read(makeBookingProvider.notifier).setCurrentPage(value);
        },
        itemBuilder: (context, index) {
          return Column(
            children: [
              Expanded(
                child: _buildCardForSteps(
                  child: _stepContents[index],
                  index: index,
                  makeBookingState: makeBookingState,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<Widget> _buildReviewStep(
      {required MakeBookingState makeBookingState,
      required BookingConfigState bookingConfigState}) async {
    List<BookingConfigs>? configs;

    if (bookingConfigState.bookingConfigs.isEmpty) {
      configs = await ref
          .read(bookingConfigViewModelProvider.notifier)
          .getBookingConfigsInPreference();
    }

    final shootingRange = bookingConfigState.bookingConfigs.isEmpty
        ? configs!
            .where((element) =>
                element.id.toString() ==
                makeBookingState.bookingDetails?.eventId)
            .firstOrNull
        : bookingConfigState.bookingConfigs
            .where((element) =>
                element.id.toString() ==
                makeBookingState.bookingDetails?.eventId)
            .firstOrNull;
    final rangeName = makeBookingState.range?.name ?? 'Not set';
    final startTime = makeBookingState.bookingDetails?.startTime != null
        ? makeBookingState.bookingDetails!.startTime!
            .toLocal()
            .toString()
            .split(' ')[1]
            .substring(0, 5)
        : 'Not set';
    final endTime = makeBookingState.bookingDetails?.endTime != null
        ? makeBookingState.bookingDetails!.endTime!
            .toLocal()
            .toString()
            .split(' ')[1]
            .substring(0, 5)
        : 'Not set';
    final timeSlot = makeBookingState.bookingDetails?.startTime != null &&
            makeBookingState.bookingDetails?.endTime != null
        ? '${int.parse(startTime.split(':')[0]) > 12 ? '${int.parse(startTime.split(':')[0]) - 12}:${startTime.split(':')[1]} pm' : '$startTime am'} - ${int.parse(endTime.split(':')[0]) > 12 ? '${int.parse(endTime.split(':')[0]) - 12}:${endTime.split(':')[1]} pm' : '$endTime am'}'
        : null;
    final bookingDate = makeBookingState.bookingDetails?.bookedDate != null
        ? makeBookingState.bookingDetails!.bookedDate!
            .toLocal()
            .toString()
            .split(' ')[0]
        : 'Not set';
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Review Your Booking',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text('Please review your booking details before confirming.'),
          const SizedBox(height: 16),
          _buildInfoBlock(
            label: 'Range Name',
            value: rangeName,
          ),
          _buildInfoBlock(
            label: 'Shooting Range',
            value: shootingRange?.resourceType ?? 'Not set',
          ),
          _buildInfoBlock(
            label: 'Booked date',
            value: bookingDate,
          ),
          _buildInfoBlock(
            label: 'Time slot',
            value: timeSlot ?? 'Not set',
          ),
          _buildInfoBlock(
            label: 'Number of guests',
            value: makeBookingState.guests.length.toString(),
            showGuests: true,
            makeBookingState: makeBookingState,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBlock(
      {MakeBookingState? makeBookingState,
      required String label,
      String? value,
      bool? showGuests = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (showGuests == true)
              Tooltip(
                message: 'View Guest Details',
                child: IconButton(
                  onPressed: makeBookingState != null &&
                          makeBookingState.guests.isNotEmpty
                      ? () {
                          setState(() {
                            showGuestList = !showGuestList;
                          });
                        }
                      : null,
                  icon: Icon(
                    showGuestList == false
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: makeBookingState != null &&
                            makeBookingState.guests.isNotEmpty
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.6)
                        : Theme.of(context).disabledColor,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(value ?? 'Not set'),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        if (showGuestList && makeBookingState != null)
          Table(
            border: TableBorder.all(color: Colors.grey),
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
            },
            children: [
              const TableRow(children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Phone',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
              ...makeBookingState.guests.map((guest) {
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(guest.nameController.text),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(guest.emailController.text)),
                    Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(guest.phoneController.text)),
                  ],
                );
              }),
            ],
          ),
      ],
    );
  }

  Widget _buildCardForSteps({
    Widget? child,
    int index = 0,
    required MakeBookingState makeBookingState,
  }) {
    return Card(
      elevation: 4,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80, right: 20),
                child: child,
              ),
            ),

            // Navigation buttons
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (index == 0) const Spacer(),
                    if (index > 0)
                      ElevatedButton(
                        onPressed: makeBookingState.isLoading
                            ? null
                            : () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 150),
                                  curve: Curves.easeInOut,
                                );
                              },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            Theme.of(context).colorScheme.secondary,
                          ),
                          foregroundColor: WidgetStateProperty.all<Color>(
                            Theme.of(context).colorScheme.onTertiary,
                          ),
                          minimumSize:
                              WidgetStateProperty.all(const Size(120, 50)),
                        ),
                        child: const Text('Back'),
                      ),
                    ElevatedButton(
                      onPressed: makeBookingState.isLoading
                          ? null
                          : () {
                              if (index == _stepContents.length - 1) {
                                // Submit booking through ViewModel
                                ref
                                .read(makeBookingProvider.notifier)
                                .createBookingFromCurrentState();
                              } else {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 150),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(120, 50),
                      ),
                      child: makeBookingState.isLoading &&
                              index == _stepContents.length - 1
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              index == _stepContents.length - 1
                                  ? 'Finish'
                                  : 'Next',
                            ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestForm({
    required BuildContext context,
    required MakeBookingState makeBookingState,
    required User currentUser,
  }) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Make Booking for Range: ${makeBookingState.range?.name ?? "Loading..."}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Please provide the following details to complete your booking.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          // Booking type selection
          Column(
            children: [
              _buildBookingTypeOption(
                value: 'myself',
                currentValue: makeBookingState.bookingFor,
                title: 'For myself',
                tooltip:
                    'Select this option if you are booking for yourself. Your details will be used for the booking.',
                isEnabled: !makeBookingState.isLoading,
                onChanged: (value) {
                  ref.read(makeBookingProvider.notifier).setBookingFor(value!);
                },
              ),
              _buildBookingTypeOption(
                value: 'someone',
                currentValue: makeBookingState.bookingFor,
                title: 'For someone else / group',
                tooltip:
                    'Select this option if you are booking for someone else or a group. You will need to provide their details.',
                isEnabled: !makeBookingState.isLoading,
                onChanged: (value) {
                  ref.read(makeBookingProvider.notifier).setBookingFor(value!);
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Booking details based on type
          if (makeBookingState.bookingFor == 'myself') ...[
            _buildMyselfBookingSection(currentUser, makeBookingState),
          ] else ...[
            _buildSomeoneElseBookingSection(makeBookingState),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBookingTypeOption({
    required String value,
    required String currentValue,
    required String title,
    required String tooltip,
    required bool isEnabled,
    required void Function(String?) onChanged,
  }) {
    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: isEnabled ? () => onChanged(value) : null,
          child: Row(
            children: [
              Radio<String>(
                value: value,
                groupValue: currentValue,
                onChanged: isEnabled ? onChanged : null,
              ),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyselfBookingSection(User currentUser, MakeBookingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Booking for: ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            children: [
              _buildInfoRow(
                'Name:',
                currentUser.userMetadata?['full_name'] ?? 'Not provided',
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                'Email:',
                currentUser.email ?? 'Not provided',
              ),
              const SizedBox(height: 12),
              _buildInfoRow(
                'Phone:',
                currentUser.userMetadata?['phone'] ?? 'Not provided',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Divider(thickness: 0.5),
        const SizedBox(height: 12),
        _buildGuestsSection(state),
      ],
    );
  }

  Widget _buildSomeoneElseBookingSection(MakeBookingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          enabled: !state.isLoading,
          controller: state.recipientNameController,
          decoration: const InputDecoration(labelText: 'Recipient Name'),
          validator: (v) =>
              v == null || v.isEmpty ? 'Enter recipient name' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          enabled: !state.isLoading,
          controller: state.recipientEmailController,
          decoration: const InputDecoration(labelText: 'Recipient Email'),
          validator: (v) =>
              v == null || v.isEmpty ? 'Enter recipient email' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          enabled: !state.isLoading,
          controller: state.phoneController,
          decoration: const InputDecoration(labelText: 'Phone'),
          validator: (v) => v == null || v.isEmpty ? 'Enter your phone' : null,
        ),
        const SizedBox(height: 12),
        _buildGuestsSection(state),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildGuestsSection(MakeBookingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Guests:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            if (state.guests.isNotEmpty && !state.isLoading)
              TextButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).colorScheme.error,
                  ),
                  foregroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).colorScheme.onError,
                  ),
                ),
                onPressed: () {
                  GlobalPopupService.showAction(
                    title: 'Remove all guests',
                    message: 'Are you sure you want to remove all guests?',
                    actionText: 'Remove',
                    type: PopupType.custom,
                    onAction: () {
                      ref.read(makeBookingProvider.notifier).clearAllGuests();
                    },
                  );
                },
                label: const Text('Clear All'),
                icon: const Icon(Icons.clear),
              ),
          ],
        ),
        const SizedBox(height: 16),

        // Render guest forms
        ...state.guests.asMap().entries.map((entry) {
          final i = entry.key;
          final guest = entry.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: !state.isLoading,
                      controller: guest.nameController,
                      decoration:
                          const InputDecoration(labelText: 'Guest Name'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Enter guest name' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      enabled: !state.isLoading,
                      controller: guest.emailController,
                      decoration:
                          const InputDecoration(labelText: 'Guest Email'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      enabled: !state.isLoading,
                      controller: guest.phoneController,
                      decoration:
                          const InputDecoration(labelText: 'Guest Phone'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: state.isLoading
                        ? null
                        : () => ref
                            .read(makeBookingProvider.notifier)
                            .removeGuest(i),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          );
        }),

        const SizedBox(height: 12),

        // Add guest button
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            icon: const Icon(Icons.add),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                state.isLoading
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).colorScheme.primary,
              ),
              foregroundColor: WidgetStateProperty.all<Color>(
                state.isLoading
                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.38)
                    : Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            label: const Text('Add Guest'),
            onPressed: state.isLoading
                ? null
                : () => ref.read(makeBookingProvider.notifier).addGuest(),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
