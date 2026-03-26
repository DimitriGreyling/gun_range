import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/booking.dart';
import 'package:gun_range_app/data/models/booking_configs.dart';
import 'package:gun_range_app/data/models/booking_state.dart';
import 'package:gun_range_app/providers/repository_providers.dart';
import 'package:gun_range_app/providers/viewmodel_providers.dart';
import 'package:gun_range_app/providers/make_booking_provider.dart';
import 'package:gun_range_app/viewmodels/make_booking_vm.dart';

class BookingWidget extends ConsumerStatefulWidget {
  final String? rangeId;

  const BookingWidget({
    super.key,
    this.rangeId,
  });

  @override
  ConsumerState<BookingWidget> createState() => _BookingWidgetState();
}

class _BookingWidgetState extends ConsumerState<BookingWidget> {
  final _dateController = TextEditingController();

  // final List<String> _timeSlots = [
  //   '08:00 AM',
  //   '09:00 AM',
  //   '10:00 AM',
  //   '11:00 AM',
  //   '12:00 PM',
  //   '01:00 PM',
  //   '02:00 PM',
  //   '03:00 PM',
  //   '04:00 PM',
  //   '05:00 PM',
  // ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeWidget();
    });
  }

  Future<void> _initializeWidget() async {
    // Load booking configs
    await _loadBookingConfigs();

    // Initialize booking details if needed - this will load from persistence
    ref.read(makeBookingProvider.notifier).initializeBookingDetails();

    // Update date controller with current booking date
    _updateDateController();
  }

  void _updateDateController() {
    final makeBookingState = ref.read(makeBookingProvider);
    final bookingDate = makeBookingState.bookingDetails?.bookedDate;
    if (bookingDate != null) {
      _dateController.text = bookingDate.toLocal().toString().split(' ')[0];
    }
  }

  Future<void> _loadBookingConfigs() async {
    await ref
        .read(bookingConfigViewModelProvider.notifier)
        .fetchBookingConfigs(widget.rangeId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final makeBookingState = ref.watch(makeBookingProvider);
    final bookingConfigState = ref.watch(bookingConfigViewModelProvider);

    // Listen for state changes and update UI accordingly
    ref.listen<MakeBookingState>(makeBookingProvider, (previous, current) {
      if (current.bookingDetails?.bookedDate !=
          previous?.bookingDetails?.bookedDate) {
        _updateDateController();
      }
    });

    final List<BookingConfigs> bookingConfigs =
        bookingConfigState.bookingConfigs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Book a Time Slot',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        // Booking Type Dropdown - automatically persisted
        DropdownButtonFormField<BookingConfigs?>(
          items: bookingConfigs.map((config) {
            return DropdownMenuItem<BookingConfigs>(
              value: config,
              child: Text(config.resourceType ?? 'Unknown'),
            );
          }).toList(),
          value: makeBookingState.bookingDetails?.eventId != null
              ? bookingConfigs.cast<BookingConfigs?>().firstWhere(
                    (config) =>
                        config?.id.toString() ==
                        makeBookingState.bookingDetails?.eventId,
                    orElse: () => null,
                  )
              : null,
          hint: const Text('Range'),
          isExpanded: true,
          onChanged: (value) {
            if (value != null) {
              // This automatically triggers persistence
              ref
                  .read(makeBookingProvider.notifier)
                  .updateBookingEventId(value.id?.toString());
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),

        const SizedBox(height: 16),

        // Date picker - automatically persisted
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
                  FocusScope.of(context).requestFocus(FocusNode());
                  await _pickDate(context);
                },
          validator: (v) => makeBookingState.bookingDetails?.bookedDate == null
              ? 'Please select a booking date'
              : null,
        ),

        const SizedBox(height: 16),

        // Time slots - automatically persisted
        FutureBuilder(
          future: ref.read(makeBookingProvider.notifier).getCurrentEventId(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final selectedEvent =
                bookingConfigs.where((x) => x.id == snapshot.data).firstOrNull;
            final slots = selectedEvent?.timeSlots ?? [];
            return Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Available Time Slots',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Row(
                        children: selectedEvent != null && slots.isNotEmpty
                            ? slots.map((slot) {
                                return _buildTimeSlotBlock(
                                  timeSlot: slot,
                                  onTap: () {
                                    //  This automatically triggers persistence
                                    ref
                                        .read(makeBookingProvider.notifier)
                                        .updateBookingTime(slot);
                                  },
                                  isSelected: _isTimeSlotSelected(
                                      slot, makeBookingState),
                                );
                              }).toList()
                            : [],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  bool _isTimeSlotSelected(String slot, MakeBookingState state) {
    if (state.bookingDetails?.startTime == null) return false;

    final slotHour = int.parse(slot.split(':')[0]) +
        (slot.contains('PM') && !slot.startsWith('12') ? 12 : 0);
    return state.bookingDetails!.startTime!.hour == slotHour;
  }

  Future<void> _pickDate(BuildContext context) async {
    final blackouts = await ref
        .read(bookingBlackoutRepositoryProvider)
        .getBookingBlackoutsByRangeId(widget.rangeId!);

    final blockedDates = blackouts
        .where((item) => item.date != null)
        .map((item) =>
            DateTime(item.date!.year, item.date!.month, item.date!.day))
        .toList();

    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      selectableDayPredicate: (day) {
        return !blockedDates.any(
          (blocked) =>
              blocked.year == day.year &&
              blocked.month == day.month &&
              blocked.day == day.day,
        );
      },
    );
    if (picked != null) {
      // This automatically triggers persistence
      ref.read(makeBookingProvider.notifier).updateBookingDate(picked);
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
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: isSelected
                          ? Colors.blue.shade600
                          : (isDisabled ? Colors.grey : Colors.blue),
                      width: isSelected ? 2 : 1),
                ),
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: Text(
                  timeSlot ?? 'Time Slot',
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isDisabled
                        ? Colors.grey
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
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

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}
