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
        child: Text(
          'Track uploads are temporarily disabled.',
        ),
      ),
    );
  }
}
EOcat << 'EOF' > lib/screens/upload/upload_track_screen.dart
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
        child: Text(
          'Track uploads are temporarily disabled.',
        ),
      ),
    );
  }
}
