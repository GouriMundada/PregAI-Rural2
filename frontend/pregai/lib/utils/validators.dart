/// Small shared validation helpers used across the app's forms
/// (Patient Registration, ANC Entry) so numeric clinical fields get
/// consistent, user-friendly error messages without over-restricting
/// legitimate data entry.
class Validators {
  Validators._();

  /// Validates that a field contains a parsable number.
  /// If [required] is true (default), an empty value is also rejected.
  /// No medical range limits are enforced here — only that the value
  /// entered is actually numeric, so legitimate edge-case readings are
  /// never blocked.
  static String? Function(String?) numeric(String label, {bool required = true}) {
    return (value) {
      final trimmed = value?.trim() ?? '';
      if (trimmed.isEmpty) {
        return required ? '$label is required' : null;
      }
      if (double.tryParse(trimmed) == null) {
        return 'Enter a valid number for $label';
      }
      return null;
    };
  }
}
