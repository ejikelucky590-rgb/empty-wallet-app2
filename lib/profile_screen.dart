import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'widgets/profile_header.dart';
import 'widgets/media_grid.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  
  // Real dynamic user states
  String _username = "loading...";
  String _fullName = "Loading Account...";
  String _bio = "Fetching details from the server...";
  int _following = 0;
  int _followers = 0;
  int _likes = 0;

  @override
  void initState() {
    super.initState();
    _loadUserProfileData();
  }

  Future<void> _loadUserProfileData() async {
    try {
      final user = _supabase.auth.currentUser;
      
      if (user == null) {
        // Fallback placeholder display data if no active session is logged in yet
        setState(() {
          _username = "guest_user";
          _fullName = "Guest Account";
          _bio = "Sign in to customize your audio studio space.";
          _isLoading = false;
        });
        return;
      }

      // Fetch row metrics matching the authenticated user's ID
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      setState(() {
        _username = data['username'] ?? 'unknown';
        _fullName = data['full_name'] ?? 'No Name';
        _bio = data['bio'] ?? 'No bio added yet.';
        _following = data['following_count'] ?? 0;
        _followers = data['followers_count'] ?? 0;
        _likes = data['likes_count'] ?? 0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        // Friendly default fallback if database connection works but profile isn't generated yet
        _username = "music_creator";
        _fullName = "New Dove Artist";
        _bio = "Welcome to your new audio profile! Tap edit to set up your studio bio.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.purple),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          _fullName,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserProfileData,
        color: Colors.purple,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dynamic presentation layer bindings
              ProfileHeader(
                username: "@$_username",
                following: _following.toString(),
                followers: _followers.toString(),
                likes: _likes.toString(),
                bio: _bio,
              ),
              const SizedBox(height: 10),
              const MediaGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
