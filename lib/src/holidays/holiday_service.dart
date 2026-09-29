import '../calendar/nepali_date.dart';
import '../calendar/nepali_date_time.dart';
import 'holiday_data.dart';
import 'nepali_holiday.dart';

/// Pluggable interface for custom or dynamic holiday providers.
///
/// Applications, corporate intranets, or banking systems can implement this
/// to provide company holidays, municipal schedules, or remote holiday datasets.
abstract class HolidayProvider {
  /// Returns all holidays for the given Bikram Sambat [year].
  List<NepaliHoliday> getHolidaysForYear(int year);
}

/// Query, lookup, and registration service for Nepali holidays.
///
/// ### Separation of Concerns:
/// 1. **Calendar Engine:** Completely isolated from holiday datasets.
/// 2. **Official Holiday Dataset:** Official year-specific gazetted holidays provided via [HolidayData].
/// 3. **User-Defined Holidays:** Applications can register custom organization holidays or configure custom providers.
///
/// **Important Note:**
/// Holiday dates vary across years due to the lunar tithi calculations of festivals like Dashain,
/// Tihar, and Maha Shivaratri. For years without full gazetted datasets in the package, fixed national
/// holidays are returned by default. Custom holiday datasets can be supplied without breaking or changing the API.
class NepaliHolidayService {
  NepaliHolidayService._();

  static final List<NepaliHoliday> _customHolidays = [];
  static HolidayProvider? _customProvider;

  /// Sets a custom [HolidayProvider] that takes precedence when querying holidays.
  ///
  /// Pass `null` to reset to the default package dataset.
  static void setCustomProvider(HolidayProvider? provider) {
    _customProvider = provider;
  }

  /// Registers user or organization-defined custom holidays.
  ///
  /// These custom holidays are merged with official holidays across queries.
  static void registerCustomHolidays(List<NepaliHoliday> holidays) {
    _customHolidays.addAll(holidays);
  }

  /// Clears any registered custom holidays.
  static void clearCustomHolidays() {
    _customHolidays.clear();
  }

  /// Resets [NepaliHolidayService] to default state, clearing custom providers and holidays.
  static void reset() {
    _customProvider = null;
    _customHolidays.clear();
  }

  /// Registers official gazetted holidays for a specific Bikram Sambat [year].
  ///
  /// This allows apps to dynamically inject new government gazette schedules
  /// published after package release without code modifications.
  static void registerOfficialHolidays(int year, List<NepaliHoliday> holidays) {
    HolidayData.officialHolidays[year] = List.unmodifiable(holidays);
  }

  /// Returns all holidays for the given Bikram Sambat [year], sorted chronologically.
  ///
  /// Includes official gazetted holidays (or fixed national holidays) plus any registered custom holidays.
  static List<NepaliHoliday> holidaysForYear(int year) {
    final List<NepaliHoliday> baseHolidays;

    if (_customProvider != null) {
      baseHolidays = _customProvider!.getHolidaysForYear(year);
    } else if (HolidayData.officialHolidays.containsKey(year)) {
      baseHolidays = HolidayData.officialHolidays[year]!;
    } else {
      baseHolidays = HolidayData.getFixedHolidaysForYear(year);
    }

    final yearCustom = _customHolidays.where((h) => h.date.year == year);
    final combined = <String, NepaliHoliday>{};

    for (final h in baseHolidays) {
      combined[h.id] = h;
    }
    for (final h in yearCustom) {
      combined[h.id] = h;
    }

    final result = combined.values.toList()..sort();
    return List.unmodifiable(result);
  }

  /// Returns all holidays for a given Bikram Sambat [year] and [month] (1 to 12).
  static List<NepaliHoliday> holidaysForMonth(int year, int month) {
    final all = holidaysForYear(year);
    return all.where((h) => h.date.month == month).toList();
  }

  /// Returns all holidays occurring on the given [date].
  ///
  /// Accepts [NepaliDate], [NepaliDateTime], or standard [DateTime].
  static List<NepaliHoliday> holidaysOn(dynamic date) {
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

    final monthHolidays = holidaysForMonth(bsDate.year, bsDate.month);
    return monthHolidays.where((h) => h.date.day == bsDate.day).toList();
  }

  /// Returns `true` if the given [date] is a holiday.
  ///
  /// If [onlyPublicHolidays] is `true`, only returns `true` for official public/bank closures.
  static bool isHoliday(
    dynamic date, {
    bool onlyPublicHolidays = false,
  }) {
    final holidays = holidaysOn(date);
    if (holidays.isEmpty) return false;
    if (!onlyPublicHolidays) return true;
    return holidays.any((h) => h.isPublicHoliday);
  }

  /// Returns the first holiday on the given [date], or `null` if the day is not a holiday.
  static NepaliHoliday? holidayOn(dynamic date) {
    final holidays = holidaysOn(date);
    return holidays.isNotEmpty ? holidays.first : null;
  }
}
