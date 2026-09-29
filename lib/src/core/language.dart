/// Language option for localization throughout the package.
enum Language {
  /// Nepali Devanagari script (नेपाली)
  nepali('ne', 'नेपाली'),

  /// English script / Romanized transliteration
  english('en', 'English');

  /// The standard ISO 639-1 language code.
  final String code;

  /// The human-readable name of the language.
  final String displayName;

  const Language(this.code, this.displayName);

  /// Whether this language represents Nepali.
  bool get isNepali => this == Language.nepali;

  /// Whether this language represents English.
  bool get isEnglish => this == Language.english;
}
