import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gun_range_app/data/models/popup_position.dart';
import 'package:gun_range_app/presentation/widgets/popup/popup_message_widget.dart';
import 'package:gun_range_app/providers/global_popup_state.dart';

class GlobalPopupOverlay extends ConsumerWidget {
  final Widget child;

  const GlobalPopupOverlay({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activePopups = ref.watch(activePopupsProvider);
    final popupNotifier = ref.read(globalPopupProvider.notifier);

    return Stack(
      children: [
        // Main content
        child,

        // Popup overlay
        if (activePopups.isNotEmpty)
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  // Glassy blurred background
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                    child: Container(
                      color: Colors.white
                          .withOpacity(0.2), // semi-transparent overlay
                    ),
                  ),
                  ...activePopups.map((popup) {
                    return _buildPositionedPopup(popup, popupNotifier);
                  }).toList(),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPositionedPopup(
      PopupMessage popup, GlobalPopupNotifier notifier) {
    switch (popup.position) {
      case PopupPosition.top:
        return Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: PopupMessageWidget(
            popup: popup,
            onDismiss: () => notifier.dismissPopup(popup.id),
          ),
        );

      case PopupPosition.center:
        return Positioned.fill(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: double.infinity * 0.8,
                minWidth: double.infinity * 0.4,
              ),
              child: PopupMessageWidget(
                popup: popup,
                onDismiss: () => notifier.dismissPopup(popup.id),
              ),
            ),
          ),
        );

      case PopupPosition.bottom:
        return Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: PopupMessageWidget(
            popup: popup,
            onDismiss: () => notifier.dismissPopup(popup.id),
          ),
        );

      case PopupPosition.topLeft:
        return Positioned(
          top: 50,
          left: 16,
          child: PopupMessageWidget(
            popup: popup,
            onDismiss: () => notifier.dismissPopup(popup.id),
          ),
        );

      case PopupPosition.topRight:
        return Positioned(
          top: 50,
          right: 16,
          child: PopupMessageWidget(
            popup: popup,
            onDismiss: () => notifier.dismissPopup(popup.id),
          ),
        );

      case PopupPosition.bottomLeft:
        return Positioned(
          bottom: 50,
          left: 16,
          child: PopupMessageWidget(
            popup: popup,
            onDismiss: () => notifier.dismissPopup(popup.id),
          ),
        );

      case PopupPosition.bottomRight:
        return Positioned(
          bottom: 50,
          right: 16,
          child: PopupMessageWidget(
            popup: popup,
            onDismiss: () => notifier.dismissPopup(popup.id),
          ),
        );

      default:
        return Positioned(
          top: 50,
          left: 0,
          right: 0,
          child: PopupMessageWidget(
            popup: popup,
            onDismiss: () => notifier.dismissPopup(popup.id),
          ),
        );
    }
  }
}
