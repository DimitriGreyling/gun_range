import 'package:flutter/material.dart';
import 'package:gun_range_app/data/models/popup_position.dart';


class PopupMessageWidget extends StatefulWidget {
  final PopupMessage popup;
  final VoidCallback onDismiss;

  const PopupMessageWidget({
    super.key,
    required this.popup,
    required this.onDismiss,
  });

  @override
  State<PopupMessageWidget> createState() => _PopupMessageWidgetState();
}

class _PopupMessageWidgetState extends State<PopupMessageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: _getSlideOffset(),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  Offset _getSlideOffset() {
    switch (widget.popup.position) {
      case PopupPosition.top:
        return const Offset(0, -1);
      case PopupPosition.bottom:
        return const Offset(0, 1);
      case PopupPosition.topLeft:
        return const Offset(-1, -1);
      case PopupPosition.topRight:
        return const Offset(1, -1);
      case PopupPosition.bottomLeft:
        return const Offset(-1, 1);
      case PopupPosition.bottomRight:
        return const Offset(1, 1);
      default:
        return const Offset(0, -0.5);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDismiss() async {
    // Call the popup's onDismiss callback first if it exists
    widget.popup.onDismiss?.call();

    await _animationController.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SlideTransition(
            position: _slideAnimation,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: _buildPopupContent(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopupContent() {
    if (widget.popup.customContent != null) {
      return widget.popup.customContent!;
    }

    return GestureDetector(
      onTap: widget.popup.isDismissible ? _handleDismiss : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.popup.backgroundColor ?? _getBackgroundColor(),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: _getBorderColor().withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            _buildIcon(),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.popup.title,
                    style: TextStyle(
                      color: widget.popup.textColor ?? _getTextColor(),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.popup.message,
                    style: TextStyle(
                      color: (widget.popup.textColor ?? _getTextColor())
                          .withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  // Updated button layout - check for both action buttons
                  if (widget.popup.actionText != null ||
                      widget.popup.secondaryActionText != null) ...[
                    const SizedBox(height: 12),
                    _buildButtonRow(),
                  ],
                ],
              ),
            ),

            // Close button
            if (widget.popup.showCloseButton)
              IconButton(
                onPressed: _handleDismiss,
                icon: Icon(
                  Icons.close,
                  color: (widget.popup.textColor ?? _getTextColor())
                      .withOpacity(0.6),
                  size: 18,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: widget.popup.secondaryActionText != null
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.end,
      children: [
        // Secondary button (left side)
        if (widget.popup.secondaryActionText != null) ...[
          OutlinedButton(
            onPressed: () {
              widget.popup.onSecondaryAction?.call();
              if (widget.popup.dismissOnSecondaryAction ?? true) {
                _handleDismiss();
              }
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: _getBorderColor(),
              side: BorderSide(color: _getBorderColor()),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: Text(widget.popup.secondaryActionText!),
          ),
          const SizedBox(width: 8),
        ],

        // Primary button (right side)
        if (widget.popup.actionText != null)
          ElevatedButton(
            onPressed: () {
              widget.popup.onAction?.call();
              if (widget.popup.dismissOnAction ?? true) {
                _handleDismiss();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _getBorderColor(),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: Text(widget.popup.actionText!),
          ),
      ],
    );
  }

  Widget _buildIcon() {
    if (widget.popup.customIcon != null) {
      return widget.popup.customIcon!;
    }

    IconData iconData;
    switch (widget.popup.type) {
      case PopupType.success:
        iconData = Icons.check_circle;
        break;
      case PopupType.warning:
        iconData = Icons.warning;
        break;
      case PopupType.error:
        iconData = Icons.error;
        break;
      case PopupType.info:
      default:
        iconData = Icons.info;
        break;
    }

    return Icon(
      iconData,
      color: _getBorderColor(),
      size: 24,
    );
  }

  Color _getBackgroundColor() {
    switch (widget.popup.type) {
      case PopupType.success:
        return Colors.green.shade50;
      case PopupType.warning:
        return Colors.orange.shade50;
      case PopupType.error:
        return Colors.red.shade50;
      case PopupType.info:
      default:
        return Colors.blue.shade50;
    }
  }

  Color _getBorderColor() {
    switch (widget.popup.type) {
      case PopupType.success:
        return Colors.green;
      case PopupType.warning:
        return Colors.orange;
      case PopupType.error:
        return Colors.red;
      case PopupType.info:
      default:
        return Colors.blue;
    }
  }

  Color _getTextColor() {
    switch (widget.popup.type) {
      case PopupType.success:
        return Colors.green.shade800;
      case PopupType.warning:
        return Colors.orange.shade800;
      case PopupType.error:
        return Colors.red.shade800;
      case PopupType.info:
      default:
        return Colors.blue.shade800;
    }
  }
}
