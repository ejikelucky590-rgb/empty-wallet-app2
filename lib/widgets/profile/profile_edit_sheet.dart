import 'package:flutter/material.dart';
import '../../controllers/profile_controller.dart';

class ProfileEditSheet extends StatefulWidget {
  const ProfileEditSheet({super.key});

  @override
  State<ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends State<ProfileEditSheet> {
  final _controller = ProfileController.instance;
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _stageNameController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    final current = _controller.state.profile;
    _stageNameController = TextEditingController(text: current?.stageName ?? '');
    _bioController = TextEditingController(text: current?.bio ?? '');
  }

  @override
  void dispose() {
    _stageNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(context);

    await _controller.save(
      stageName: _stageNameController.text.trim(),
      bio: _bioController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Edit Profile Details', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _stageNameController,
              decoration: const InputDecoration(labelText: 'Stage Name'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bioController,
              decoration: const InputDecoration(labelText: 'Bio Summary'),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: const Text('Save Form Updates'),
            ),
          ],
        ),
      ),
    );
  }
}
