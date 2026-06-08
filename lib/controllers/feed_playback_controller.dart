import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/content_model.dart';
import 'audio_controller.dart';

class FeedPlaybackController extends Notifier<List<ContentModel>> {
  @override
  List<ContentModel> build() {
    return [];
  }

  void setFeed(List<ContentModel> feed) {
    state = feed;
  }

  void playAtIndex(int index, WidgetRef ref) {
    if (index < 0 || index >= state.length) return;

    final audio = ref.read(audioControllerProvider.notifier);

    final current = state[index];

    audio.playTrack(
      current,
      queue: state, // 🔥 full feed becomes queue
    );
  }

  ContentModel? nextAfter(ContentModel current) {
    final index = state.indexWhere((e) => e.id == current.id);

    if (index == -1 || index + 1 >= state.length) return null;

    return state[index + 1];
  }
}
