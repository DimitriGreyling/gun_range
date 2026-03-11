import 'package:flutter/material.dart';

class BookingGuestData {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  BookingGuestData({
    required this.nameController,
    required this.emailController,
    required this.phoneController,
  });

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }

  BookingGuestData copyWith({
    TextEditingController? nameController,
    TextEditingController? emailController,
    TextEditingController? phoneController,
  }) {
    return BookingGuestData(
      nameController: nameController ?? this.nameController,
      emailController: emailController ?? this.emailController,
      phoneController: phoneController ?? this.phoneController,
    );
  }
}