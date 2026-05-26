class UsernameValidator {
  static final List<String> reserved = [
    'admin', 'support', 'official', 'system', 'root', 'null',
  ];

  static String normalize(String value) {
    return value.trim().toLowerCase();
  }

  static String? validate(String value) {
    final cleanValue = value.trim();

    if (cleanValue.isEmpty) return 'Username required';
    if (cleanValue.length < 3) return 'Minimum 3 characters';
    if (cleanValue.length > 30) return 'Maximum 30 characters';
    
    final validCharacters = RegExp(r'^[a-zA-Z0-9._]+$');
    if (!validCharacters.hasMatch(cleanValue)) {
      return 'Only letters, numbers, underscores, or periods allowed';
    }

    if (reserved.contains(cleanValue.toLowerCase())) {
      return 'Reserved username';
    }

    return null;
  }
}
