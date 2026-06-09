import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/mini_player.dart';
import '../widgets/upload/upload_sheet.dart';

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

    _screens = const [
      Center(child: Text('Home')),
      Center(child: Text('Waives')),
      SizedBox(),
      Center(child: Text('Rankings')),
      Center(child: Text('Profile')),
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
      bottomNavigationBar: MiniPlayerWrapper(),
    );
  }
}
