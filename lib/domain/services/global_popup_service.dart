import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/popup_position.dart';
import 'package:gun_range_app/providers/global_popup_state.dart';

class GlobalPopupService {
  static ProviderContainer? _container;

  // Initialize with the provider container
  static void initialize(ProviderContainer container) {
    _container = container;
  }

  static GlobalPopupNotifier get _notifier {
    if (_container == null) {
      throw Exception(
          'GlobalPopupService not initialized. Call GlobalPopupService.initialize() first.');
    }
    return _container!.read(globalPopupProvider.notifier);
  }

  // Show info message
  static void showInfo({
    required String title,
    required String message,
    Duration? duration,
    PopupPosition? position,
  }) {
    try {
      _notifier.showInfo(title, message,
          duration: duration, position: position);
    } catch (e) {
      print("Error showing info popup: $e");
    }
  }

  // Show success message
  static void showSuccess({
    required String title,
    required String message,
    Duration? duration,
    PopupPosition? position,
  }) {
    _notifier.showSuccess(title, message,
        duration: duration, position: position);
  }

  // Show warning message
  static void showWarning({
    required String title,
    required String message,
    Duration? duration,
    PopupPosition? position,
  }) {
    _notifier.showWarning(title, message,
        duration: duration, position: position);
  }

  // Show error message
  static void showError({
    required String title,
    required String message,
    Duration? duration,
    PopupPosition? position,
  }) {
    _notifier.showError(title, message, duration: duration, position: position);
  }

  // Show custom popup
  static void show(PopupMessage popup) {
    _notifier.showPopup(popup);
  }

  // Show action popup
  static void showAction({
    required String title,
    required String message,
    required String actionText,
    required VoidCallback onAction,
    PopupType type = PopupType.info,
    Duration? duration,
    PopupPosition? position,
  }) {
    _notifier.showAction(
      title: title,
      message: message,
      actionText: actionText,
      onAction: onAction,
      type: type,
      duration: duration,
      position: position,
    );
  }

  // Dismiss specific popup
  static void dismiss(String popupId) {
    _notifier.dismissPopup(popupId);
  }

  // Dismiss all popups
  static void dismissAll() {
    _notifier.dismissAll();
  }

  // Dismiss by type
  static void dismissByType(PopupType type) {
    _notifier.dismissByType(type);
  }
}
