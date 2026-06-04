import 'package:flutter/material.dart';
import '../../models/profile_model.dart';
import '../../controllers/social_controller.dart';

class ProfileStats extends StatefulWidget {
  final ProfileModel profile;

  const ProfileStats({super.key, required this.profile});

  @override
  State<ProfileStats> createState() => _ProfileStatsState();
}

class _ProfileStatsState extends State<ProfileStats> {
  bool _isFollowing = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final status = await SocialController().isFollowing(widget.profile.id);
    if (mounted) {
      setState(() {
        _isFollowing = status;
        _loading = false;
      });
    }
  }

  String _formatCount(int value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StatItem(value: _formatCount(widget.profile.followersCount), label: 'Followers'),
            _StatItem(value: _formatCount(widget.profile.followingCount), label: 'Following'),
            _StatItem(value: _formatCount(widget.profile.postsCount), label: 'Posts'),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _loading ? null : () async {
              final newState = await SocialController().toggleFollow(widget.profile.id);
              setState(() => _isFollowing = newState);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFollowing ? colors.outlineVariant : colors.primary,
              foregroundColor: _isFollowing ? colors.onSurface : colors.onPrimary,
            ),
            child: Text(_isFollowing ? 'Following' : 'Follow'),
          ),
        ),
      ],
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
