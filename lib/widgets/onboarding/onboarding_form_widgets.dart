import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GenderSelector extends StatelessWidget {
  final String? selectedGender;
  final Function(String) onSelected;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: ['male', 'female'].map((gender) {
            final isSelected = selectedGender == gender;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onSelected(gender);
                },
                child: Container(
                  height: 52,
                  margin: EdgeInsets.only(
                    right: gender == 'male' ? 8 : 0,
                    left: gender == 'female' ? 8 : 0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: isSelected ? colors.primary : colors.surfaceContainerHighest,
                  ),
                  child: Center(
                    child: Text(
                      gender.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? colors.onPrimary : colors.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class BirthDatePickerTile extends StatelessWidget {
  final DateTime? selectedBirthDate;
  final VoidCallback onTap;

  const BirthDatePickerTile({
    super.key,
    required this.selectedBirthDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.outlineVariant),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedBirthDate == null
                      ? 'Select birth date'
                      : '${selectedBirthDate!.year}-${selectedBirthDate!.month.toString().padLeft(2, '0')}-${selectedBirthDate!.day.toString().padLeft(2, '0')}',
                ),
                Icon(Icons.calendar_month_outlined, color: colors.primary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
