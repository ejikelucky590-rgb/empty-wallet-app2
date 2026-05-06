import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/dove_theme.dart';

class HubScreen extends StatefulWidget {
  const HubScreen({super.key});
  @override
  State<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<dynamic> _music = [];

  @override
  void initState() {
    super.initState();
    _fetchMusic();
  }

  Future<void> _fetchMusic() async {
    try {
      // Fetch only media where type is 'music'
      final data = await _supabase.from('media_feed').select().eq('type', 'music');
      setState(() {
        _music = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎵 Music Hub')),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: DoveColors.primaryCyan))
        : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _music.length,
            itemBuilder: (context, index) {
              final track = _music[index];
              return Container(
                decoration: BoxDecoration(
                  color: DoveColors.cardGrey,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.music_note, size: 50, color: DoveColors.primaryCyan),
                    const SizedBox(height: 10),
                    Text(track['title'] ?? 'Song', textAlign: TextAlign.center, maxLines: 1),
                    Text(track['creator_name'] ?? 'Artist', 
                      style: const TextStyle(color: DoveColors.textGrey, fontSize: 12)),
                  ],
                ),
              );
            },
          ),
    );
  }
}
