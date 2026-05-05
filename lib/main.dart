import 'package:flutter/material.dart';
import 'theme/dove_theme.dart';
import 'screens/hub.dart';
import 'screens/waive.dart';
import 'screens/plus.dart';
import 'screens/ranking.dart';
import 'screens/me.dart';

void main() => runApp(const DoveApp());

class DoveApp extends StatelessWidget {
  const DoveApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: DoveTheme.darkTheme, // 🕊️ One place to rule them all
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const HubScreen(),
    const WaiveScreen(),
    const PlusScreen(),
    const RankingScreen(),
    const MeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Hub'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Waive'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined, size: 32), label: 'Plus'),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Ranking'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}
