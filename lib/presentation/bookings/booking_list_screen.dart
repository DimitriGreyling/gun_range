import 'package:flutter/material.dart';

class BookingListScreen extends StatelessWidget {
  const BookingListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookings')),
      body: const Center(child: Text('Booking List Placeholder')),
    );
  }
}
