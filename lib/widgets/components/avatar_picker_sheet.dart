import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AvatarPickerSheet extends StatelessWidget {
  final bool hasCurrentAvatar;
  final bool isLoading;

  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  final VoidCallback? onRemoveTap;

  const AvatarPickerSheet({
    super.key,
    required this.hasCurrentAvatar,
    required this.onCameraTap,
    required this.onGalleryTap,
    this.onRemoveTap,
    this.isLoading = false,
  });

  static const _sheetRadius = 28.0;
  static const _iconSize = 28.0;
  static const _animationDuration = Duration(milliseconds: 220);

  void _handleAction(
    BuildContext context,
    VoidCallback action,
  ) {
    if (isLoading) return;

    HapticFeedback.mediumImpact();

    Navigator.of(context).pop();

    Future.microtask(action);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SafeArea(
      top: false,
      child: AnimatedContainer(
        duration: _animationDuration,
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 14,
          bottom: MediaQuery.of(context).padding.bottom + 20,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(_sheetRadius),
          ),
          border: Border.all(
            color: colors.outlineVariant.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 30,
              spreadRadius: 0,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: colors.onSurfaceVariant.withOpacity(0.35),
                borderRadius: BorderRadius.circular(100),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Profile Photo',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Choose how you want to update your avatar.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 28),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _AvatarActionButton(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    color: colors.primary,
                    isLoading: isLoading,
                    onTap: () => _handleAction(
                      context,
                      onCameraTap,
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: _AvatarActionButton(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    color: colors.primary,
                    isLoading: isLoading,
                    onTap: () => _handleAction(
                      context,
                      onGalleryTap,
                    ),
                  ),
                ),

                if (hasCurrentAvatar && onRemoveTap != null) ...[
                  const SizedBox(width: 14),

                  Expanded(
                    child: _AvatarActionButton(
                      icon: Icons.delete_rounded,
                      label: 'Remove',
                      color: colors.error,
                      isLoading: isLoading,
                      onTap: () => _handleAction(
                        context,
                        onRemoveTap!,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isLoading;

  const _AvatarActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.isLoading,
  });

  @override
  State<_AvatarActionButton> createState() =>
      _AvatarActionButtonState();
}

class _AvatarActionButtonState
    extends State<_AvatarActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
      },
      onTapCancel: () {
        setState(() => _pressed = false);
      },
      onTap: widget.isLoading ? null : widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 14,
          ),
          decoration: BoxDecoration(
            color: widget.color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: widget.color.withOpacity(0.12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: widget.isLoading
                    ? SizedBox(
                        key: const ValueKey('loader'),
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: widget.color,
                        ),
                      )
                    : Icon(
                        widget.icon,
                        key: ValueKey(widget.icon),
                        color: widget.color,
                        size: 28,
                      ),
              ),

              const SizedBox(height: 10),

              Text(
                widget.label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
