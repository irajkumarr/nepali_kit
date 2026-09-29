/// Utilities for converting between ASCII digits (0-9) and Nepali Devanagari numerals (०-९).
class NepaliDigits {
  NepaliDigits._();

  static const Map<String, String> _englishToNepaliMap = {
    '0': '०',
    '1': '१',
    '2': '२',
    '3': '३',
    '4': '४',
    '5': '५',
    '6': '६',
    '7': '७',
    '8': '८',
    '9': '९',
  };

  static const Map<String, String> _nepaliToEnglishMap = {
    '०': '0',
    '१': '1',
    '२': '2',
    '३': '3',
    '४': '4',
    '५': '5',
    '६': '6',
    '७': '7',
    '८': '8',
    '९': '9',
  };

  /// Converts any English digits in [input] to Devanagari numerals.
  ///
  /// Example:
  /// ```dart
  /// NepaliDigits.toNepali(2081); // '२०८१'
  /// NepaliDigits.toNepali('Page 12 of 50'); // 'Page १२ of ५०'
  /// ```
  static String toNepali(dynamic input) {
    if (input == null) return '';
    final str = input.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      final char = str[i];
      buffer.write(_englishToNepaliMap[char] ?? char);
    }
    return buffer.toString();
  }

  /// Converts any Nepali Devanagari numerals in [input] to ASCII digits.
  ///
  /// Example:
  /// ```dart
  /// NepaliDigits.toEnglish('२०८१'); // '2081'
  /// ```
  static String toEnglish(String input) {
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      buffer.write(_nepaliToEnglishMap[char] ?? char);
    }
    return buffer.toString();
  }

  /// Returns `true` if the string contains at least one Nepali digit (०-९).
  static bool containsNepaliDigits(String input) {
    for (int i = 0; i < input.length; i++) {
      final codeUnit = input.codeUnitAt(i);
      // Devanagari digits Unicode range: U+0966 (२४०६) to U+096F (२४१५)
      if (codeUnit >= 0x0966 && codeUnit <= 0x096F) {
        return true;
      }
    }
    return false;
  }
}
