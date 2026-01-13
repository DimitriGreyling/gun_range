import 'package:flutter/material.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: const Center(child: Text('Event List Placeholder')),
    );
  }
}
