import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'avatar_picker_sheet.dart';

class AvatarPickerLauncher {
  AvatarPickerLauncher._();

  static Future<void> show({
    required BuildContext context,
    required bool hasCurrentAvatar,
    required Future<void> Function(ImageSource source) onImageSelected,
    Future<void> Function()? onRemoveAvatar,
    bool enableDrag = true,
    bool useRootNavigator = true,
  }) async {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    HapticFeedback.selectionClick();

    await showModalBottomSheet<void>(
      context: context,
      useRootNavigator: useRootNavigator,
      useSafeArea: true,
      isScrollControlled: true,
      enableDrag: enableDrag,
      showDragHandle: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (modalContext) {
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          tween: Tween(begin: 0.96, end: 1),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: AvatarPickerSheet(
              hasCurrentAvatar: hasCurrentAvatar,
              onCameraTap: () async {
                await _safeAction(
                  context: modalContext,
                  action: () => onImageSelected(ImageSource.camera),
                );
              },
              onGalleryTap: () async {
                await _safeAction(
                  context: modalContext,
                  action: () => onImageSelected(ImageSource.gallery),
                );
              },
              onRemoveTap: onRemoveAvatar == null
                  ? null
                  : () async {
                      await _safeAction(
                        context: modalContext,
                        action: onRemoveAvatar,
                      );
                    },
            ),
          ),
        );
      },
    );
  }

  static Future<void> _safeAction({
    required BuildContext context,
    required Future<void> Function() action,
  }) async {
    try {
      Navigator.of(context).pop();

      await Future.delayed(
        const Duration(milliseconds: 120),
      );

      await action();
    } catch (e) {
      debugPrint('AvatarPickerLauncher Error: $e');
    }
  }
}
