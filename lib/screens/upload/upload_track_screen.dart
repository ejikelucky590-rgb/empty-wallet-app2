import 'package:flutter/material.dart';

class UploadTrackScreen extends StatelessWidget {
  const UploadTrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Track'),
      ),
      body: const Center(
        child: Text('Uploads temporarily disabled'),
      ),
    );
  }
}
