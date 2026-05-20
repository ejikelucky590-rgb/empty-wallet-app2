import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class MediaGrid extends StatelessWidget {
  final List<Map<String, dynamic>> posts;
  final ScrollController controller;
  final bool isVideo;
  final bool isPaginating;

  const MediaGrid({
    super.key,
    required this.posts,
    required this.controller,
    required this.isVideo,
    required this.isPaginating,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isVideo ? Icons.video_collection_outlined : Icons.music_off,
              size: 70,
              color: theme.disabledColor,
            ),
            const SizedBox(height: 12),
            Text(
              isVideo ? "No videos yet" : "No music uploaded yet",
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      controller: controller,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: posts.length + (isPaginating ? 3 : 0),
      itemBuilder: (context, index) {
        if (index >= posts.length) {
          return Shimmer.fromColors(
            baseColor: theme.cardColor,
            highlightColor: theme.scaffoldBackgroundColor,
            child: Container(color: theme.cardColor),
          );
        }

        final post = posts[index];

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: post["thumbnail"],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: theme.cardColor),
                  errorWidget: (context, url, error) => Container(
                    color: theme.cardColor,
                    child: const Icon(Icons.broken_image),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  left: 6,
                  child: Row(
                    children: [
                      const Icon(Icons.play_arrow, size: 14, color: Colors.white),
                      const SizedBox(width: 2),
                      Text(
                        post["views"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
