import 'package:flutter/material.dart';

class GenderSelector extends StatelessWidget {
  final String? selectedGender;
  final ValueChanged<String> onSelected;

  const GenderSelector({
    super.key,
    required this.selectedGender,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gender', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'male', label: Text('Male')),
            ButtonSegment(value: 'female', label: Text('Female')),
            ButtonSegment(value: 'other', label: Text('Other')),
          ],
          selected: selectedGender != null ? {selectedGender!} : {},
          onSelectionChanged: (Set<String> selection) => onSelected(selection.first),
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
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Date of Birth'),
      subtitle: Text(
        selectedBirthDate == null
            ? 'Select your birth date'
            : '${selectedBirthDate!.day}/${selectedBirthDate!.month}/${selectedBirthDate!.year}',
      ),
      trailing: const Icon(Icons.calendar_today),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onTap: onTap,
    );
  }
}
