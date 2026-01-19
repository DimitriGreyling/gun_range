import 'package:flutter/material.dart';

enum PopupType {
  info,
  success,
  warning,
  error,
  custom,
}

enum PopupPosition {
  top,
  center,
  bottom,
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

class PopupMessage {
  final String id;
  final String title;
  final String message;
  final PopupType type;
  final PopupPosition position;
  final Duration duration;
  final bool isDismissible;
  final bool showCloseButton;
  final String? actionText;
  final String? secondaryActionText;
  final VoidCallback? onAction;
  final VoidCallback? onSecondaryAction;
  final bool? dismissOnSecondaryAction;
  final VoidCallback? onDismiss;
  final bool? dismissOnAction;
  final Widget? customIcon;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? customContent;

  PopupMessage({
    String? id,
    required this.title,
    required this.message,
    this.type = PopupType.info,
    this.position = PopupPosition.top,
    this.duration = const Duration(seconds: 3),
    this.isDismissible = true,
    this.showCloseButton = true,
    this.actionText,
    this.onAction,
    this.onDismiss,
    this.customIcon,
    this.backgroundColor,
    this.textColor,
    this.customContent,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.dismissOnSecondaryAction,
    this.dismissOnAction = true,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  PopupMessage copyWith({
    String? id,
    String? title,
    String? message,
    PopupType? type,
    PopupPosition? position,
    Duration? duration,
    bool? isDismissible,
    bool? showCloseButton,
    String? actionText,
    VoidCallback? onAction,
    VoidCallback? onDismiss,
    Widget? customIcon,
    Color? backgroundColor,
    Color? textColor,
    Widget? customContent,
    String? secondaryActionText,
    VoidCallback? onSecondaryAction,
    bool? dismissOnSecondaryAction,
    bool? dismissOnAction,
  }) {
    return PopupMessage(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isDismissible: isDismissible ?? this.isDismissible,
      showCloseButton: showCloseButton ?? this.showCloseButton,
      actionText: actionText ?? this.actionText,
      onAction: onAction ?? this.onAction,
      onDismiss: onDismiss ?? this.onDismiss,
      customIcon: customIcon ?? this.customIcon,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      customContent: customContent ?? this.customContent,
      secondaryActionText: secondaryActionText ?? this.secondaryActionText,
      onSecondaryAction: onSecondaryAction ?? this.onSecondaryAction,
      dismissOnSecondaryAction: dismissOnSecondaryAction ?? this.dismissOnSecondaryAction,
      dismissOnAction: dismissOnAction ?? this.dismissOnAction,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PopupMessage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}