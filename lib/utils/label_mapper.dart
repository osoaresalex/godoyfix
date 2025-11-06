import 'package:get/get.dart';

/// Maps certain backend-provided labels to localized equivalents.
///
/// Currently focuses on Zone (Service Area) names where the backend may send
/// a special value like "All over the World" that should be localized in the UI.
String localizeZoneName(String? name) {
  if (name == null) return '';
  final trimmed = name.trim();
  if (trimmed.isEmpty) return '';

  final normalized = trimmed.toLowerCase();

  // Common variants we might receive from the backend
  const variants = <String>{
    'all over the world',
    'all over world',
    'all over the world.',
  };

  if (variants.contains(normalized)) {
    return 'all_over_the_world'.tr;
  }

  return name;
}
