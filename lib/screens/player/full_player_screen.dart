import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/audio_controller.dart';
import 'queue_screen.dart';

class FullPlayerScreen extends ConsumerWidget {
  const FullPlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audio = ref.watch(audioControllerProvider);
    final controller = ref.read(audioControllerProvider.notifier);

    final track = audio.currentTrack;

    if (track == null) {
      return const Scaffold(
        body: Center(child: Text("No track playing")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 20),

            // COVER ART
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(track.thumbnail_url ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              track.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              track.profile?['username'] ?? 'Unknown Artist',
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // PROGRESS
            Slider(
              value: audio.position.inSeconds.toDouble(),
              max: audio.duration.inSeconds == 0
                  ? 1
                  : audio.duration.inSeconds.toDouble(),
              onChanged: (value) {
                controller.seek(Duration(seconds: value.toInt()));
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_fmt(audio.position), style: const TextStyle(color: Colors.grey)),
                Text(_fmt(audio.duration), style: const TextStyle(color: Colors.grey)),
              ],
            ),

            const SizedBox(height: 20),

            // CONTROLS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                IconButton(
                  icon: const Icon(Icons.queue_music, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QueueScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(width: 20),

                IconButton(
                  icon: const Icon(Icons.skip_previous, color: Colors.white),
                  onPressed: () {},
                ),

                const SizedBox(width: 20),

                GestureDetector(
                  onTap: controller.toggle,
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      audio.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.black,
                      size: 35,
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                IconButton(
                  icon: const Icon(Icons.skip_next, color: Colors.white),
                  onPressed: controller.playNext,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return "$m:${s.toString().padLeft(2, '0')}";
  }
}
