import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FollowButton extends StatelessWidget {
  final bool isFollowing;
  final bool isLoading;
  final VoidCallback onTap;

  const FollowButton({
    super.key,
    required this.isFollowing,
    this.isLoading = false,
    required this.onTap,
  });

  static const _animationDuration = Duration(milliseconds: 220);
  static const _buttonHeight = 42.0;
  static const _minButtonWidth = 120.0;
  static const _iconSize = 18.0;
  static const _loaderSize = 18.0;
  static const _borderRadius = 999.0;

  Future<void> _handleTap() async {
    HapticFeedback.lightImpact();
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    final backgroundColor = isFollowing
        ? colors.surfaceContainerHighest
        : colors.primary;

    final foregroundColor = isFollowing
        ? colors.onSurfaceVariant
        : colors.onPrimary;

    final borderColor = isFollowing
        ? colors.outlineVariant
        : colors.primary;

    return Semantics(
      button: true,
      enabled: !isLoading,
      label: isFollowing ? 'Following user' : 'Follow user',
      child: AnimatedContainer(
        duration: _animationDuration,
        curve: Curves.easeOutCubic,
        constraints: const BoxConstraints(
          minWidth: _minButtonWidth,
          minHeight: _buttonHeight,
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : _handleTap,
          style: ElevatedButton.styleFrom(
            elevation: isFollowing ? 0 : 1,
            shadowColor: Colors.transparent,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            disabledBackgroundColor: colors.surfaceContainerHighest.withOpacity(0.7),
            disabledForegroundColor: colors.onSurface.withOpacity(0.4),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
              side: BorderSide(
                color: borderColor.withOpacity(isFollowing ? 0.7 : 1),
              ),
            ),
            textStyle: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          child: AnimatedSwitcher(
            duration: _animationDuration,
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              );
            },
            child: isLoading
                ? SizedBox(
                    key: const ValueKey('loading'),
                    width: _loaderSize,
                    height: _loaderSize,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        foregroundColor,
                      ),
                    ),
                  )
                : Row(
                    key: ValueKey(isFollowing),
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isFollowing
                            ? Icons.check_rounded
                            : Icons.person_add_alt_1_rounded,
                        size: _iconSize,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          isFollowing ? 'Following' : 'Follow',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
