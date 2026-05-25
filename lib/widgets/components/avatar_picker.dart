import 'dart:io';

import 'package:flutter/material.dart';

class AvatarPicker extends StatelessWidget {
  final File? imageFile;
  final String? avatarUrl;
  final VoidCallback onTap;

  const AvatarPicker({
    super.key,
    required this.imageFile,
    required this.avatarUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment:
            Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 56,
            backgroundColor: colors
                .surfaceContainerHighest,
            backgroundImage:
                imageFile != null
                    ? FileImage(
                        imageFile!,
                      )
                    : avatarUrl != null
                        ? NetworkImage(
                            avatarUrl!,
                          )
                        : null,
            child:
                imageFile == null &&
                        avatarUrl == null
                    ? Icon(
                        Icons.person,
                        size: 54,
                        color: colors
                            .onSurfaceVariant,
                      )
                    : null,
          ),
          Container(
            width: 36,
            height: 36,
            decoration:
                BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primary,
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
