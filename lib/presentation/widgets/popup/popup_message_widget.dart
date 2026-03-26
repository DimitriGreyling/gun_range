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

    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.popup.isDismissible ? _handleDismiss : null,
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.popup.backgroundColor ?? const Color(0xFF1E1C1B),
            borderRadius: BorderRadius.circular(18),
            border: Border(
              left: BorderSide(
                color: _getBorderColor(),
                width: 6,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.28),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: _getBorderColor().withOpacity(0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: _buildIcon()),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            _statusLabel(),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: _getBorderColor(),
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ),
                        Text(
                          'Just now',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (widget.popup.showCloseButton) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: _handleDismiss,
                            icon: Icon(
                              Icons.close,
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 18,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 24,
                              minHeight: 24,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.popup.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: widget.popup.textColor ??
                            theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      widget.popup.message,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: (widget.popup.textColor ??
                                theme.colorScheme.onSurface)
                            .withOpacity(0.78),
                        height: 1.5,
                      ),
                    ),
                    if (widget.popup.actionText != null ||
                        widget.popup.secondaryActionText != null) ...[
                      const SizedBox(height: 16),
                      _buildButtonRow(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel() {
    switch (widget.popup.type) {
      case PopupType.success:
        return 'STATUS: CONFIRMED';
      case PopupType.warning:
        return 'STATUS: WARNING';
      case PopupType.error:
        return 'STATUS: ERROR';
      case PopupType.info:
        return 'STATUS: INFO';
      case PopupType.custom:
        return 'STATUS: UPDATE';
    }
  }

  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: widget.popup.secondaryActionText != null
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.end,
      children: [
        // Secondary button (left side)
        if (widget.popup.secondaryActionText != null) ...[
          ElevatedButton(
            style: ButtonStyle(
              elevation: WidgetStateProperty.all(0),
              backgroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.secondary.withOpacity(0.8),
              ),
            ),
            onPressed: () {
              widget.popup.onSecondaryAction?.call();
              if (widget.popup.dismissOnSecondaryAction ?? true) {
                _handleDismiss();
              }
            },
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
            style: ButtonStyle(
              elevation: WidgetStateProperty.all(0),
              backgroundColor: WidgetStateProperty.all(
                _getBorderColor().withOpacity(0.8),
              ),
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
        return Colors.green.shade50.withOpacity(0.7);
      case PopupType.warning:
        return Colors.orange.shade50.withOpacity(0.7);
      case PopupType.error:
        return Colors.red.shade50.withOpacity(0.7);
      case PopupType.info:
      default:
        return Colors.blue.shade50.withOpacity(0.7);
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
