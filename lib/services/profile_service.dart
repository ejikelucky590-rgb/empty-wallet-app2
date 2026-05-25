import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  ProfileService._();

  static final ProfileService instance = ProfileService._();

  final SupabaseClient _supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  static const int _maxFileSizeBytes = 5 * 1024 * 1024;

  static const List<String> _allowedMimeTypes = [
    'image/jpeg',
    'image/png',
    'image/webp',
  ];

  /// Uploads avatar and updates profile.
  Future<String?> uploadAndSetAvatar(ImageSource source) async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) {
        throw const ProfileServiceException('Authentication session missing.');
      }

      final XFile? pickedImage = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedImage == null) {
        return null;
      }

      final Uint8List bytes = await pickedImage.readAsBytes();

      if (bytes.lengthInBytes > _maxFileSizeBytes) {
        throw const ProfileServiceException('Image exceeds 5MB limit.');
      }

      final mimeType = lookupMimeType(
        pickedImage.path,
        headerBytes: bytes,
      );

      if (mimeType == null || !_allowedMimeTypes.contains(mimeType)) {
        throw const ProfileServiceException('Unsupported image format.');
      }

      final fileExtension = pickedImage.path.split('.').last.toLowerCase();
      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final storagePath = '${user.id}/$fileName';

      final oldProfile = await _supabase
          .from('profiles')
          .select('avatar_url')
          .eq('id', user.id)
          .maybeSingle();

      final oldAvatarUrl = oldProfile?['avatar_url'] as String?;

      await _supabase.storage.from('avatars').uploadBinary(
        storagePath,
        bytes,
        fileOptions: FileOptions(
          upsert: true,
          contentType: mimeType,
        ),
      ).timeout(
        const Duration(seconds: 30),
      );

      final publicUrl = _supabase.storage.from('avatars').getPublicUrl(storagePath);
      final cacheBustedUrl = '$publicUrl?v=${DateTime.now().millisecondsSinceEpoch}';

      await _supabase.from('profiles').update({
        'avatar_url': cacheBustedUrl,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', user.id);

      if (oldAvatarUrl != null && oldAvatarUrl.isNotEmpty) {
        unawaited(_removeAvatarFromStorage(oldAvatarUrl));
      }

      return cacheBustedUrl;
    } on TimeoutException {
      throw const ProfileServiceException('Upload timeout. Please retry.');
    } on StorageException catch (e) {
      debugPrint('StorageException: ${e.message}');
      throw ProfileServiceException(e.message);
    } catch (e) {
      debugPrint('ProfileService Upload Error: $e');
      rethrow;
    }
  }

  /// Removes current avatar.
  Future<void> removeCurrentAvatar(String? currentUrl) async {
    try {
      final user = _supabase.auth.currentUser;

      if (user == null) {
        throw const ProfileServiceException('Authentication session missing.');
      }

      await _supabase.from('profiles').update({
        'avatar_url': null,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', user.id);

      if (currentUrl != null && currentUrl.isNotEmpty) {
        await _removeAvatarFromStorage(currentUrl);
      }
    } catch (e) {
      debugPrint('Avatar Removal Error: $e');
      rethrow;
    }
  }

  Future<void> _removeAvatarFromStorage(String avatarUrl) async {
    try {
      final uri = Uri.parse(avatarUrl);
      final pathSegments = uri.pathSegments;
      final bucketIndex = pathSegments.indexOf('avatars');

      if (bucketIndex == -1) {
        return;
      }

      final storagePath = pathSegments.sublist(bucketIndex + 1).join('/');

      await _supabase.storage.from('avatars').remove([storagePath]);
    } catch (e) {
      debugPrint('Storage cleanup failed: $e');
    }
  }
}

class ProfileServiceException implements Exception {
  final String message;
  const ProfileServiceException(this.message);

  @override
  String toString() => message;
}
