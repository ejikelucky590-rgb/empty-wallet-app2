import 'package:flutter/material.dart';

class ProfileTimelineSection extends StatelessWidget {
  const ProfileTimelineSection({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      {
        'time': 'Just now',
        'content': 'Cooking a fire new Afro-beats track in the studio today 🔥',
      },
      {
        'time': 'Yesterday',
        'content': 'Thank you for the love on my latest release ❤️',
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return ProfilePostCard(
          content: post['content'].toString(),
          time: post['time'].toString(),
        );
      },
    );
  }
}

class ProfileMusicSection extends StatelessWidget {
  const ProfileMusicSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tracks = [
      {
        'title': 'Lagos Vibe',
        'listeners': '4.8K',
      },
      {
        'title': 'No Daylight',
        'listeners': '12.1K',
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        final track = tracks[index];
        return MusicTrackCard(
          title: track['title'].toString(),
          listeners: track['listeners'].toString(),
        );
      },
    );
  }
}

class ProfilePostCard extends StatelessWidget {
  final String content;
  final String time;

  const ProfilePostCard({
    super.key,
    required this.content,
    required this.time,
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
              CircleAvatar(
                radius: 20,
                backgroundColor: colors.primaryContainer,
                child: Icon(
                  Icons.person,
                  size: 20,
                  color: colors.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dove Artist',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
                  ' listens',
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