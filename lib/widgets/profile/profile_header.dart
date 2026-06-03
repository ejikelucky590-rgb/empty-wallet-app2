import 'package:flutter/material.dart';
import '../../models/profile_model.dart';
import '../../controllers/profile_controller.dart';
import 'cached_profile_avatar.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileModel profile;

  const ProfileHeader({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final controller = ProfileController.instance;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        // Read live from the controller to make optimistic updates work instantly
        final liveProfile = controller.profile ?? profile;
        final completionScore = controller.completionScore;

        return Column(
          children: [
            const SizedBox(height: 16),

            /// AVATAR (cached + performant)
            CachedProfileAvatar(
              avatarUrl: liveProfile.avatarUrl,
              radius: 46,
            ),

            const SizedBox(height: 14),

            /// NAME
            Text(
              liveProfile.stageName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),

            const SizedBox(height: 4),

            /// USERNAME
            Text(
              '@${liveProfile.username}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colors.outline,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 12),

            /// PROFILE STRENGTH (REACTIVE)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Profile Strength',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.outline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${(completionScore * 100).toInt()}%',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: completionScore,
                      minHeight: 6,
                      backgroundColor: colors.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        completionScore >= 1.0
                            ? Colors.green
                            : colors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// ANALYTICS PANEL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colors.outlineVariant.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.analytics_outlined,
                        color: colors.primary, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Profile Exposure',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colors.outline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${liveProfile.profileViews} views accumulated',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// LIVE BADGE
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Live',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
