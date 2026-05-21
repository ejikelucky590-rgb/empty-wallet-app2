import 'package:flutter/material.dart';
import 'widgets/profile_header.dart';
import 'widgets/media_grid.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileHeader(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Divider(color: Colors.grey),
              ),
              // Fixed: Provided the required posts argument here
              MediaGrid(posts: []),
            ],
          ),
        ),
      ),
    );
  }
}
