import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/audio_controller.dart';
import '../screens/player/full_player_screen.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioControllerProvider);
    final controller = ref.read(audioControllerProvider.notifier);

    final track = state.currentTrack;

    // 🚨 Hide if nothing is playing
    if (track == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const FullPlayerScreen(),
          ),
        );
      },
      child: Container(
        height: 65,
        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          children: [

            // 🎵 COVER
            Container(
              width: 55,
              height: 55,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(
                    track.thumbnail_url ??
                        'https://via.placeholder.com/150',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: 8),

            // 🎧 TITLE + ARTIST
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    track.profile?['username'] ?? 'Unknown Artist',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // ⏯ PLAY / PAUSE
            IconButton(
              icon: Icon(
                state.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: () {
                controller.toggle();
              },
            ),
          ],
        ),
      ),
    );
  }
}
