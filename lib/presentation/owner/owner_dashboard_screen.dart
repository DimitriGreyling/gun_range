import 'package:flutter/material.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Owner Dashboard')),
      body: const Center(child: Text('Owner Dashboard Placeholder')),
    );
  }
}
