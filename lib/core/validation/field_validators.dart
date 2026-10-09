abstract final class FieldValidators {
  static String? requiredText(
    String? value, {
    required String label,
    int maxLength = 80,
  }) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '$label is required.';
    if (text.length > maxLength) {
      return '$label can have at most $maxLength characters.';
    }
    return null;
  }

  static String? optionalText(
    String? value, {
    required String label,
    int maxLength = 240,
  }) {
    if ((value ?? '').trim().length > maxLength) {
      return '$label can have at most $maxLength characters.';
    }
    return null;
  }

  static String? message(String? value) {
    return requiredText(value, label: 'Message', maxLength: 280);
  }
}
