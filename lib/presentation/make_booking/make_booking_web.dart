import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gun_range_app/core/routing/app_router.dart';
import 'package:gun_range_app/data/models/range.dart';
import 'package:gun_range_app/domain/services/global_popup_service.dart';

class MakeBookingWeb extends StatefulWidget {
  final String? rangeId;
  final Range? range;

  const MakeBookingWeb({super.key, this.rangeId, this.range});

  @override
  State<MakeBookingWeb> createState() => _MakeBookingWebState();
}

class _MakeBookingWebState extends State<MakeBookingWeb> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
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

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Send booking data to backend/Supabase
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking submitted!')),
      );
      // Optionally clear form or navigate away
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Make Booking for Range: ${widget.range?.name ?? ""}',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter your email' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter your phone' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No date selected'
                          : 'Date: ${_selectedDate!.toLocal()}'.split(' ')[0],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickDate(context),
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration:
                    const InputDecoration(labelText: 'Notes (optional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            Theme.of(context).colorScheme.secondary)),
                    onPressed: () {
                      GlobalPopupService.showAction(title: 'Cancel Booking', message: 'Are you sure you want to cancel the booking?', actionText: 'Yes, Cancel', onAction: () {
                        context.go('/range-detail/${widget.rangeId ?? ''}');
                      });
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Submit Booking'),
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
