import 'package:easy_localization/easy_localization.dart';

/// Canonical phone normalization for Indian mobile numbers
String normalizePhone(String? phone) {
  if (phone == null || phone.trim().isEmpty) return '';
  final digits = phone.replaceAll(RegExp(r'\D'), '');
  if (digits.length > 10 && digits.startsWith('91')) {
    return digits.substring(digits.length - 10);
  }
  if (digits.length == 11 && digits.startsWith('0')) {
    return digits.substring(digits.length - 10);
  }
  return digits;
}

/// Centralized validation for Indian mobile numbers (10 digits starting with 6, 7, 8, 9)
String? validatePhone(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'validation.mobile_required'.tr();
  }

  final trimmed = value.trim();

  // Check for non-digit characters
  if (RegExp(r'\D').hasMatch(trimmed)) {
    return 'validation.mobile_digits_only'.tr();
  }

  // Check length
  if (trimmed.length != 10) {
    return 'validation.mobile_invalid_length'.tr();
  }

  // Check first digit
  if (!RegExp(r'^[6-9]').hasMatch(trimmed)) {
    return 'validation.mobile_invalid_start'.tr();
  }

  // Final regex check
  if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(trimmed)) {
    return 'validation.mobile_invalid'.tr();
  }

  return null;
}
