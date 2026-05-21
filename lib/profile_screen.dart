import 'package:flutter/material.dart';
import 'widgets/profile_header.dart';
import 'widgets/media_grid.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProfileHeader(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Divider(color: Colors.grey),
              ),
              // Fixed: Supplied all 4 required constructor arguments
              MediaGrid(
                posts: const [],
                controller: _scrollController,
                isVideo: false,
                isPaginating: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
