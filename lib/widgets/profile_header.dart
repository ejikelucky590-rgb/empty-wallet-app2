import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String displayName;
  final String bio;
  final String profilePic;
  final int following;
  final int followers;
  final int likesCount;
  final bool isFollowing;
  final bool isVerified;
  final VoidCallback onToggleFollow;

  const ProfileHeader({
    super.key,
    required this.username,
    required this.displayName,
    required this.bio,
    required this.profilePic,
    required this.following,
    required this.followers,
    required this.likesCount,
    required this.isFollowing,
    required this.isVerified,
    required this.onToggleFollow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 16),
        Hero(
          tag: "profile-avatar",
          child: CircleAvatar(
            radius: 50,
            backgroundColor: theme.colorScheme.primary.withAlpha(30),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: profilePic,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: theme.cardColor),
                errorWidget: (context, url, error) => const Icon(Icons.person, size: 40),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          username,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.disabledColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMetricColumn(context, following.toString(), "Following"),
            _buildDivider(theme.dividerColor),
            _buildMetricColumn(context, "${(followers / 1000).toStringAsFixed(1)}K", "Followers"),
            _buildDivider(theme.dividerColor),
            _buildMetricColumn(context, "${(likesCount / 1000).toStringAsFixed(1)}K", "Likes"),
          ],
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onToggleFollow,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: isFollowing ? theme.cardColor : theme.colorScheme.primary,
                    foregroundColor: isFollowing ? theme.textTheme.bodyLarge?.color : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: Text(isFollowing ? "Following" : "Follow"),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.dividerColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: Text("Edit Profile", style: theme.textTheme.labelLarge),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.share_outlined),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(bio, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMetricColumn(BuildContext context, String count, String label) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(count, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.disabledColor)),
        ],
      ),
    );
  }

  Widget _buildDivider(Color color) {
    return Container(height: 16, width: 1, color: color);
  }
}
