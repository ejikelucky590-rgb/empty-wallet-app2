import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileTimelineSection extends StatelessWidget {
  const ProfileTimelineSection({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Text('Please log in to view timeline.', style: TextStyle(color: Colors.grey)),
      ));
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: supabase
          .from('posts')
          .select('*, profiles(stage_name, username, avatar_url)')
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .then((value) => List<Map<String, dynamic>>.from(value))
          .catchError((_) => <Map<String, dynamic>>[]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(),
          ));
        }

        final posts = snapshot.data ?? [];
        
        // Dynamic Fallback if database table has no rows yet
        if (posts.isEmpty) {
          return FutureBuilder<Map<String, dynamic>?>(
            future: supabase.from('profiles').select('stage_name, avatar_url').eq('id', user.id).maybeSingle().catchError((_) => null),
            builder: (context, profileSnap) {
              final String name = profileSnap.data?['stage_name'] ?? 'New Creator';
              final String? avatar = profileSnap.data?['avatar_url'];
              
              return Column(
                children: [
                  ProfilePostCard(
                    time: 'Just now',
                    stageName: name,
                    avatarUrl: avatar,
                  ),
                  ProfilePostCard(
                    content: 'Thank you for the massive support on my music journey. Big things coming soon! 🕊️🦅',
                    time: 'Yesterday',
                    stageName: name,
                    avatarUrl: avatar,
                  ),
                ],
              );
            },
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            final profile = post['profiles'] as Map<String, dynamic>?;
            final String stageName = profile?['stage_name'] ?? 'New Creator';
            final String? avatarUrl = profile?['avatar_url'];

            return ProfilePostCard(
              content: post['content']?.toString() ?? '',
              time: 'Just now',
              stageName: stageName,
              avatarUrl: avatarUrl,
            );
          },
        );
      },
    );
  }
}

class ProfileMusicSection extends StatelessWidget {
  const ProfileMusicSection({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) return const SizedBox.shrink();

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: supabase
          .from('tracks')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .then((value) => List<Map<String, dynamic>>.from(value))
          .catchError((_) => <Map<String, dynamic>>[]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(),
          ));
        }

        final tracks = snapshot.data ?? [];
        
        // Dynamic Fallback tracks if database table has no uploads yet
        if (tracks.isEmpty) {
          return Column(
            children: const [
              MusicTrackCard(title: 'Lagos Vibe (Intro)', listeners: '0'),
              MusicTrackCard(title: 'No Daylight', listeners: '0'),
            ],
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: tracks.length,
          itemBuilder: (context, index) {
            final track = tracks[index];
            return MusicTrackCard(
              title: track['title']?.toString() ?? 'Untitled Track',
              listeners: track['plays_count']?.toString() ?? '0',
            );
          },
        );
      },
    );
  }
}

class ProfilePostCard extends StatelessWidget {
  final String content;
  final String time;
  final String stageName;
  final String? avatarUrl;

  const ProfilePostCard({
    super.key,
    required this.content,
    required this.time,
    required this.stageName,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: colors.primaryContainer,
                    backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                    child: avatarUrl == null
                        ? Icon(Icons.person, size: 20, color: colors.onPrimaryContainer)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colors.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stageName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: colors.outline,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            content,
            style: const TextStyle(
              height: 1.45,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 18),
          const ProfileReactionBar(),
        ],
      ),
    );
  }
}

class MusicTrackCard extends StatelessWidget {
  final String title;
  final String listeners;

  const MusicTrackCard({
    super.key,
    required this.title,
    required this.listeners,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 62,
            width: 62,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: colors.secondaryContainer,
            ),
            child: Icon(
              Icons.music_note,
              color: colors.onSecondaryContainer,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$listeners listens',
                  style: TextStyle(color: colors.outline),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.play_circle_fill),
            iconSize: 40,
          ),
        ],
      ),
    );
  }
}

class ProfileReactionBar Bars details...
class ProfileReactionBar extends StatelessWidget {
  const ProfileReactionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    Widget action(IconData icon, String label) {
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: colors.outline),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: colors.outline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        action(Icons.favorite_border, 'Like'),
        action(Icons.mode_comment_outlined, 'Comment'),
        action(Icons.share_outlined, 'Share'),
      ],
    );
  }
}