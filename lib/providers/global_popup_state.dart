import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/core/constants/popup_constants.dart';
import 'package:gun_range_app/data/models/popup_position.dart';

class GlobalPopupState {
  final List<PopupMessage> activePopups;
  final bool isOverlayActive;

  const GlobalPopupState({
    required this.activePopups,
    required this.isOverlayActive,
  });

  GlobalPopupState copyWith({
    List<PopupMessage>? activePopups,
    bool? isOverlayActive,
  }) {
    return GlobalPopupState(
      activePopups: activePopups ?? this.activePopups,
      isOverlayActive: isOverlayActive ?? this.isOverlayActive,
    );
  }
}

class GlobalPopupNotifier extends StateNotifier<GlobalPopupState> {
  GlobalPopupNotifier()
      : super(const GlobalPopupState(
          activePopups: [],
          isOverlayActive: false,
        ));

  final Map<String, Timer> _timers = {};

  // Show a popup message
  void showPopup(PopupMessage popup) {
    // Remove existing popup with same ID if any
    if (state.activePopups.any((p) => p.id == popup.id)) {
      dismissPopup(popup.id);
    }

    // Add new popup
    final updatedPopups = [...state.activePopups, popup];
    state = state.copyWith(
      activePopups: updatedPopups,
      isOverlayActive: true,
    );

    // Set up auto-dismiss timer if not persistent
    if (popup.duration != Duration.zero) {
      _timers[popup.id] = Timer(popup.duration, () {
        dismissPopup(popup.id);
      });
    }
  }

  // Show info popup
  void showInfo(String title, String message,
      {Duration? duration, PopupPosition? position}) {
    showPopup(PopupMessage(
      title: title,
      message: message,
      type: PopupType.info,
      duration:
          duration ?? Duration(seconds: PopupConstants.informationPopupTimeOutInSeconds),
      position: position ?? PopupPosition.top,
    ));
  }

  // Show success popup
  void showSuccess(String title, String message,
      {Duration? duration, PopupPosition? position}) {
    showPopup(PopupMessage(
      title: title,
      message: message,
      type: PopupType.success,
      duration:
          duration ?? Duration(seconds: PopupConstants.successPopupTimeOutInSeconds),
      position: position ?? PopupPosition.top,
    ));
  }

  // Show warning popup
  void showWarning(String title, String message,
      {Duration? duration, PopupPosition? position}) {
    showPopup(PopupMessage(
      title: title,
      message: message,
      type: PopupType.warning,
      duration:
          duration ?? Duration(seconds: PopupConstants.warningPopupTimeOutInSeconds),
      position: position ?? PopupPosition.top,
    ));
  }

  // Show error popup
  void showError(String title, String message,
      {Duration? duration, PopupPosition? position}) {
    showPopup(PopupMessage(
      title: title,
      message: message,
      type: PopupType.error,
      duration:
          duration ?? Duration(seconds: PopupConstants.errorPopupTimeOutInSeconds),
      position: position ?? PopupPosition.top,
    ));
  }

  // Show custom popup with action
  void showAction({
    required String title,
    required String message,
    required String actionText,
    required VoidCallback onAction,
    String? secondaryActionText,
    VoidCallback? onSecondaryAction,
    PopupType type = PopupType.info,
    Duration? duration,
    PopupPosition? position,
  }) {
    showPopup(PopupMessage(
      title: title,
      message: message,
      type: type,
      actionText: actionText,
      onAction: onAction,
      duration: duration ?? Duration.zero, // Don't auto-dismiss action popups
      position: position ?? PopupPosition.center,
      secondaryActionText: secondaryActionText,
      onSecondaryAction: onSecondaryAction,
    ));
  }

  // Dismiss specific popup
  void dismissPopup(String popupId) {
    // Cancel timer
    _timers[popupId]?.cancel();
    _timers.remove(popupId);

    // Find and remove popup
    final updatedPopups =
        state.activePopups.where((p) => p.id != popupId).toList();

    // Call onDismiss callback
    final popup = state.activePopups.firstWhere(
      (p) => p.id == popupId,
      orElse: () => PopupMessage(title: '', message: ''),
    );
    popup.onDismiss?.call();

    state = state.copyWith(
      activePopups: updatedPopups,
      isOverlayActive: updatedPopups.isNotEmpty,
    );
  }

  // Dismiss all popups
  void dismissAll() {
    // Cancel all timers
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();

    // Call onDismiss for all popups
    for (final popup in state.activePopups) {
      popup.onDismiss?.call();
    }

    state = state.copyWith(
      activePopups: [],
      isOverlayActive: false,
    );
  }

  // Dismiss popups by type
  void dismissByType(PopupType type) {
    final popupsToRemove =
        state.activePopups.where((p) => p.type == type).toList();

    for (final popup in popupsToRemove) {
      dismissPopup(popup.id);
    }
  }

  @override
  void dispose() {
    // Clean up all timers
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    super.dispose();
  }
}

// Provider instance
final globalPopupProvider =
    StateNotifierProvider<GlobalPopupNotifier, GlobalPopupState>((ref) {
  return GlobalPopupNotifier();
});

// Convenience providers
final activePopupsProvider = Provider<List<PopupMessage>>((ref) {
  return ref.watch(globalPopupProvider).activePopups;
});

final isOverlayActiveProvider = Provider<bool>((ref) {
  return ref.watch(globalPopupProvider).isOverlayActive;
});
