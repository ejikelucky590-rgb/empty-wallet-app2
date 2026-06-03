import 'package:flutter/material.dart';

class CachedProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double radius;

  const CachedProfileAvatar({
    super.key,
    required this.avatarUrl,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hasAvatar = avatarUrl != null && avatarUrl!.trim().isNotEmpty;

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.primaryContainer,
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.25),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: hasAvatar
            ? Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildPlaceholder(colors),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _buildLoadingState(colors);
                },
              )
            : _buildPlaceholder(colors),
      ),
    );
  }

  Widget _buildPlaceholder(ColorScheme colors) {
    return Icon(
      Icons.person_rounded,
      size: radius * 1.1,
      color: colors.onPrimaryContainer,
    );
  }

  Widget _buildLoadingState(ColorScheme colors) {
    return Center(
      child: SizedBox(
        width: radius * 0.5,
        height: radius * 0.5,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: colors.primary,
        ),
      ),
    );
  }
}
