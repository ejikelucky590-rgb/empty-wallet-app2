class UsernameValidator {
  static final List<String> reserved = [
    'admin', 'support', 'official', 'system', 'root', 'null',
  ];

  static String normalize(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '');
  }

  static String? validate(String value) {
    final username = normalize(value);

    if (username.isEmpty) return 'Username required';
    if (username.length < 3) return 'Minimum 3 characters';
    if (username.length > 30) return 'Maximum 30 characters';
    if (reserved.contains(username)) return 'Reserved username';

    return null;
  }
}
