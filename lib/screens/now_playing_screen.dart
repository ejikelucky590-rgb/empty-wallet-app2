import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/audio_controller.dart';

class NowPlayingScreen extends ConsumerWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioControllerProvider);
    final track = state.currentTrack;

    if (track == null) {
      return const Scaffold(
        body: Center(child: Text("No music playing")),
      );
    }

    final progress = state.duration.inMilliseconds == 0
        ? 0
        : state.position.inMilliseconds /
            state.duration.inMilliseconds;

    return Scaffold(
      appBar: AppBar(title: const Text("Now Playing")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 90,
            backgroundImage: track.thumbnailUrl != null
                ? NetworkImage(track.thumbnailUrl!)
                : null,
          ),
          const SizedBox(height: 20),
          Text(track.title,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold)),
          Text(track.profile?['username'] ?? ''),
          Slider(
            value: progress.clamp(0.0, 1.0),
            onChanged: (value) {
              final pos = Duration(
                milliseconds:
                    (value * state.duration.inMilliseconds).toInt(),
              );
              ref
                  .read(audioControllerProvider.notifier)
                  .seek(pos);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: () => ref
                    .read(audioControllerProvider.notifier)
                    .playPrevious(),
              ),
              IconButton(
                icon: Icon(
                  state.isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 40,
                ),
                onPressed: () => ref
                    .read(audioControllerProvider.notifier)
                    .togglePlayPause(),
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: () => ref
                    .read(audioControllerProvider.notifier)
                    .playNext(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
