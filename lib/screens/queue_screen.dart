import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/audio_controller.dart';

class QueueScreen extends ConsumerWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Queue")),
      body: ListView.builder(
        itemCount: state.queue.length,
        itemBuilder: (context, index) {
          final track = state.queue[index];
          final isCurrent = state.currentTrack?.id == track.id;

          return ListTile(
            leading: const Icon(Icons.music_note),
            title: Text(track.title),
            subtitle: Text(track.profile?['username'] ?? ''),
            trailing:
                isCurrent ? const Icon(Icons.play_arrow) : null,
            onTap: () {
              ref
                  .read(audioControllerProvider.notifier)
                  .playTrack(track);
            },
          );
        },
      ),
    );
  }
}
