import 'package:flutter/material.dart';
import 'auth_input_field.dart';

class OtpFormView extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isLoading;
  final int resendCooldown;
  final VoidCallback onVerify;
  final VoidCallback onResend;

  const OtpFormView({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isLoading,
    required this.resendCooldown,
    required this.onVerify,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthInputField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          autofillHints: const [AutofillHints.oneTimeCode],
          label: 'Verification Code',
          icon: Icons.verified_user_outlined,
          maxLength: 6,
          validator: (value) => (value == null || value.trim().length < 6) ? 'Enter valid code' : null,
          onFieldSubmitted: (_) => onVerify(),
        ),
        const SizedBox(height: 28),
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading ? null : onVerify,
            child: isLoading 
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)) 
                : const Text('Activate Account'),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: resendCooldown > 0 ? null : onResend,
          child: Text(
            resendCooldown > 0 ? 'Resend code in ${resendCooldown}s' : 'Resend verification code',
          ),
        ),
      ],
    );
  }
}

class CredentialFormView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isSignUp;
  final bool isLoading;
  final bool obscurePassword;
  final String? usernameError;
  final bool checkingUsername;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode usernameFocus;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;
  final VoidCallback onToggleAuthMode;

  const CredentialFormView({
    super.key,
    required this.formKey,
    required this.isSignUp,
    required this.isLoading,
    required this.obscurePassword,
    required this.usernameError,
    required this.checkingUsername,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.usernameFocus,
    required this.emailFocus,
    required this.passwordFocus,
    required this.onToggleObscure,
    required this.onSubmit,
    required this.onToggleAuthMode,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isSignUp) ...[
            AuthInputField(
              controller: usernameController,
              focusNode: usernameFocus,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              autofillHints: const [AutofillHints.username],
              label: 'Username',
              icon: Icons.person_outline,
              textCapitalization: TextCapitalization.none,
              errorText: usernameError,
              suffixIcon: checkingUsername
                  ? const Padding(padding: EdgeInsets.all(14), child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)))
                  : (usernameError == null && usernameController.text.isNotEmpty ? const Icon(Icons.check_circle_outline, color: Colors.green) : null),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Username required' : null,
            ),
            const SizedBox(height: 20),
          ],
          AuthInputField(
            controller: emailController,
            focusNode: emailFocus,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            label: 'Email Address',
            icon: Icons.email_outlined,
            validator: (v) => (v == null || !v.contains('@')) ? 'Invalid email' : null,
          ),
          const SizedBox(height: 20),
          AuthInputField(
            controller: passwordController,
            focusNode: passwordFocus,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.visiblePassword,
            autofillHints: const [AutofillHints.password],
            label: 'Password',
            icon: Icons.lock_outline,
            obscureText: obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: onToggleObscure,
            ),
            validator: (v) => (v == null || v.length < 6) ? 'Password too short' : null,
            onFieldSubmitted: (_) => onSubmit(),
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSubmit,
              child: isLoading 
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
                  : Text(isSignUp ? 'Create Account' : 'Sign In'),
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: onToggleAuthMode,
            child: Text(isSignUp ? 'Already have an account? Sign In' : "Don't have an account? Create one"),
          ),
        ],
      ),
    );
  }
}
