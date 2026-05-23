import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'auth_input_field.dart';

class OnboardingLocationSection extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController bioController;
  final FocusNode fullNameFocus;
  final FocusNode bioFocus;
  final Function(String?) onCountryChanged;
  final Function(String?) onStateChanged;

  const OnboardingLocationSection({
    super.key,
    required this.fullNameController,
    required this.bioController,
    required this.fullNameFocus,
    required this.bioFocus,
    required this.onCountryChanged,
    required this.onStateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 18),
        CSCPicker(
          layout: Layout.vertical,
          flagState: CountryFlag.SHOW_FLAGS,
          showCities: false,
          countryDropdownLabel: 'Select Country',
          stateDropdownLabel: 'Select State / Region',
          selectedItemStyle: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
          ),
          dropdownHeadingStyle: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          dropdownItemStyle: theme.textTheme.bodyMedium,
          onCountryChanged: onCountryChanged,
          onStateChanged: onStateChanged,
          onCityChanged: (_) {},
          dropdownDecoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor),
          ),
          disabledDropdownDecoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
          ),
        ),
        const SizedBox(height: 24),
        AuthInputField(
          controller: fullNameController,
          focusNode: fullNameFocus,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          label: 'Full Name / Legal Brand Name',
          helperText: 'Optional real name for business verification',
          icon: Icons.person_outline_rounded,
          onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(bioFocus),
        ),
        const SizedBox(height: 24),
        AuthInputField(
          controller: bioController,
          focusNode: bioFocus,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.multiline,
          label: 'Creator Biography',
          helperText: 'Tell the world about your unique sound',
          icon: Icons.description_outlined,
        ),
      ],
    );
  }
}
