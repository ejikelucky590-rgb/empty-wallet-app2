import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../models/content_model.dart';
import '../controllers/audio_controller.dart';
import '../repositories/content_repository.dart';

class ContentCard extends ConsumerStatefulWidget {
  final ContentModel content;
  final List<ContentModel> feed;

  const ContentCard({
    super.key,
    required this.content,
    required this.feed,
  });

  @override
  ConsumerState<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends ConsumerState<ContentCard> {
  bool _hasPlayed = false;

  void _play() {
    final audio = ref.read(audioControllerProvider.notifier);
    ContentRepository.instance.incrementView(widget.content.id);
    audio.playTrack(widget.content, queue: widget.feed);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(audioControllerProvider);
    final isPlaying = state.currentTrack?.id == widget.content.id;

    return VisibilityDetector(
      key: Key(widget.content.id),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.7 && !_hasPlayed) {
          _play();
          _hasPlayed = true;
        }
      },
      child: GestureDetector(
        onTap: _play,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    widget.content.thumbnailUrl ?? 'https://via.placeholder.com/300',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  if (isPlaying)
                    Positioned(
                      top: 10, right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(20)),
                        child: const Text("Playing", style: TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(widget.content.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
