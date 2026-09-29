import 'transliteration_engine.dart';

/// Production-ready Romanized Nepali (English literal) to Nepali Unicode converter.
///
/// Converts phonetic Romanized Nepali strings into clean Nepali Devanagari Unicode.
///
/// ### Examples
/// ```dart
/// final nepali = NepaliUnicode.convert(
///   "namaste, tpaaii'laaii kasto chha? swagatam!",
/// );
/// // Returns: 'नमस्ते, तपाईंलाई कस्तो छ? स्वगतम्!'
/// ```
///
/// ### Live (Type-as-you-write) Mode
/// When typing interactively inside a `TextField`, use [live]: `true`:
/// ```dart
/// TextField(
///   onChanged: (text) {
///     final liveNepali = NepaliUnicode.convert(text, live: true);
///   },
/// );
/// ```
class NepaliUnicode {
  const NepaliUnicode._();

  /// Converts the given Romanized Nepali [text] into Nepali Unicode.
  ///
  /// * Set [live] to `true` when converting type-as-you-write input in text fields.
  /// * Non-Nepali tokens such as URLs (`https://...`), email addresses, and
  ///   pre-existing Devanagari text are preserved intact.
  static String convert(
    String text, {
    bool live = false,
  }) {
    return TransliterationEngine.convert(text, live: live);
  }
}
