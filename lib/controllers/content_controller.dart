import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/content_model.dart';
import '../repositories/content_repository.dart';

enum ContentType { post, reel, track }

final contentProvider = FutureProvider.family<List<ContentModel>, ContentType>((ref, type) async {
  return await ContentRepository.instance.fetchContentByType(type.name);
});
