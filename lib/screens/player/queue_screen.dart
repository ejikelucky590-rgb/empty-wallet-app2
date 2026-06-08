import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/audio_controller.dart';

class QueueScreen extends ConsumerWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audio = ref.watch(audioControllerProvider);
    final controller = ref.read(audioControllerProvider.notifier);

    final queue = audio.queue;

    return Scaffold(
      appBar: AppBar(title: const Text("Up Next")),
      body: queue.isEmpty
          ? const Center(child: Text("No songs in queue"))
          : ListView.builder(
              itemCount: queue.length,
              itemBuilder: (context, index) {
                final track = queue[index];

                final isCurrent =
                    audio.currentTrack?.id == track.id;

                return ListTile(
                  leading: const Icon(Icons.music_note),
                  title: Text(track.title),
                  subtitle: Text(track.profile?['username'] ?? ''),
                  trailing:
                      isCurrent ? const Icon(Icons.play_arrow) : null,
                  onTap: () {
                    controller.playTrack(track, queue: queue);
                  },
                );
              },
            ),
    );
  }
}
