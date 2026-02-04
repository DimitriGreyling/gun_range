import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gun_range_app/data/models/range.dart';
import 'package:gun_range_app/data/models/booking_guest.dart';
import 'package:gun_range_app/domain/services/global_popup_service.dart';
import 'package:gun_range_app/providers/auth_state_provider.dart';
import 'package:gun_range_app/providers/make_booking_provider.dart';
import 'package:gun_range_app/providers/repository_providers.dart';

class MakeBookingWeb extends ConsumerStatefulWidget {
  final String? rangeId;
  Range? range;

  MakeBookingWeb({super.key, this.rangeId, this.range});

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRangeDetailsIfNotExists();
    });
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

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
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
      return Center(child: Text('Error loading user'));
    }

    //BOKKING STATE
    final makeBookingState = ref.watch(makeBookingProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Make Booking for Range: ${widget.range?.name ?? ""}',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              Row(
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
              const SizedBox(height: 12),
              if (_bookingFor == 'myself') ...[
                const Text('Booking for: '),
                const SizedBox(height: 12),
                Text('Name: ${currentUser?.userMetadata?['full_name'] ?? ''}'),
                const SizedBox(height: 12),
                Text('Email: ${currentUser?.email ?? ''}'),
                const SizedBox(height: 12),
                Text(
                    'Phone: ${currentUser?.userMetadata?['phone'] ?? 'Not Provided'}'),
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
                              enabled:
                                  makeBookingState.isLoading ? false : true,
                              controller: guest['name'],
                              decoration: const InputDecoration(
                                  labelText: 'Guest Name'),
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Enter guest name'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              enabled:
                                  makeBookingState.isLoading ? false : true,
                              decoration: const InputDecoration(
                                  labelText: 'Guest Email'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              enabled:
                                  makeBookingState.isLoading ? false : true,
                              controller: guest['phone'],
                              decoration: const InputDecoration(
                                  labelText: 'Guest Phone'),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
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
              ] else ...[
                TextFormField(
                  enabled: makeBookingState.isLoading ? false : true,
                  controller: _recipientNameController,
                  decoration:
                      const InputDecoration(labelText: 'Recipient Name'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter recipient name' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  enabled: makeBookingState.isLoading ? false : true,
                  controller: _recipientEmailController,
                  decoration:
                      const InputDecoration(labelText: 'Recipient Email'),
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
                              enabled:
                                  makeBookingState.isLoading ? false : true,
                              controller: guest['name'],
                              decoration: const InputDecoration(
                                  labelText: 'Guest Name'),
                              validator: (v) => v == null || v.isEmpty
                                  ? 'Enter guest name'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              enabled:
                                  makeBookingState.isLoading ? false : true,
                              controller: guest['email'],
                              decoration: const InputDecoration(
                                  labelText: 'Guest Email'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              enabled:
                                  makeBookingState.isLoading ? false : true,
                              controller: guest['phone'],
                              decoration: const InputDecoration(
                                  labelText: 'Guest Phone'),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
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
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Booking Date',
                  hintText: 'Select a date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                controller: _dateController,
                onTap: makeBookingState.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context)
                            .requestFocus(FocusNode()); // Prevents keyboard
                        await _pickDate(context);
                        setState(() {
                          _dateController.text = _selectedDate == null
                              ? ''
                              : _selectedDate!.toLocal().toString().split(' ')[0];
                        });
                      },
                validator: (v) => _selectedDate == null
                    ? 'Please select a booking date'
                    : null,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            Theme.of(context).colorScheme.secondary)),
                    onPressed: makeBookingState.isLoading
                        ? null
                        : () {
                            GlobalPopupService.showAction(
                                title: 'Cancel Booking',
                                message:
                                    'Are you sure you want to cancel the booking?',
                                actionText: 'Yes, Cancel',
                                onAction: () {
                                  context.go(
                                      '/range-detail/${widget.rangeId ?? ''}');
                                });
                          },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: makeBookingState.isLoading ? null : _submit,
                    child: const Text('Book and Pay'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
