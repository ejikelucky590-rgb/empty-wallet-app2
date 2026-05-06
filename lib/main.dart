import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'theme/dove_theme.dart';
import 'screens/hub/hub_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Your actual Supabase Project configuration
  await Supabase.initialize(
    url: 'https://bpxqlhfntpdqnlddrlpc.supabase.co',
    anonKey: 'sb_publishable_MMsTIt81-QakeUPVxj-hlQ_kLOghDu5',
  );

  runApp(const DoveApp());
}

class DoveApp extends StatelessWidget {
  const DoveApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: DoveTheme.darkTheme,
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
    const Center(child: Text("🎵 Waive Music", style: TextStyle(fontSize: 20))),
    const Center(child: Text("➕ Upload Content", style: TextStyle(fontSize: 20))),
    const Center(child: Text("🏆 Top 10 Ranking", style: TextStyle(fontSize: 20))),
    const Center(child: Text("👤 My Profile", style: TextStyle(fontSize: 20))),
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
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined, size: 30), label: 'Plus'),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Ranking'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}
