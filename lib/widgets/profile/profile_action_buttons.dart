import 'package:flutter/material.dart';

class ProfileActionButtons extends StatelessWidget {
  final VoidCallback onEditPressed;

  const ProfileActionButtons({
    super.key,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: onEditPressed,
          icon: const Icon(Icons.edit_outlined),
          label: const Text(
            'Edit Profile',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          style: FilledButton.styleFrom(
            elevation: 0,
            minimumSize: const Size(
              double.infinity,
              52,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}
