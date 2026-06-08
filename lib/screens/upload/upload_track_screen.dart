import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../services/track_upload_service.dart';

class UploadTrackScreen extends StatefulWidget {
  const UploadTrackScreen({super.key});

  @override
  State<UploadTrackScreen> createState() => _UploadTrackScreenState();
}

class _UploadTrackScreenState extends State<UploadTrackScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _audioFile;
  File? _coverFile;
  bool _isUploading = false;

  final _service = TrackUploadService();

  Future<void> _pickAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _audioFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickCover() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _coverFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadTrack() async {
    if (_audioFile == null || _coverFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select audio and cover")),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      await _service.uploadTrack(
        audioFile: _audioFile!,
        coverFile: _coverFile!,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload successful 🚀")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Track')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Track Title'),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Description'),
          ),

          const SizedBox(height: 20),

          ListTile(
            leading: const Icon(Icons.audio_file),
            title: Text(_audioFile?.path.split('/').last ?? "Select Audio"),
            onTap: _pickAudio,
          ),

          ListTile(
            leading: const Icon(Icons.image),
            title: Text(_coverFile?.path.split('/').last ?? "Select Cover"),
            onTap: _pickCover,
          ),

          const SizedBox(height: 24),

          FilledButton(
            onPressed: _isUploading ? null : _uploadTrack,
            child: Text(_isUploading ? "Uploading..." : "Upload Track"),
          ),
        ],
      ),
    );
  }
}
