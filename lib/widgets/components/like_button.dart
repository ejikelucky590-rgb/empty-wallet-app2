import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LikeButton extends StatefulWidget {
  final bool isLiked;
  final int likeCount;
  final bool isLoading;
  final ValueChanged<bool> onLikeToggled;

  const LikeButton({
    super.key,
    required this.isLiked,
    required this.likeCount,
    required this.onLikeToggled,
    this.isLoading = false,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  static const _animationDuration = Duration(milliseconds: 160);
  static const _iconSize = 24.0;
  static const _spacing = 8.0;
  static const _maxScale = 1.22;

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
      lowerBound: 1.0,
      upperBound: _maxScale,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.isLoading) return;

    HapticFeedback.lightImpact();

    await _controller.forward();
    await _controller.reverse();

    widget.onLikeToggled(!widget.isLiked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    final foregroundColor = widget.isLiked
        ? colors.primary
        : colors.onSurfaceVariant;

    return Semantics(
      button: true,
      enabled: !widget.isLoading,
      label: widget.isLiked ? 'Unlike content' : 'Like content',
      value: '${widget.likeCount} likes',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: widget.isLoading ? null : _handleTap,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: AnimatedSwitcher(
                    duration: _animationDuration,
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: widget.isLoading
                        ? SizedBox(
                            key: const ValueKey('loading'),
                            width: _iconSize,
                            height: _iconSize,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                foregroundColor,
                              ),
                            ),
                          )
                        : Icon(
                            widget.isLiked
                                ? Icons.thumb_up_alt_rounded
                                : Icons.thumb_up_off_alt_outlined,
                            key: ValueKey(widget.isLiked),
                            color: foregroundColor,
                            size: _iconSize,
                          ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: _spacing),
          AnimatedSwitcher(
            duration: _animationDuration,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              '${widget.likeCount}',
              key: ValueKey(widget.likeCount),
              style: textTheme.labelLarge?.copyWith(
                color: foregroundColor,
                fontWeight: widget.isLiked ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
