import 'package:flutter/material.dart';

class UploadReelScreen extends StatefulWidget {
  const UploadReelScreen({super.key});

  @override
  State<UploadReelScreen> createState() => _UploadReelScreenState();
}

class _UploadReelScreenState extends State<UploadReelScreen> {

  Future<void> _pickVideo() async {
    // TODO
  }

  Future<void> _uploadReel() async {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Reel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            ElevatedButton.icon(
              onPressed: _pickVideo,
              icon: const Icon(Icons.video_library),
              label: const Text('Select Video'),
            ),

            const Spacer(),

            FilledButton(
              onPressed: _uploadReel,
              child: const Text('Upload Reel'),
            ),
          ],
        ),
      ),
    );
  }
}
