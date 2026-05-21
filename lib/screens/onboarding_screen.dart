import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/auth/auth_input_field.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _bioController = TextEditingController();

  final _usernameFocus = FocusNode();
  final _fullNameFocus = FocusNode();
  final _bioFocus = FocusNode();

  bool _isLoading = false;
  bool _checkingUsername = false;
  String? _usernameError;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _usernameController.dispose();
    _fullNameController.dispose();
    _bioController.dispose();
    _usernameFocus.dispose();
    _fullNameFocus.dispose();
    _bioFocus.dispose();
    super.dispose();
  }

  void _onUsernameChanged() {
    final username = _usernameController.text.trim().toLowerCase();
    if (username.length < 3) {
      setState(() => _usernameError = null);
      return;
    }
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () => _checkUsernameAvailability(username));
  }

  Future<void> _checkUsernameAvailability(String username) async {
    setState(() { _checkingUsername = true; _usernameError = null; });
    try {
      final res = await _supabase.from('profiles').select('username').eq('username', username).maybeSingle();
      if (mounted) setState(() => _usernameError = res != null ? 'Username already taken' : null);
    } catch (_) {
      if (mounted) setState(() => _usernameError = 'Verification failed');
    } finally {
      if (mounted) setState(() => _checkingUsername = false);
    }
  }

  Future<void> _completeSetup() async {
    if (!_formKey.currentState!.validate() || _usernameError != null) return;
    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase.from('profiles').upsert({
        'id': user.id,
        'username': _usernameController.text.trim().toLowerCase(),
        'full_name': _fullNameController.text.trim(),
        'bio': _bioController.text.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      });
      if (mounted) context.go('/');
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.music_note_rounded, size: 90, color: theme.colorScheme.primary),
                        const SizedBox(height: 28),
                        Text('Setup Your Studio', textAlign: TextAlign.center, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 40),
                        AuthInputField(
                          controller: _usernameController,
                          focusNode: _usernameFocus,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          autofillHints: const [AutofillHints.username],
                          label: 'Stage Name / Username',
                          helperText: 'Public creator identity',
                          icon: Icons.alternate_email,
                          errorText: _usernameError,
                          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                          onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_fullNameFocus),
                          suffixIcon: _checkingUsername 
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                              : (_usernameController.text.length >= 3 && _usernameError == null ? const Icon(Icons.check_circle, color: Colors.green) : null),
                        ),
                        const SizedBox(height: 22),
                        AuthInputField(
                          controller: _fullNameController,
                          focusNode: _fullNameFocus,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          autofillHints: const [AutofillHints.name],
                          label: 'Full Name',
                          helperText: 'Displayed across your profile',
                          icon: Icons.person_outline,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                          onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_bioFocus),
                        ),
                        const SizedBox(height: 22),
                        AuthInputField(
                          controller: _bioController,
                          focusNode: _bioFocus,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.multiline,
                          autofillHints: const [AutofillHints.nickname],
                          label: 'Artist Bio',
                          helperText: 'Tell listeners about your sound',
                          icon: Icons.music_note_outlined,
                          maxLines: 3,
                          maxLength: 180,
                          validator: (v) => v != null && v.length > 180 ? 'Too long' : null,
                          onFieldSubmitted: (_) => _completeSetup(),
                        ),
                        const SizedBox(height: 42),
                        SizedBox(
                          height: 58,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _completeSetup,
                            child: _isLoading ? const CircularProgressIndicator() : const Text('Enter Dove Studio'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_isLoading) const Positioned.fill(child: ModalBarrier(dismissible: false, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
