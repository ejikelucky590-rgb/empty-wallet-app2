import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/profile_model.dart';
import '../../controllers/profile_controller.dart';
import 'cached_profile_avatar.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileModel profile;

  const ProfileHeader({
    super.key,
    required this.profile,
  });

  String _format(int v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toString();
  }

  Future<void> _pickAndUploadAvatar(BuildContext context) async {
    final picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
        maxWidth: 500,
      );

      if (pickedFile == null) return;

      final success = await ProfileController.instance.handleAvatarUpload(File(pickedFile.path));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Avatar uploaded successfully!' : 'Saved locally. Syncing in background...'),
            backgroundColor: success ? Colors.green : Colors.amber[800],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error accessing library: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return StreamBuilder<ProfileState>(
      stream: ProfileController.instance.stream,
      builder: (context, snapshot) {
        final state = snapshot.data ?? ProfileController.instance.state;
        final p = state.profile ?? profile;

        return Column(
          children: [
            const SizedBox(height: 16),

            /// IMAGE SELECTOR INTERACTION PIPELINE
            GestureDetector(
              onTap: () => _pickAndUploadAvatar(context),
              child: Stack(
                children: [
                  Opacity(
                    opacity: state.loading ? 0.6 : 1.0,
                    child: CachedProfileAvatar(
                      avatarUrl: p.avatarUrl,
                      radius: 46,
                    ),
                  ),
                  if (state.loading)
                    const Positioned.fill(
                      child: Center(child: CircularProgressIndicator(strokeWidth: 3)),
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.surface, width: 2),
                      ),
                      child: Icon(Icons.camera_alt_rounded, size: 14, color: colors.onPrimary),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Text(
              p.stageName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.4),
            ),

            const SizedBox(height: 4),

            Text(
              '@${p.username}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: colors.outline, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text('Active now', style: theme.textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant, fontWeight: FontWeight.w600)),
              ],
            ),

            const SizedBox(height: 12),

            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Text(
                p.bio,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurfaceVariant, height: 1.5, fontWeight: FontWeight.w500),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(value: _format(p.followersCount), label: 'Followers'),
                _StatItem(value: _format(p.followingCount), label: 'Following'),
                _StatItem(value: _format(p.postsCount), label: 'Posts'),
              ],
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Profile Strength', style: theme.textTheme.labelSmall?.copyWith(color: colors.outline, fontWeight: FontWeight.bold)),
                      Text('${(state.completion * 100).toInt()}%', style: theme.textTheme.labelSmall?.copyWith(color: colors.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: state.completion,
                      minHeight: 6,
                      backgroundColor: colors.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(state.completion >= 1.0 ? Colors.green : colors.primary),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.analytics_outlined, color: colors.primary, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Profile Exposure', style: theme.textTheme.labelMedium?.copyWith(color: colors.outline, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text('${p.profileViews} views accumulated', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: colors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                      child: Text('Live', style: theme.textTheme.labelSmall?.copyWith(color: colors.primary, fontWeight: FontWeight.bold)),
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

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: colors.onSurfaceVariant, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
