import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/content_model.dart';
import '../repositories/hub_repository.dart';

final hubFeedProvider = FutureProvider<List<ContentModel>>((ref) async {
  return HubRepository.instance.fetchHubTracks();
});

final trendingProvider = FutureProvider<List<ContentModel>>((ref) async {
  return HubRepository.instance.fetchTrendingTracks();
});
