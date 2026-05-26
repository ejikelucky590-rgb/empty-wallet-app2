import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/profile_repository.dart';
import '../validators/username_validator.dart';

class OnboardingController {
  final ProfileRepository _repository = ProfileRepository();
  Timer? usernameDebounce;

  void dispose() {
    usernameDebounce?.cancel();
  }

  Future<Map<String, dynamic>> checkUsernameAvailability(String value) async {
    final validationError = UsernameValidator.validate(value);
    if (validationError != null) {
      return {'available': false, 'error': validationError};
    }

    final username = UsernameValidator.normalize(value);
    final available = await _repository.isUsernameAvailable(username);

    return {
      'available': available,
      'error': available ? null : 'Username already taken',
    };
  }

  Future<void> saveProfile({
    required String stageName,
    required String firstName,
    required String lastName,
    required String countryCode,
    required String state,
    required String gender,
    required DateTime birthDate,
    String? avatarUrl,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw Exception('No active session.');

    final username = UsernameValidator.normalize(stageName);
    final fullName = '$firstName $lastName';

    await _repository.updateProfile(
      userId: user.id,
      username: username,
      stageName: stageName,
      fullName: fullName,
      countryCode: countryCode,
      state: state,
      gender: gender,
      birthDate: birthDate,
      avatarUrl: avatarUrl,
    );
  }
}
