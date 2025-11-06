import 'package:get/get.dart';

/// Maps backend response_code/messages to localized app strings.
/// Priority:
/// 1) response_code -> known i18n key
/// 2) exact backend message -> known i18n key
/// 3) fallback to backend plain message or statusText
String mapResponseToLocalizedMessage(Response response) {
  final body = response.body;
  final String? code = body is Map ? body['response_code'] as String? : null;
  final String message = body is Map
      ? (body['message']?.toString() ?? '')
      : (response.statusText ?? '');

  // 1) Map response_code to app i18n keys
  switch (code) {
    case 'booking_place_success_200':
      return 'your_booking_has_been_placed_successfully'.tr;
    case 'offline_payment_success_200':
      return 'your_payment_confirm_successfully'.tr;
    case 'insufficient_wallet_balance_400':
      return 'insufficient_wallet_balance'.tr;
    default:
      break;
  }

  // 2) Map common backend messages (case-insensitive) to i18n keys
  final String trimmed = message.trim();
  final String lower = trimmed.toLowerCase();
  const Map<String, String> messageToKeyLower = {
    'booking placed successfully': 'your_booking_has_been_placed_successfully',
    'booking placed successfully.': 'your_booking_has_been_placed_successfully',
    'booking placed successfully!': 'your_booking_has_been_placed_successfully',
    'payment confirm successfully': 'your_payment_confirm_successfully',
    'wallet balance is insufficient': 'insufficient_wallet_balance',
    // Email/phone duplicates
    'this email has already been used in another account!': 'email_already_used_in_another_account',
    'this email has already been used in another account': 'email_already_used_in_another_account',
    'this email already another account': 'email_already_used_in_another_account',
    'email already taken': 'email_already_used_in_another_account',
    'this phone has already been used in another account!': 'phone_already_used_in_another_account',
    'this phone has already been used in another account': 'phone_already_used_in_another_account',
    // Location/Address not found variants
    'unknown location found': 'unknown_location_found',
    'unknown location': 'unknown_location_found',
    'location not found': 'unknown_location_found',
    'address not found': 'unknown_location_found',
    // Common misspelling seen in logs
    'unknon location found': 'unknown_location_found',
  };

  final String? key = messageToKeyLower[lower];
  if (key != null) return key.tr;

  // 3) Fallback to raw backend message or status text
  return trimmed.isNotEmpty ? trimmed : (response.statusText ?? '');
}

/// Localize a plain backend message string (used for 400 errors list etc.)
String localizeBackendPlainMessage(String message) {
  final String trimmed = message.trim();
  final String lower = trimmed.toLowerCase();
  const Map<String, String> messageToKeyLower = {
    'booking placed successfully': 'your_booking_has_been_placed_successfully',
    'booking placed successfully.': 'your_booking_has_been_placed_successfully',
    'booking placed successfully!': 'your_booking_has_been_placed_successfully',
    'payment confirm successfully': 'your_payment_confirm_successfully',
    'wallet balance is insufficient': 'insufficient_wallet_balance',
    'this email has already been used in another account!': 'email_already_used_in_another_account',
    'this email has already been used in another account': 'email_already_used_in_another_account',
    'this email already another account': 'email_already_used_in_another_account',
    'email already taken': 'email_already_used_in_another_account',
    'this phone has already been used in another account!': 'phone_already_used_in_another_account',
    'this phone has already been used in another account': 'phone_already_used_in_another_account',
    // Location/Address not found variants
    'unknown location found': 'unknown_location_found',
    'unknown location': 'unknown_location_found',
    'location not found': 'unknown_location_found',
    'address not found': 'unknown_location_found',
    // Common misspelling seen in logs
    'unknon location found': 'unknown_location_found',
  };
  final String? key = messageToKeyLower[lower];
  return key != null ? key.tr : trimmed;
}
