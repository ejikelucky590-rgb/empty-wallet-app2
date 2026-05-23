import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final Iterable<String>? autofillHints;
  final String label;
  final String? helperText;
  final String? hintText;
  final IconData icon;
  final String? errorText;
  final int maxLines;
  final int? maxLength;
  final bool obscureText;
  final bool enabled;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;

  const AuthInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.autofillHints,
    required this.label,
    this.helperText,
    this.hintText,
    required this.icon,
    this.errorText,
    this.maxLines = 1,
    this.maxLength,
    this.obscureText = false,
    this.enabled = true,
    this.autofocus = false,
    this.inputFormatters,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _isFocused = widget.focusNode.hasFocus;
    widget.focusNode.addListener(_handleFocusChange);
  }

  // Extracted listener function so we can remove it cleanly later
  void _handleFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = widget.focusNode.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    // Crucial Step: Removes the listener from the shared parent FocusNode to prevent memory leaks
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  blurRadius: 14,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                  color: colors.primary.withOpacity(0.12),
                ),
              ]
            : [],
      ),
      child: Semantics(
        textField: true,
        label: widget.label,
        child: TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType,
          autofillHints: widget.autofillHints,
          obscureText: widget.obscureText,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onFieldSubmitted,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          cursorColor: colors.primary,
          decoration: InputDecoration(
            labelText: widget.label,
            helperText: widget.helperText,
            hintText: widget.hintText,
            errorText: widget.errorText,
            counterText: '',
            filled: true,
            fillColor: colors.surfaceContainerHighest.withOpacity(0.35),
            prefixIcon: Icon(
              widget.icon,
              color: _isFocused ? colors.primary : colors.onSurfaceVariant,
            ),
            suffixIcon: widget.suffixIcon,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
            labelStyle: TextStyle(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            floatingLabelStyle: TextStyle(
              color: colors.primary,
              fontWeight: FontWeight.bold,
            ),
            helperStyle: TextStyle(
              color: colors.onSurfaceVariant.withOpacity(0.8),
            ),
            hintStyle: TextStyle(
              color: colors.onSurfaceVariant.withOpacity(0.6),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.55)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: colors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: colors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: colors.error, width: 2),
          ),
        ),
      ),
    ),
   );
  }
}
