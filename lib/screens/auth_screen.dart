import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/auth/auth_forms.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _supabase = Supabase.instance.client;
  final _secureStorage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _otpController = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _usernameFocus = FocusNode();
  final _otpFocus = FocusNode();

  bool _isSignUp = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _awaitingOtpVerification = false;
  bool _checkingUsername = false;
  String? _usernameError;
  Timer? _debounce;
  Timer? _resendCooldownTimer;
  int _resendCooldown = 0;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onUsernameChanged);
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authSubscription = _supabase.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      if (session == null || !mounted) return;

      final profile = await _supabase
          .from('profiles')
          .select()
          .eq('id', session.user.id)
          .maybeSingle();

      if (!mounted) return;

      if (profile == null) {
        context.go('/onboarding');
      } else {
        context.go('/');
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _debounce?.cancel();
    _resendCooldownTimer?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _otpController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _usernameFocus.dispose();
    _otpFocus.dispose();
    super.dispose();
  }

  void _onUsernameChanged() {
    if (!_isSignUp) return;
    final username = _usernameController.text.trim().toLowerCase();
    if (username.length < 3) return;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _checkUsernameAvailability(username);
    });
  }

  Future<void> _checkUsernameAvailability(String username) async {
    setState(() {
      _checkingUsername = true;
      _usernameError = null;
    });

    try {
      final existingUser = await _supabase
          .from('profiles')
          .select('username')
          .eq('username', username)
          .maybeSingle();

      if (!mounted) return;

      setState(() {
        if (existingUser != null) {
          _usernameError = 'Username already taken';
        } else {
          _usernameError = null;
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _usernameError = 'Unable to verify username');
    } finally {
      if (mounted) setState(() => _checkingUsername = false);
    }
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();
    if (!_isSignUp && !_formKey.currentState!.validate()) return;
    if (_isSignUp && _usernameError != null) {
      _showErrorSnackBar(_usernameError!);
      return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.mediumImpact();

    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    try {
      if (_isSignUp) {
        await _supabase.auth.signUp(
          email: email,
          password: password,
          data: {
            'username': _usernameController.text.trim().toLowerCase(),
            'full_name': _usernameController.text.trim(),
          },
        );
        if (!mounted) return;
        setState(() => _awaitingOtpVerification = true);
        _startResendCooldown();
        _showSuccessSnackBar('Verification code sent to email.');
      } else {
        final response = await _supabase.auth.signInWithPassword(email: email, password: password);
        await _secureStorage.write(key: 'last_email', value: email);
        if (!mounted) return;
        if (response.session == null) {
          _showErrorSnackBar('Unable to create session.');
        }
      }
    } on AuthException catch (e) {
      if (mounted) _showErrorSnackBar(e.message);
    } on TimeoutException {
      if (mounted) _showErrorSnackBar('Network timeout.');
    } catch (_) {
      if (mounted) _showErrorSnackBar('Authentication failed.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtp() async {
    FocusScope.of(context).unfocus();
    if (_otpController.text.trim().length < 6) {
      _showErrorSnackBar('Invalid verification code.');
      return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.selectionClick();

    try {
      await _supabase.auth.verifyOTP(
        email: _emailController.text.trim(),
        token: _otpController.text.trim(),
        type: OtpType.signup,
      );
    } on AuthException catch (e) {
      if (mounted) _showErrorSnackBar(e.message);
    } catch (_) {
      if (mounted) _showErrorSnackBar('OTP verification failed.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    if (_resendCooldown > 0) return;
    try {
      await _supabase.auth.resend(
        type: OtpType.signup,
        email: _emailController.text.trim(),
      );
      _startResendCooldown();
      _showSuccessSnackBar('Verification code resent.');
    } catch (_) {
      _showErrorSnackBar('Unable to resend code.');
    }
  }

  void _startResendCooldown() {
    _resendCooldown = 30;
    _resendCooldownTimer?.cancel();
    _resendCooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown <= 0) {
        timer.cancel();
      } else {
        if (mounted) setState(() => _resendCooldown--);
      }
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
        content: Text(message),
      ));
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Hero(
                          tag: 'dove-auth',
                          child: Icon(Icons.music_note_rounded, size: 90, color: theme.colorScheme.primary),
                        ),
                        const SizedBox(height: 32),
                        // Added clean app branding here
                        Text(
                          _awaitingOtpVerification ? 'Verify Account' : (_isSignUp ? 'Join Dove Music 🕊️' : 'Welcome to Dove Music 🕊️'),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _awaitingOtpVerification ? 'Enter the verification code sent to your email.' : 'Access your professional studio hub.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 48),
                        _awaitingOtpVerification
                            ? OtpFormView(
                                controller: _otpController,
                                focusNode: _otpFocus,
                                isLoading: _isLoading,
                                resendCooldown: _resendCooldown,
                                onVerify: _verifyOtp,
                                onResend: _resendOtp,
                              )
                            : CredentialFormView(
                                formKey: _formKey,
                                isSignUp: _isSignUp,
                                isLoading: _isLoading,
                                obscurePassword: _obscurePassword,
                                usernameError: _usernameError,
                                checkingUsername: _checkingUsername,
                                usernameController: _usernameController,
                                emailController: _emailController,
                                passwordController: _passwordController,
                                usernameFocus: _usernameFocus,
                                emailFocus: _emailFocus,
                                passwordFocus: _passwordFocus,
                                onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                                onSubmit: _handleSubmit,
                                onToggleAuthMode: () => setState(() {
                                  _isSignUp = !_isSignUp;
                                  _usernameError = null;
                                }),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Positioned.fill(child: AnimatedOpacity(opacity: 0.3, duration: Duration(milliseconds: 200), child: ModalBarrier(dismissible: false, color: Colors.black))),
        ],
      ),
    );
  }
}
