import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _captionController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // TODO
  }

  Future<void> _publishPost() async {
    // TODO
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: _captionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'What is happening?',
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo),
              label: const Text('Add Photo'),
            ),

            const Spacer(),

            FilledButton(
              onPressed: _publishPost,
              child: const Text('Publish'),
            ),
          ],
        ),
      ),
    );
  }
}
