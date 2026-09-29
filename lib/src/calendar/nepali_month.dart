import '../core/language.dart';

/// Representation of the 12 months in the Bikram Sambat calendar.
enum NepaliMonth {
  /// First month: Baisakh (बैशाख) - approx. mid-April to mid-May
  baisakh(1, 'बैशाख', 'Baisakh', 'बै', 'Bai'),

  /// Second month: Jestha (जेठ) - approx. mid-May to mid-June
  jestha(2, 'जेठ', 'Jestha', 'जे', 'Jes'),

  /// Third month: Ashadh (असार) - approx. mid-June to mid-July
  ashadh(3, 'असार', 'Ashadh', 'अ', 'Ash'),

  /// Fourth month: Shrawan (साउन / श्रावण) - approx. mid-July to mid-August
  shrawan(4, 'श्रावण', 'Shrawan', 'श्रा', 'Shr'),

  /// Fifth month: Bhadra (भदौ / भाद्र) - approx. mid-August to mid-September
  bhadra(5, 'भाद्र', 'Bhadra', 'भा', 'Bha'),

  /// Sixth month: Ashwin (असोज / आश्विन) - approx. mid-September to mid-October
  ashwin(6, 'आश्विन', 'Ashwin', 'आ', 'Ashw'),

  /// Seventh month: Kartik (कात्तिक / कार्तिक) - approx. mid-October to mid-November
  kartik(7, 'कार्तिक', 'Kartik', 'का', 'Kar'),

  /// Eighth month: Mangsir (मंसिर) - approx. mid-November to mid-December
  mangsir(8, 'मंसिर', 'Mangsir', 'मं', 'Man'),

  /// Ninth month: Poush (पुस / पौष) - approx. mid-December to mid-January
  poush(9, 'पौष', 'Poush', 'पौ', 'Pou'),

  /// Tenth month: Magh (माघ) - approx. mid-January to mid-February
  magh(10, 'माघ', 'Magh', 'मा', 'Mag'),

  /// Eleventh month: Falgun (फागुन / फाल्गुन) - approx. mid-February to mid-March
  falgun(11, 'फाल्गुन', 'Falgun', 'फा', 'Fal'),

  /// Twelfth month: Chaitra (चैत / चैत्र) - approx. mid-March to mid-April
  chaitra(12, 'चैत', 'Chaitra', 'चै', 'Cha');

  /// The 1-based index of the month (1 = Baisakh, 12 = Chaitra).
  final int number;

  /// Full name in Nepali Devanagari script.
  final String nameNepali;

  /// Full name in English transliteration.
  final String nameEnglish;

  /// Short abbreviation in Nepali Devanagari script.
  final String shortNepali;

  /// Short abbreviation in English.
  final String shortEnglish;

  const NepaliMonth(
    this.number,
    this.nameNepali,
    this.nameEnglish,
    this.shortNepali,
    this.shortEnglish,
  );

  /// Returns the [NepaliMonth] corresponding to the given 1-based [index] (1 to 12).
  ///
  /// Throws [RangeError] if [index] is not between 1 and 12.
  static NepaliMonth fromIndex(int index) {
    if (index < 1 || index > 12) {
      throw RangeError.range(
          index, 1, 12, 'index', 'Month index must be between 1 and 12');
    }
    return NepaliMonth.values[index - 1];
  }

  /// Returns the localized name of this month based on the provided [language].
  String getName([Language language = Language.nepali]) {
    return language.isNepali ? nameNepali : nameEnglish;
  }

  /// Returns the localized short abbreviation of this month based on the provided [language].
  String getShortName([Language language = Language.nepali]) {
    return language.isNepali ? shortNepali : shortEnglish;
  }

  /// The next chronological month (wrapping from Chaitra to Baisakh).
  NepaliMonth get next =>
      number == 12 ? NepaliMonth.baisakh : NepaliMonth.values[number];

  /// The previous chronological month (wrapping from Baisakh to Chaitra).
  NepaliMonth get previous =>
      number == 1 ? NepaliMonth.chaitra : NepaliMonth.values[number - 2];
}
