/// Utility class for parsing custom keys from message data.
class CustomKeysParser {
  /// Parses a list of key-value pairs into a Map.
  ///
  /// Returns null if keysData is not a List, or if the resulting map is empty.
  /// Each item in the list should be a Map with 'key' and 'value' as String.
  static Map<String, String>? parseCustomKeys(dynamic keysData) {
    if (keysData is! List) return null;
    final entries = <String, String>{
      for (final item in keysData)
        if (item is Map)
          if (item['key'] is String && item['value'] is String)
            item['key'] as String: item['value'] as String
    };
    return entries.isEmpty ? null : entries;
  }
}