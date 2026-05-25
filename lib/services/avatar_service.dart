import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:supabase_flutter/supabase_flutter.dart';

class AvatarService {
  static final SupabaseClient _supabase =
      Supabase.instance.client;

  static Future<String> uploadAvatar({
    required File imageFile,
    required String userId,
  }) async {
    final bytes =
        await imageFile.readAsBytes();

    final decodedImage =
        img.decodeImage(bytes);

    if (decodedImage == null) {
      throw Exception(
        'Invalid image selected.',
      );
    }

    final resizedImage =
        img.copyResize(
      decodedImage,
      width: 512,
    );

    final compressedBytes =
        Uint8List.fromList(
      img.encodeJpg(
        resizedImage,
        quality: 82,
      ),
    );

    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}.jpg';

    final storagePath =
        '$userId/avatar/$fileName';

    await _supabase.storage
        .from('avatars')
        .uploadBinary(
          storagePath,
          compressedBytes,
          fileOptions:
              const FileOptions(
            contentType:
                'image/jpeg',
            upsert: true,
          ),
        );

    final publicUrl =
        _supabase.storage
            .from('avatars')
            .getPublicUrl(
              storagePath,
            );

    return '$publicUrl?v=${DateTime.now().millisecondsSinceEpoch}';
  }
}
