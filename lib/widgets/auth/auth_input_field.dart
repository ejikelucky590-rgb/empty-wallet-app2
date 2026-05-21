import 'package:flutter/material.dart';

class AuthInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final List<String> autofillHints;
  final String label;
  final String? helperText;
  final String? errorText;
  final IconData icon;
  final String? Function(String?) validator;
  final void Function(String)? onFieldSubmitted;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final Widget? suffixIcon;
  final int maxLines;
  final int? maxLength;

  const AuthInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.textInputAction,
    required this.keyboardType,
    required this.autofillHints,
    required this.label,
    required this.icon,
    required this.validator,
    this.helperText,
    this.errorText,
    this.onFieldSubmitted,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      onFieldSubmitted: onFieldSubmitted,
      maxLines: maxLines,
      maxLength: maxLength,
      obscureText: obscureText,
      textCapitalization: textCapitalization,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), 
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16), 
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
      ),
    );
  }
}
