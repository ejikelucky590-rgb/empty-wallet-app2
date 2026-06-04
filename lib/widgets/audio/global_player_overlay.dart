import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'global_player_bar.dart';

class GlobalPlayerOverlay extends ConsumerWidget {
  final Widget child;
  const GlobalPlayerOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        // Content with bottom padding so player doesn't block UI
        Padding(
          padding: const EdgeInsets.only(bottom: 72),
          child: child,
        ),
        // Global Player pinned with SafeArea
        Positioned(
          left: 0, 
          right: 0, 
          bottom: 0,
          child: SafeArea(
            top: false,
            child: const GlobalPlayerBar(),
          ),
        ),
      ],
    );
  }
}
