import '../core/language.dart';

/// Representation of the 7 weekdays in the Nepali calendar.
///
/// Follows standard international convention where Sunday is index 1
/// and Saturday is index 7 (the standard weekend day in Nepal).
enum NepaliWeekday {
  /// Sunday (आइतबार / Ravibar)
  sunday(1, 'आइतबार', 'Sunday', 'आइत', 'Sun'),

  /// Monday (सोमबार / Sombar)
  monday(2, 'सोमबार', 'Monday', 'सोम', 'Mon'),

  /// Tuesday (मंगलबार / Mangalbar)
  tuesday(3, 'मंगलबार', 'Tuesday', 'मंगल', 'Tue'),

  /// Wednesday (बुधबार / Budhabar)
  wednesday(4, 'बुधबार', 'Wednesday', 'बुध', 'Wed'),

  /// Thursday (बिहीबार / Bihibar)
  thursday(5, 'बिहीबार', 'Thursday', 'बिही', 'Thu'),

  /// Friday (शुक्रबार / Sukrabar)
  friday(6, 'शुक्रबार', 'Friday', 'शुक्र', 'Fri'),

  /// Saturday (शनिबार / Sanibar) - Official weekend in Nepal
  saturday(7, 'शनिबार', 'Saturday', 'शनि', 'Sat');

  /// The 1-based index of the weekday (1 = Sunday, 7 = Saturday).
  final int number;

  /// Full name in Nepali Devanagari script.
  final String nameNepali;

  /// Full name in English.
  final String nameEnglish;

  /// Short abbreviation in Nepali Devanagari script.
  final String shortNepali;

  /// Short abbreviation in English.
  final String shortEnglish;

  const NepaliWeekday(
    this.number,
    this.nameNepali,
    this.nameEnglish,
    this.shortNepali,
    this.shortEnglish,
  );

  /// Returns the [NepaliWeekday] corresponding to the given 1-based [index] (1 to 7).
  static NepaliWeekday fromIndex(int index) {
    if (index < 1 || index > 7) {
      throw RangeError.range(
          index, 1, 7, 'index', 'Weekday index must be between 1 and 7');
    }
    return NepaliWeekday.values[index - 1];
  }

  /// Whether this day is Saturday (the standard official weekend in Nepal).
  bool get isWeekend => this == NepaliWeekday.saturday;

  /// Returns the localized name of this weekday based on the provided [language].
  String getName([Language language = Language.nepali]) {
    return language.isNepali ? nameNepali : nameEnglish;
  }

  /// Returns the localized short name of this weekday based on the provided [language].
  String getShortName([Language language = Language.nepali]) {
    return language.isNepali ? shortNepali : shortEnglish;
  }

  /// The next chronological weekday (wrapping from Saturday to Sunday).
  NepaliWeekday get next =>
      number == 7 ? NepaliWeekday.sunday : NepaliWeekday.values[number];

  /// The previous chronological weekday (wrapping from Sunday to Saturday).
  NepaliWeekday get previous =>
      number == 1 ? NepaliWeekday.saturday : NepaliWeekday.values[number - 2];
}
