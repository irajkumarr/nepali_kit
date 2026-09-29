import 'package:meta/meta.dart';

import '../calendar/nepali_date.dart';
import '../calendar/nepali_date_time.dart';
import '../core/language.dart';

/// Categories of holidays in Nepal.
enum HolidayCategory {
  /// Major national holidays (Dashain, Tihar, Constitution Day, New Year, etc.).
  national('राष्ट्रिय पर्व', 'National Holiday'),

  /// General gazetted public holidays (Labor Day, Women's Day, etc.).
  public('सार्वजनिक बिदा', 'Public Holiday'),

  /// Religious and community-specific holidays (Chhath, Teej, Buddha Jayanti, Eid, Christmas).
  religious('धार्मिक पर्व', 'Religious Holiday'),

  /// Regional or municipal-specific holidays (e.g., Kathmandu Valley holidays like Indra Jatra, Ghode Jatra).
  regional('क्षेत्रीय/स्थानीय बिदा', 'Regional Holiday'),

  /// Custom organization, bank, or user-defined holidays.
  custom('विशेष/निजी बिदा', 'Custom Holiday');

  /// Localized name in Nepali Devanagari.
  final String nameNepali;

  /// Localized name in English.
  final String nameEnglish;

  const HolidayCategory(this.nameNepali, this.nameEnglish);

  /// Returns the category label for the specified [language].
  String getName([Language language = Language.nepali]) {
    return language.isNepali ? nameNepali : nameEnglish;
  }
}

/// Represents an immutable holiday in Nepal.
///
/// **Note on Nepali Holidays:**
/// In Nepal, public holidays and festivals do not remain strictly fixed across all years.
/// While some national days (e.g. New Year on Baisakh 1, Constitution Day on Ashwin 3)
/// are fixed in Bikram Sambat, the majority of major festivals (such as Dashain, Tihar,
/// Maha Shivaratri, Holi, and Buddha Jayanti) are lunar tithi-based and shift dates
/// every year according to the *Nepal Panchanga Nirnayak Bikas Samiti*.
///
/// Official public holidays are declared annually by the Nepal Government Ministry
/// of Home Affairs via the Nepal Gazette (नेपाल राजपत्र).
@immutable
class NepaliHoliday implements Comparable<NepaliHoliday> {
  /// Unique identifier for the holiday (e.g. `'dashain_vijaya_dashami_2081'`).
  final String id;

  /// Name of the holiday in Nepali Devanagari script (e.g. `'विजया दशमी'`).
  final String nameNepali;

  /// Name of the holiday in English (e.g. `'Vijaya Dashami'`).
  final String nameEnglish;

  /// The date of the holiday in Bikram Sambat as a date-only [NepaliDate].
  final NepaliDate date;

  /// Category classification.
  final HolidayCategory category;

  /// Whether this holiday is an official public office/bank closure holiday.
  final bool isPublicHoliday;

  /// Optional description or cultural context.
  final String? description;

  const NepaliHoliday({
    required this.id,
    required this.nameNepali,
    required this.nameEnglish,
    required this.date,
    this.category = HolidayCategory.national,
    this.isPublicHoliday = true,
    this.description,
  });

  /// Factory constructor allowing construction from either [NepaliDate], [NepaliDateTime], or [DateTime].
  factory NepaliHoliday.from({
    required String id,
    required String nameNepali,
    required String nameEnglish,
    required dynamic date,
    HolidayCategory category = HolidayCategory.national,
    bool isPublicHoliday = true,
    String? description,
  }) {
    final NepaliDate bsDate;
    if (date is NepaliDate) {
      bsDate = date;
    } else if (date is NepaliDateTime) {
      bsDate = date.toNepaliDate();
    } else if (date is DateTime) {
      bsDate = NepaliDate.fromDateTime(date);
    } else {
      throw ArgumentError.value(
        date,
        'date',
        'Expected NepaliDate, NepaliDateTime, or DateTime',
      );
    }

    return NepaliHoliday(
      id: id,
      nameNepali: nameNepali,
      nameEnglish: nameEnglish,
      date: bsDate,
      category: category,
      isPublicHoliday: isPublicHoliday,
      description: description,
    );
  }

  /// Returns the localized name of the holiday based on [language].
  String getName([Language language = Language.nepali]) {
    return language.isNepali ? nameNepali : nameEnglish;
  }

  /// Returns the holiday date as a [NepaliDateTime] (at 00:00:00).
  NepaliDateTime get dateTime => date.toNepaliDateTime();

  @override
  int compareTo(NepaliHoliday other) {
    final dateComp = date.compareTo(other.date);
    if (dateComp != 0) return dateComp;
    return id.compareTo(other.id);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NepaliHoliday &&
          other.id == id &&
          other.date == date &&
          other.isPublicHoliday == isPublicHoliday &&
          other.category == category;

  @override
  int get hashCode => Object.hash(id, date, isPublicHoliday, category);

  @override
  String toString() => 'NepaliHoliday($nameEnglish on $date)';
}
