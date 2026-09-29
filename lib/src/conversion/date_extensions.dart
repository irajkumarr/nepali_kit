import '../calendar/nepali_date.dart';
import '../calendar/nepali_date_time.dart';
import '../core/language.dart';
import '../fiscal/nepali_fiscal_quarter.dart';
import '../fiscal/nepali_fiscal_year.dart';
import '../formatting/nepali_date_format.dart';
import '../holidays/holiday_service.dart';
import '../holidays/nepali_holiday.dart';
import '../relative_time/nepali_moment.dart';

/// Extension methods on standard Dart [DateTime] for easy Bikram Sambat conversions and fiscal calculations.
extension NepaliDateTimeExtensions on DateTime {
  /// Converts this Gregorian [DateTime] into a Bikram Sambat [NepaliDateTime].
  NepaliDateTime toNepaliDateTime() {
    return NepaliDateTime.fromDateTime(this);
  }

  /// Converts this Gregorian [DateTime] into a Bikram Sambat [NepaliDate].
  NepaliDate toNepaliDate() {
    return NepaliDate.fromDateTime(this);
  }

  /// The Nepal Government fiscal year containing this Gregorian [DateTime].
  NepaliFiscalYear get nepaliFiscalYear => NepaliFiscalYear.fromDate(this);

  /// The Nepal Government fiscal quarter containing this Gregorian [DateTime].
  NepaliFiscalQuarter get nepaliFiscalQuarter =>
      NepaliFiscalQuarter.fromDate(this);

  /// Formats this date in Bikram Sambat using [pattern] (defaults to `'yyyy-MM-dd'`).
  String formatNepali(
      [String pattern = 'yyyy-MM-dd', Language language = Language.nepali]) {
    return NepaliDateFormat(pattern, language).format(this);
  }

  /// Returns a relative moment string for this date (e.g. "भर्खरै", "१० मिनेट अगाडि").
  String nepaliMoment({
    dynamic referenceDate,
    Language language = Language.nepali,
    bool showSeconds = true,
  }) {
    return NepaliMoment.fromDate(
      this,
      referenceDate: referenceDate,
      language: language,
      showSeconds: showSeconds,
    );
  }

  /// Returns `true` if this Gregorian [DateTime] is a Nepali holiday.
  bool get isNepaliHoliday => NepaliHolidayService.isHoliday(this);

  /// All Nepali holidays occurring on this date.
  List<NepaliHoliday> get nepaliHolidays =>
      NepaliHolidayService.holidaysOn(this);
}

/// Extension methods on [NepaliDate] for formatting, moments, fiscal calculations, and holidays.
extension NepaliDateFiscalExtensions on NepaliDate {
  /// Formats this date using [pattern] (defaults to `'yyyy-MM-dd'`).
  String format(
      [String pattern = 'yyyy-MM-dd', Language language = Language.nepali]) {
    return NepaliDateFormat(pattern, language).format(this);
  }

  /// Returns a relative moment string (e.g. "आज", "हिजो", "५ दिन अगाडि").
  String moment({
    dynamic referenceDate,
    Language language = Language.nepali,
    bool showSeconds = true,
  }) {
    return NepaliMoment.fromDate(
      this,
      referenceDate: referenceDate,
      language: language,
      showSeconds: showSeconds,
    );
  }

  /// The Nepal Government fiscal year containing this [NepaliDate].
  NepaliFiscalYear get fiscalYear => NepaliFiscalYear.fromDate(this);

  /// The Nepal Government fiscal quarter containing this [NepaliDate].
  NepaliFiscalQuarter get fiscalQuarter => NepaliFiscalQuarter.fromDate(this);

  /// Returns `true` if this [NepaliDate] is a holiday.
  bool get isHoliday => NepaliHolidayService.isHoliday(this);

  /// All holidays occurring on this [NepaliDate].
  List<NepaliHoliday> get holidays => NepaliHolidayService.holidaysOn(this);
}

/// Extension methods on [NepaliDateTime] for formatting, moments, Gregorian conversions, fiscal calculations, and holidays.
extension GregorianDateTimeExtensions on NepaliDateTime {
  /// Formats this datetime using [pattern] (defaults to `'yyyy-MM-dd'`).
  String format(
      [String pattern = 'yyyy-MM-dd', Language language = Language.nepali]) {
    return NepaliDateFormat(pattern, language).format(this);
  }

  /// Returns a relative moment string (e.g. "भर्खरै", "१० मिनेट अगाडि").
  String moment({
    dynamic referenceDate,
    Language language = Language.nepali,
    bool showSeconds = true,
  }) {
    return NepaliMoment.fromDate(
      this,
      referenceDate: referenceDate,
      language: language,
      showSeconds: showSeconds,
    );
  }

  /// Converts this Bikram Sambat [NepaliDateTime] into a Gregorian [DateTime].
  DateTime toGregorianDateTime() {
    return toDateTime();
  }

  /// The Nepal Government fiscal year containing this [NepaliDateTime].
  NepaliFiscalYear get fiscalYear => NepaliFiscalYear.fromDate(this);

  /// The Nepal Government fiscal quarter containing this [NepaliDateTime].
  NepaliFiscalQuarter get fiscalQuarter => NepaliFiscalQuarter.fromDate(this);

  /// Returns `true` if this [NepaliDateTime] is a holiday.
  bool get isHoliday => NepaliHolidayService.isHoliday(this);

  /// All holidays occurring on this [NepaliDateTime].
  List<NepaliHoliday> get holidays => NepaliHolidayService.holidaysOn(this);
}
