import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/booking_configs.dart';
import 'package:gun_range_app/providers/viewmodel_providers.dart';
import 'package:gun_range_app/viewmodels/make_booking_vm.dart';

class BookingWidget extends ConsumerStatefulWidget {
  final String? rangeId;
  final MakeBookingState makeBookingState;
  const BookingWidget(
      {super.key, this.rangeId, required this.makeBookingState});

  @override
  ConsumerState<BookingWidget> createState() => _BookingWidgetState();
}

class _BookingWidgetState extends ConsumerState<BookingWidget> {
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  final _dateController = TextEditingController();

  // New: Selected booking config (type)
  dynamic _selectedBookingConfig;

  final List<String> _timeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBookingConfigs();
    });
  }

  Future<void> _loadBookingConfigs() async {
    await ref
        .watch(bookingConfigViewModelProvider.notifier)
        .fetchBookingConfigs(widget.rangeId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final bookingConfigState = ref.watch(bookingConfigViewModelProvider);

    // Assume bookingConfigState has a 'configs' property which is a List of configs
    final List<BookingConfigs> bookingConfigs =
        bookingConfigState.bookingConfigs;

    log('BookingWidget build: bookingConfigs length = ${bookingConfigs.length}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Book a Time Slot',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        // Booking Type Dropdown
        DropdownButton<BookingConfigs>(
          value: _selectedBookingConfig,
          hint: const Text('Select Booking Type'),
          isExpanded: true,
          items: bookingConfigs.map((config) {
            return DropdownMenuItem<BookingConfigs>(
              value: config,
              child: Text(config.resourceType ?? 'Unknown'),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedBookingConfig = value;
            });
          },
        ),
        
        const SizedBox(height: 16),
        DropdownButton<String>(
          value: _selectedTimeSlot,
          hint: const Text('Select Time Slot'),
          isExpanded: true,
          items: _timeSlots.map((slot) {
            return DropdownMenuItem<String>(
              value: slot,
              child: Text(slot),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedTimeSlot = value;
            });
          },
        ),
        const SizedBox(height: 24),
        TextFormField(
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Booking Date',
            hintText: 'Select a date',
            suffixIcon: Icon(Icons.calendar_today),
          ),
          controller: _dateController,
          onTap: widget.makeBookingState.isLoading
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
          validator: (v) =>
              _selectedDate == null ? 'Please select a booking date' : null,
        ),
      ],
    );
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
}
