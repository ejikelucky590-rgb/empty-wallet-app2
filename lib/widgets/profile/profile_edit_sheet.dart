import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/profile_controller.dart';

class ProfileEditSheet extends StatefulWidget {
  const ProfileEditSheet({super.key});

  @override
  State<ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends State<ProfileEditSheet> {
  final _controller = ProfileController.instance;
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  late final TextEditingController _stageCtrl;
  late final TextEditingController _bioCtrl;
  
  File? _selectedImageFile;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final current = _controller.currentProfile;
    _stageCtrl = TextEditingController(text: current?.stageName ?? '');
    _bioCtrl = TextEditingController(text: current?.bio ?? '');
  }

  @override
  void dispose() {
    _stageCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final img = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (img != null) {
      setState(() => _selectedImageFile = File(img.path));
    }
  }

  Future<void> _executeSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final success = await _controller.saveProfileOptimistic(
      stageName: _stageCtrl.text.trim(),
      bio: _bioCtrl.text.trim(),
      imageFile: _selectedImageFile,
    );

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        _showToast("Changes updated successfully");
      } else {
        _showToast("Saved locally. Changes will sync in background.");
      }
      Navigator.pop(context);
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.w600)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final currentProfile = _controller.currentProfile;
    final hasRemoteAvatar = currentProfile?.avatarUrl != null && currentProfile!.avatarUrl!.trim().isNotEmpty;

    ImageProvider? avatarImage;
    if (_selectedImageFile != null) {
      avatarImage = FileImage(_selectedImageFile!);
    } else if (hasRemoteAvatar) {
      avatarImage = NetworkImage(currentProfile!.avatarUrl!);
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.outlineVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Edit Profile Layout', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  )
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: colors.primaryContainer,
                      backgroundImage: avatarImage,
                      child: avatarImage == null
                          ? Icon(Icons.person_rounded, size: 50, color: colors.onPrimaryContainer)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _stageCtrl,
                validator: (v) => v == null || v.trim().isEmpty ? "Stage Name is required" : null,
                decoration: InputDecoration(
                  labelText: "Stage Name",
                  prefixIcon: const Icon(Icons.music_note_rounded),
                  filled: true,
                  fillColor: colors.surfaceContainerLowest,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Bio",
                  prefixIcon: const Icon(Icons.description_outlined),
                  filled: true,
                  fillColor: colors.surfaceContainerLowest,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _isSaving ? null : _executeSave,
                  style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                  child: _isSaving 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text("Save Changes", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
