import 'package:flutter/material.dart';

import 'mini_player.dart';
import '../screens/main_navigation.dart';

class MiniPlayerWrapper extends StatelessWidget {
  const MiniPlayerWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const MiniPlayer(),

        NavigationBar(
          selectedIndex: 0,
          onDestinationSelected: (index) {
            // We forward navigation to MainNavigation state
            final state = context.findAncestorStateOfType<
                _MainNavigationState>();

            state?._onDestinationSelected(index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Hub',
            ),
            NavigationDestination(
              icon: Icon(Icons.music_note_outlined),
              selectedIcon: Icon(Icons.music_note),
              label: 'Waive',
            ),
            NavigationDestination(
              icon: Icon(Icons.add_box_outlined),
              selectedIcon: Icon(Icons.add_box),
              label: 'Upload',
            ),
            NavigationDestination(
              icon: Icon(Icons.leaderboard_outlined),
              selectedIcon: Icon(Icons.leaderboard),
              label: 'Ranking',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Me',
            ),
          ],
        ),
      ],
    );
  }
}
