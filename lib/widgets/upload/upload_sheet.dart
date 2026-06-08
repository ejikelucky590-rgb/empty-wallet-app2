import 'package:flutter/material.dart';

import '../../screens/upload/upload_track_screen.dart';
import '../../screens/upload/upload_reel_screen.dart';
import '../../screens/upload/create_post_screen.dart';

class UploadSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "Create",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              _OptionTile(
                icon: Icons.music_note,
                title: "Upload Track",
                subtitle: "Share your music",
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

              _OptionTile(
                icon: Icons.video_library,
                title: "Upload Reel",
                subtitle: "Short video content",
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

              _OptionTile(
                icon: Icons.post_add,
                title: "Create Post",
                subtitle: "Text or image post",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreatePostScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
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
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      onTap: onTap,
    );
  }
}
