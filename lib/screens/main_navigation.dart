import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/mini_player_wrapper.dart';
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
    _screens = [
      const HubScreen(),
      const WaiveScreen(),
      const SizedBox(), 
      const Center(child: Text("🏆 Rankings")),
      const ArtistProfileScreen(),
    ];
  }

  void _onDestinationSelected(int index) {
    HapticFeedback.lightImpact();
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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          MiniPlayerWrapper(),
        ],
      ),
    );
  }
}
