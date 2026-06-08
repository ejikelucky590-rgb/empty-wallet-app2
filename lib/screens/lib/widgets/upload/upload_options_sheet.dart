import 'package:flutter/material.dart';

import '../../screens/upload/upload_post_screen.dart';
import '../../screens/upload/upload_reel_screen.dart';
import '../../screens/upload/upload_track_screen.dart';

class UploadOptionsSheet extends StatelessWidget {
  const UploadOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create',
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 24),

            _OptionTile(
              icon: Icons.library_music_rounded,
              title: 'Upload Track',
              subtitle: 'Publish music to Hub',
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UploadTrackScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            _OptionTile(
              icon: Icons.article_outlined,
              title: 'Create Post',
              subtitle: 'Share updates with followers',
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UploadPostScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            _OptionTile(
              icon: Icons.video_collection_outlined,
              title: 'Upload Reel',
              subtitle: 'Share short-form video',
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UploadReelScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, size: 32),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        onTap: onTap,
      ),
    );
  }
}
