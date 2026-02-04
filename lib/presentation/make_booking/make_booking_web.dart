import 'package:flutter/material.dart';

class MakeBookingWeb extends StatefulWidget {
  final String? rangeId;

  const MakeBookingWeb({super.key, this.rangeId});

  @override
  State<MakeBookingWeb> createState() => _MakeBookingWebState();
}

class _MakeBookingWebState extends State<MakeBookingWeb> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Make Booking for Range ID: ${widget.rangeId}')),
    );
  }
}
