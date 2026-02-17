import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/booking.dart';
import 'package:gun_range_app/data/models/booking_configs.dart';
import 'package:gun_range_app/providers/viewmodel_providers.dart';
import 'package:gun_range_app/viewmodels/make_booking_vm.dart';

class BookingWidget extends ConsumerStatefulWidget {
  final String? rangeId;
  final MakeBookingState makeBookingState;
  final Booking? createdBooking;

  const BookingWidget({
    super.key,
    this.rangeId,
    required this.makeBookingState,
    this.createdBooking,
  });

  @override
  ConsumerState<BookingWidget> createState() => _BookingWidgetState();
}

class _BookingWidgetState extends ConsumerState<BookingWidget> {
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  final _dateController = TextEditingController();

  ValueNotifier<bool> isBookingTypeSelected = ValueNotifier<bool>(false);
  ValueNotifier<bool> isTimeSelected = ValueNotifier<bool>(false);
  ValueNotifier<bool> isDateSelected = ValueNotifier<bool>(false);

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
        DropdownButtonFormField(
          items: bookingConfigs.map((config) {
            return DropdownMenuItem<BookingConfigs>(
              value: config,
              child: Text(config.resourceType ?? 'Unknown'),
            );
          }).toList(),
          hint: const Text('Range'),
          isExpanded: true,
          onChanged: (value) {
            setState(() {
              _selectedBookingConfig = value;
              widget.createdBooking?.eventId =
                  value?.id; // Set eventId in booking model
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),

        const SizedBox(height: 16),

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
                    widget.createdBooking?.bookingDate =
                        _selectedDate; // Set date in booking model
                  });
                },
          validator: (v) =>
              _selectedDate == null ? 'Please select a booking date' : null,
        ),

        const SizedBox(height: 16),

        //Timeslot selection UI will go here, for now we can just show a placeholder
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Available Time Slots',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Row(
              children: [
                ..._timeSlots.map((slot) => _buildTimeSlotBlock(
                    timeSlot: slot,
                    onTap: () {
                      setState(() {
                        _selectedTimeSlot = slot;
                      });
                    final selectedDate = widget.createdBooking?.bookingDate ?? DateTime.now();
                    widget.createdBooking?.startTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, int.parse(slot.split(':')[0]) + (slot.contains('PM') ? 12 : 0), 0);
                    widget.createdBooking?.endTime = widget.createdBooking!.startTime!.add(const Duration(hours: 1));
                    },
                    isSelected: _selectedTimeSlot == slot)),
              ],
            ),
          ],
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

  Widget _buildTimeSlotBlock({
    String? timeSlot,
    Function()? onTap,
    bool isSelected = false,
    bool isDisabled = false,
  }) {
    return MouseRegion(
      cursor:
          isDisabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
      child: GestureDetector(
          onTap: isDisabled ? null : () => onTap?.call(),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color:
                      isDisabled ? Colors.grey.shade300 : Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: isDisabled ? Colors.grey : Colors.blue, width: 1),
                ),
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: Text(timeSlot ?? 'Time Slot'),
              ),
              if (isSelected)
                const Positioned(
                  right: 0,
                  top: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.check, size: 12, color: Colors.white),
                  ),
                ),
            ],
          )),
    );
  }
}
