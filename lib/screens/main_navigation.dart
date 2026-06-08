import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/mini_player.dart';
import '../widgets/upload/upload_sheet.dart';

import 'hub/hub_screen.dart';
import 'waive_screen.dart';
import 'artist_profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    // 📌 Screens (Upload is NOT a screen anymore)
    _screens = [
      const HubScreen(),
      const WaiveScreen(),
      const SizedBox(), // Upload placeholder (handled via modal)
      const Center(child: Text("🏆 Rankings")),
      const ArtistProfileScreen(),
    ];
  }

  void _onDestinationSelected(int index) {
    HapticFeedback.lightImpact();

    // 🚀 Upload is a modal action (X / Instagram style)
    if (index == 2) {
      UploadSheet.show(context);
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      // 🎧 GLOBAL AUDIO DOCK + NAVIGATION
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          MiniPlayerWrapper(),
        ],
      ),
    );
  }
}
