import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gun_range_app/data/models/booking.dart';
import 'package:gun_range_app/data/models/popup_position.dart';
import 'package:gun_range_app/data/models/range.dart';
import 'package:gun_range_app/data/models/booking_guest.dart';
import 'package:gun_range_app/domain/services/global_popup_service.dart';
import 'package:gun_range_app/presentation/widgets/booking_widget.dart';
import 'package:gun_range_app/presentation/widgets/invoice_widget.dart';
import 'package:gun_range_app/providers/auth_state_provider.dart';
import 'package:gun_range_app/providers/make_booking_provider.dart';
import 'package:gun_range_app/providers/repository_providers.dart';
import 'package:gun_range_app/providers/viewmodel_providers.dart';
import 'package:gun_range_app/viewmodels/make_booking_vm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MakeBookingWeb extends ConsumerStatefulWidget {
  final String? rangeId;
  Range? range;

  MakeBookingWeb({Key? key, this.rangeId, this.range}) : super(key: key);

  @override
  ConsumerState<MakeBookingWeb> createState() => _MakeBookingWebState();
}

class _MakeBookingWebState extends ConsumerState<MakeBookingWeb> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  final _recipientNameController = TextEditingController();
  final _recipientEmailController = TextEditingController();
  DateTime? _selectedDate;
  final _dateController = TextEditingController();
  String _bookingFor = 'myself'; // 'myself' or 'someone'
  final List<Map<String, TextEditingController>> _guests = [];
  List<Widget> _stepContents = [];
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  Booking? _createdBooking = Booking();

  @override
  void initState() {
    super.initState();
    _loadRangeDetailsIfNotExists();
    _loadSavedPage();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    _recipientNameController.dispose();
    _recipientEmailController.dispose();
    for (final guest in _guests) {
      guest['name']?.dispose();
      guest['email']?.dispose();
      guest['phone']?.dispose();
    }
    _dateController.dispose();
    super.dispose();
  }

  void _addGuest() {
    setState(() {
      _guests.add({
        'name': TextEditingController(),
        'email': TextEditingController(),
        'phone': TextEditingController(),
      });
    });
  }

  // Save the current page to SharedPreferences
  Future<void> _saveCurrentPage(int pageIndex) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('booking_current_page', pageIndex);
  }

  // Load the saved page from SharedPreferences
  Future<void> _loadSavedPage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPage = prefs.getInt('booking_current_page') ?? 0;
    setState(() {
      _currentPageIndex = savedPage;
    });

    // Jump to the saved page once the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(_currentPageIndex);
      }
    });
  }

  void _removeGuest(int index) {
    setState(() {
      _guests[index]['name']?.dispose();
      _guests[index]['email']?.dispose();
      _guests[index]['phone']?.dispose();
      _guests.removeAt(index);
    });
  }

  Future<void> _loadRangeDetailsIfNotExists() async {
    if (widget.range == null && widget.rangeId != null) {
      // Load range details using the rangeId
      final range =
          await ref.read(rangeRepositoryProvider).getRangeById(widget.rangeId!);
      if (range != null) {
        setState(() {
          // Update the widget's range property
          widget.range = range;
        });
      }
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      await _loadRangeDetailsIfNotExists();
      final name = _bookingFor == 'myself'
          ? _nameController.text
          : _recipientNameController.text;
      final email = _bookingFor == 'myself'
          ? _emailController.text
          : _recipientEmailController.text;
      final phone = _phoneController.text;
      final date = _selectedDate;

      // Build BookingGuest list
      final List<BookingGuest> bookingGuests = [];

      // Add main booker or recipient
      bookingGuests.add(
        BookingGuest(
          name: name,
          email: email,
          phone: phone,
          isPrimary: true,
        ),
      );

      // Add guests
      for (final guest in _guests) {
        bookingGuests.add(
          BookingGuest(
            name: guest['name']!.text,
            email: guest['email']!.text,
            phone: guest['phone']!.text,
            isPrimary: false,
          ),
        );
      }

      await ref.read(makeBookingProvider.notifier).makeBooking(
            range: widget.range!,
            date: date!,
            bookingGuest: bookingGuests,
          );

      GlobalPopupService.showInfo(
        title: 'Booking Submitted',
        message:
            'Thank you, $name! Your booking for ${widget.range?.name ?? ''} on ${date.toLocal().toString().split(' ')[0]} has been submitted.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //CURRENT USER
    final authUserAsync = ref.watch(authUserProvider);
    final currentUser = authUserAsync.whenOrNull(data: (user) => user);

    // Defensive null check for provider loading
    if (authUserAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (authUserAsync.hasError) {
      return const Center(child: Text('Error loading user'));
    }

    if (currentUser == null) {
      return const Center(child: Text('Please log in to make a booking'));
    }

    //BOKKING STATE
    final makeBookingState = ref.watch(makeBookingProvider);

    //Populate content for steps
    _stepContents = [
      _buildGuestForm(
          context: context,
          makeBookingState: makeBookingState,
          currentUser: currentUser),
      BookingWidget(
        rangeId: widget.rangeId ?? widget.range?.id ?? '',
        makeBookingState: makeBookingState,
        createdBooking: _createdBooking,
      ),
      _buildReviewStep(),
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
          setState(() {
            _currentPageIndex = value;
          });
          _saveCurrentPage(value);
        },
        itemBuilder: (context, index) {
          return Column(
            children: [
              Expanded(
                child: _buildCardForSteps(
                    child: _stepContents[index], index: index),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReviewStep() {
    return Column(
      children: [
        const Text('Review Your Booking',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
       Text('Please review your booking details before confirming.'),
       const SizedBox(height: 16),
       Text('VenueId: ${_createdBooking?.eventId ?? 'Not set'}'),
       Text('Booked date: ${_createdBooking?.bookingDate ?? 'Not set'}'),
        Text('Start time: ${_createdBooking?.startTime ?? 'Not set'}'),
      ],
    );
  }

  Widget _buildCardForSteps({Widget? child, int index = 0}) {
    return Card(
      elevation: 4,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            // Your main content
            SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 80, right: 20),
                  child: child),
            ),

            // Buttons positioned at bottom
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
                        onPressed: () {
                          _pageController.previousPage(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeInOut);
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              Theme.of(context).colorScheme.secondary),
                          foregroundColor: WidgetStateProperty.all<Color>(
                              Theme.of(context).colorScheme.onTertiary),
                          minimumSize:
                              WidgetStateProperty.all(const Size(120, 50)),
                        ),
                        child: const Text('Back'),
                      ),
                    ElevatedButton(
                        onPressed: () {
                          if (index == _stepContents.length - 1) {
                            _submit();
                          } else {
                            _pageController.nextPage(
                                duration: const Duration(milliseconds: 150),
                                curve: Curves.easeInOut);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 50)),
                        child: Text(index == _stepContents.length - 1
                            ? 'Finish'
                            : 'Next'))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestForm(
      {required BuildContext context,
      required MakeBookingState makeBookingState,
      required User currentUser}) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Make Booking for Range: ${widget.range?.name ?? ""}',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Please provide the following details to complete your booking.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          Column(
            children: [
              Tooltip(
                message:
                    'Select this option if you are booking for yourself. Your details will be used for the booking.',
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: makeBookingState.isLoading
                        ? null
                        : () {
                            setState(() {
                              _bookingFor = 'myself';
                            });
                          },
                    child: Row(
                      children: [
                        Radio<String>(
                          value: 'myself',
                          groupValue: _bookingFor,
                          onChanged: makeBookingState.isLoading
                              ? null
                              : (value) {
                                  setState(() {
                                    _bookingFor = value!;
                                  });
                                },
                        ),
                        const Text('For myself'),
                      ],
                    ),
                  ),
                ),
              ),
              Tooltip(
                message:
                    'Select this option if you are booking for someone else or a group. You will need to provide their details.',
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: makeBookingState.isLoading
                        ? null
                        : () {
                            setState(() {
                              _bookingFor = 'someone';
                            });
                          },
                    child: Row(
                      children: [
                        Radio<String>(
                          value: 'someone',
                          groupValue: _bookingFor,
                          onChanged: makeBookingState.isLoading
                              ? null
                              : (value) {
                                  setState(() {
                                    _bookingFor = value!;
                                  });
                                },
                        ),
                        const Text('For someone else / group'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_bookingFor == 'myself') ...[
            const Text(
              'Booking for: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Name:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${currentUser.userMetadata?['full_name'] ?? 'Not provided'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        'Email:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currentUser.email ?? 'Not provided',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        'Phone:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        currentUser.userMetadata?['phone'] ?? 'Not provided',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(
              thickness: 0.5,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Guests:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                if (_guests.isNotEmpty && !makeBookingState.isLoading)
                  TextButton.icon(
                      style: ButtonStyle(
                        backgroundColor: makeBookingState.isLoading
                            ? WidgetStateProperty.all<Color>(Theme.of(context)
                                .disabledColor
                                .withOpacity(0.5))
                            : WidgetStateProperty.all<Color>(
                                Theme.of(context).colorScheme.error),
                        foregroundColor: makeBookingState.isLoading
                            ? WidgetStateProperty.all<Color>(Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.38))
                            : WidgetStateProperty.all<Color>(
                                Theme.of(context).colorScheme.onError),
                      ),
                      onPressed: () {
                        GlobalPopupService.showAction(
                          title: 'Remove all guests',
                          message: 'Are you sure you want to remove all guests',
                          actionText: 'Remove',
                          type: PopupType.custom,
                          onAction: () {
                            setState(() {
                              _guests.clear();
                            });
                          },
                        );
                      },
                      label: const Text('Clear All'),
                      icon: const Icon(Icons.clear)),
              ],
            ),
            const SizedBox(height: 16),
            ..._guests.asMap().entries.map((entry) {
              final i = entry.key;
              final guest = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          enabled: makeBookingState.isLoading ? false : true,
                          controller: guest['name'],
                          decoration:
                              const InputDecoration(labelText: 'Guest Name'),
                          validator: (v) => v == null || v.isEmpty
                              ? 'Enter guest name'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          enabled: makeBookingState.isLoading ? false : true,
                          decoration:
                              const InputDecoration(labelText: 'Guest Email'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          enabled: makeBookingState.isLoading ? false : true,
                          controller: guest['phone'],
                          decoration:
                              const InputDecoration(labelText: 'Guest Phone'),
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: makeBookingState.isLoading
                            ? null
                            : () => _removeGuest(i),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              );
            }),
            const SizedBox(
              height: 12,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                style: ButtonStyle(
                  backgroundColor: makeBookingState.isLoading
                      ? WidgetStateProperty.all<Color>(
                          Theme.of(context).disabledColor)
                      : WidgetStateProperty.all<Color>(
                          Theme.of(context).colorScheme.primary),
                  foregroundColor: makeBookingState.isLoading
                      ? WidgetStateProperty.all<Color>(Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.38))
                      : WidgetStateProperty.all<Color>(
                          Theme.of(context).colorScheme.onPrimary),
                ),
                label: const Text('Add Guest'),
                onPressed: makeBookingState.isLoading ? null : _addGuest,
              ),
            ),
            const SizedBox(height: 12),
          ] else ...[
            TextFormField(
              enabled: makeBookingState.isLoading ? false : true,
              controller: _recipientNameController,
              decoration: const InputDecoration(labelText: 'Recipient Name'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Enter recipient name' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              enabled: makeBookingState.isLoading ? false : true,
              controller: _recipientEmailController,
              decoration: const InputDecoration(labelText: 'Recipient Email'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Enter recipient email' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              enabled: makeBookingState.isLoading ? false : true,
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Enter your phone' : null,
            ),
            const SizedBox(height: 12),
            Text('Guests:', style: Theme.of(context).textTheme.titleMedium),
            ..._guests.asMap().entries.map((entry) {
              final i = entry.key;
              final guest = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          enabled: makeBookingState.isLoading ? false : true,
                          controller: guest['name'],
                          decoration:
                              const InputDecoration(labelText: 'Guest Name'),
                          validator: (v) => v == null || v.isEmpty
                              ? 'Enter guest name'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          enabled: makeBookingState.isLoading ? false : true,
                          controller: guest['email'],
                          decoration:
                              const InputDecoration(labelText: 'Guest Email'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          enabled: makeBookingState.isLoading ? false : true,
                          controller: guest['phone'],
                          decoration:
                              const InputDecoration(labelText: 'Guest Phone'),
                        ),
                      ),
                      IconButton(
                        icon:
                            const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: makeBookingState.isLoading
                            ? null
                            : () => _removeGuest(i),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              );
            }),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Guest'),
                onPressed: makeBookingState.isLoading ? null : _addGuest,
              ),
            ),
            const SizedBox(height: 12),
          ],

          const SizedBox(height: 24),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     ElevatedButton(
          //       style: makeBookingState.isLoading
          //           ? ButtonStyle(
          //               backgroundColor: WidgetStateProperty.all<Color>(
          //                   Theme.of(context).disabledColor))
          //           : ButtonStyle(
          //               backgroundColor: WidgetStateProperty.all<Color>(
          //                   Theme.of(context).colorScheme.secondary)),
          //       onPressed: makeBookingState.isLoading
          //           ? null
          //           : () {
          //               GlobalPopupService.showAction(
          //                   title: 'Cancel Booking',
          //                   message:
          //                       'Are you sure you want to cancel the booking?',
          //                   actionText: 'Yes, Cancel',
          //                   onAction: () {
          //                     context
          //                         .go('/range-detail/${widget.rangeId ?? ''}');
          //                   });
          //             },
          //       child: const Text('Cancel'),
          //     ),
          //     ElevatedButton(
          //       onPressed: makeBookingState.isLoading ? null : _submit,
          //       child: const Text('Book and Pay'),
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
