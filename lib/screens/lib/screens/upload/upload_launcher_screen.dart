import 'package:flutter/material.dart';

import 'upload_post_screen.dart';
import 'upload_reel_screen.dart';
import 'upload_track_screen.dart';

class UploadLauncherScreen extends StatelessWidget {
  const UploadLauncherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _CreateTile(
              icon: Icons.library_music,
              title: 'Upload Track',
              subtitle: 'Publish music to Hub',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UploadTrackScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            _CreateTile(
              icon: Icons.article_outlined,
              title: 'Create Post',
              subtitle: 'Share updates with followers',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UploadPostScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            _CreateTile(
              icon: Icons.video_collection_outlined,
              title: 'Upload Reel',
              subtitle: 'Share short-form video',
              onTap: () {
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

class _CreateTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CreateTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
