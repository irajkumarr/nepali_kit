import 'package:meta/meta.dart';

import '../conversion/bs_ad_converter.dart';
import '../conversion/bs_calendar_data.dart';
import '../core/exceptions.dart';
import '../numbers/nepali_digits.dart';
import 'nepali_date.dart';
import 'nepali_date_range.dart';
import 'nepali_month.dart';
import 'nepali_weekday.dart';

/// An immutable representation of an instant in time in the Bikram Sambat (BS) calendar.
///
/// Designed to provide full parity with the standard Dart [DateTime] class.
@immutable
class NepaliDateTime implements Comparable<NepaliDateTime> {
  /// The Bikram Sambat year (e.g. 2081).
  final int year;

  /// The month in the Bikram Sambat year (1 to 12).
  final int month;

  /// The day of the month (1 to 32).
  final int day;

  /// The hour of the day in 24-hour clock (0 to 23).
  final int hour;

  /// The minute of the hour (0 to 59).
  final int minute;

  /// The second of the minute (0 to 59).
  final int second;

  /// The millisecond of the second (0 to 999).
  final int millisecond;

  /// The microsecond of the millisecond (0 to 999).
  final int microsecond;

  /// Whether this date is in UTC.
  final bool isUtc;

  /// Cached milliseconds since Unix epoch for deterministic comparison and arithmetic.
  final int _millisecondsSinceEpoch;

  const NepaliDateTime._internal(
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
    this.millisecond,
    this.microsecond,
    this.isUtc,
    this._millisecondsSinceEpoch,
  );

  /// Constructs a [NepaliDateTime] in the local time zone.
  factory NepaliDateTime(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) {
    return _create(
      year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
      false,
    );
  }

  /// Constructs a [NepaliDateTime] in the UTC time zone.
  factory NepaliDateTime.utc(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) {
    return _create(
      year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
      true,
    );
  }

  static NepaliDateTime _create(
    int year,
    int month,
    int day,
    int hour,
    int minute,
    int second,
    int millisecond,
    int microsecond,
    bool isUtc,
  ) {
    if (!BsCalendarData.isValidBsDate(year, month, day)) {
      throw NepaliDateException(
        'Invalid Bikram Sambat date components.',
        year: year,
        month: month,
        day: day,
      );
    }

    final (adYear, adMonth, adDay) = BsAdConverter.bsToAd(year, month, day);
    final adDateTime = isUtc
        ? DateTime.utc(
            adYear,
            adMonth,
            adDay,
            hour,
            minute,
            second,
            millisecond,
            microsecond,
          )
        : DateTime(
            adYear,
            adMonth,
            adDay,
            hour,
            minute,
            second,
            millisecond,
            microsecond,
          );

    return NepaliDateTime._internal(
      year,
      month,
      day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
      isUtc,
      adDateTime.millisecondsSinceEpoch,
    );
  }

  /// Constructs a [NepaliDateTime] with the current date and time in the local time zone.
  factory NepaliDateTime.now() {
    return NepaliDateTime.fromDateTime(DateTime.now());
  }

  /// Constructs a [NepaliDateTime] corresponding to the given Gregorian [DateTime].
  factory NepaliDateTime.fromDateTime(DateTime dateTime) {
    final (bsYear, bsMonth, bsDay) = BsAdConverter.adToBs(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );

    return NepaliDateTime._internal(
      bsYear,
      bsMonth,
      bsDay,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
      dateTime.millisecond,
      dateTime.microsecond,
      dateTime.isUtc,
      dateTime.millisecondsSinceEpoch,
    );
  }

  /// Constructs a [NepaliDateTime] from milliseconds since Unix epoch.
  factory NepaliDateTime.fromMillisecondsSinceEpoch(
    int millisecondsSinceEpoch, {
    bool isUtc = false,
  }) {
    final dt = DateTime.fromMillisecondsSinceEpoch(
      millisecondsSinceEpoch,
      isUtc: isUtc,
    );
    return NepaliDateTime.fromDateTime(dt);
  }

  /// Converts this [NepaliDateTime] to its Gregorian AD [DateTime] equivalent.
  DateTime toDateTime() {
    final (adYear, adMonth, adDay) = BsAdConverter.bsToAd(year, month, day);
    return isUtc
        ? DateTime.utc(
            adYear,
            adMonth,
            adDay,
            hour,
            minute,
            second,
            millisecond,
            microsecond,
          )
        : DateTime(
            adYear,
            adMonth,
            adDay,
            hour,
            minute,
            second,
            millisecond,
            microsecond,
          );
  }

  /// Converts this instance to a date-only [NepaliDate].
  NepaliDate toNepaliDate() => NepaliDate(year, month, day);

  /// The number of milliseconds since the Unix epoch (1970-01-01T00:00:00Z).
  int get millisecondsSinceEpoch => _millisecondsSinceEpoch;

  /// The day of the week (1 = Sunday / Aaitabar, ..., 7 = Saturday / Sanibar).
  int get weekday {
    final ad = toDateTime();
    return ad.weekday == DateTime.sunday ? 1 : ad.weekday + 1;
  }

  /// Day of the year (1-based index from Baisakh 1).
  int get dayOfYear {
    int count = 0;
    for (int m = 1; m < month; m++) {
      count += BsCalendarData.getDaysInMonth(year, m);
    }
    return count + day;
  }

  /// Strongly-typed month representation.
  NepaliMonth get nepaliMonth => NepaliMonth.fromIndex(month);

  /// Strongly-typed weekday representation.
  NepaliWeekday get nepaliWeekday => NepaliWeekday.fromIndex(weekday);

  /// The total number of days in this specific BS month and year.
  int get totalDaysInMonth => BsCalendarData.getDaysInMonth(year, month);

  /// Alias for [totalDaysInMonth].
  int get daysInMonth => totalDaysInMonth;

  /// Total number of days in this year.
  int get totalDaysInYear {
    int total = 0;
    for (int m = 1; m <= 12; m++) {
      total += BsCalendarData.getDaysInMonth(year, m);
    }
    return total;
  }

  /// Alias for [totalDaysInYear].
  int get daysInYear => totalDaysInYear;

  /// Whether this year is a leap year (366 days in the solar Bikram Sambat year).
  bool get isLeapYear => totalDaysInYear == 366;

  /// Whether this day is Saturday (official weekend in Nepal).
  bool get isSaturday => weekday == 7;

  /// Alias for [isSaturday].
  bool get isWeekend => isSaturday;

  /// Whether this date represents today in the local system time.
  bool get isToday {
    final now = NepaliDateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Start of the day (00:00:00.000).
  NepaliDateTime get startOfDay => copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  /// End of the day (23:59:59.999).
  NepaliDateTime get endOfDay => copyWith(
        hour: 23,
        minute: 59,
        second: 59,
        millisecond: 999,
        microsecond: 999,
      );

  /// Start of the month (day 1, 00:00:00).
  NepaliDateTime get startOfMonth => copyWith(
        day: 1,
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  /// End of the month (last day, 23:59:59).
  NepaliDateTime get endOfMonth => copyWith(
        day: totalDaysInMonth,
        hour: 23,
        minute: 59,
        second: 59,
        millisecond: 999,
        microsecond: 999,
      );

  /// The [NepaliDateRange] spanning this entire month.
  NepaliDateRange get monthRange =>
      NepaliDateRange(start: startOfMonth, end: endOfMonth);

  /// Start of the year (Baisakh 1, 00:00:00).
  NepaliDateTime get startOfYear => copyWith(
        month: 1,
        day: 1,
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  /// End of the year (Chaitra last day, 23:59:59).
  NepaliDateTime get endOfYear => copyWith(
        month: 12,
        day: BsCalendarData.getDaysInMonth(year, 12),
        hour: 23,
        minute: 59,
        second: 59,
        millisecond: 999,
        microsecond: 999,
      );

  /// The [NepaliDateRange] spanning this entire year.
  NepaliDateRange get yearRange =>
      NepaliDateRange(start: startOfYear, end: endOfYear);

  /// Returns the first day of the next chronological month at 00:00:00.
  NepaliDateTime get nextMonth {
    if (month == 12) {
      return copyWith(
        year: year + 1,
        month: 1,
        day: 1,
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
    }
    return copyWith(
      month: month + 1,
      day: 1,
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
  }

  /// Returns the first day of the previous chronological month at 00:00:00.
  NepaliDateTime get previousMonth {
    if (month == 1) {
      return copyWith(
        year: year - 1,
        month: 12,
        day: 1,
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
    }
    return copyWith(
      month: month - 1,
      day: 1,
      hour: 0,
      minute: 0,
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
  }

  /// Adds a number of days to this datetime, handling rollover correctly while preserving time of day.
  NepaliDateTime addDays(int days) {
    if (days == 0) return this;
    final ad = toDateTime().add(Duration(days: days));
    return NepaliDateTime.fromDateTime(ad);
  }

  /// Subtracts a number of days from this datetime.
  NepaliDateTime subtractDays(int days) => addDays(-days);

  /// Adds a number of months to this datetime, adjusting year and clamping days if target month has fewer days.
  NepaliDateTime addMonths(int months) {
    if (months == 0) return this;
    final totalMonths = (year * 12 + (month - 1)) + months;
    final targetYear = totalMonths ~/ 12;
    final targetMonth = (totalMonths % 12) + 1;
    final maxDays = BsCalendarData.getDaysInMonth(targetYear, targetMonth);
    final targetDay = day > maxDays ? maxDays : day;
    return copyWith(
      year: targetYear,
      month: targetMonth,
      day: targetDay,
    );
  }

  /// Subtracts a number of months from this datetime.
  NepaliDateTime subtractMonths(int months) => addMonths(-months);

  /// Adds a number of years to this datetime, clamping days if target year has fewer days in this month.
  NepaliDateTime addYears(int years) {
    if (years == 0) return this;
    final targetYear = year + years;
    final maxDays = BsCalendarData.getDaysInMonth(targetYear, month);
    final targetDay = day > maxDays ? maxDays : day;
    return copyWith(
      year: targetYear,
      day: targetDay,
    );
  }

  /// Subtracts a number of years from this datetime.
  NepaliDateTime subtractYears(int years) => addYears(-years);

  /// Returns a new [NepaliDateTime] with [duration] added.
  NepaliDateTime add(Duration duration) {
    return NepaliDateTime.fromDateTime(toDateTime().add(duration));
  }

  /// Returns a new [NepaliDateTime] with [duration] subtracted.
  NepaliDateTime subtract(Duration duration) {
    return NepaliDateTime.fromDateTime(toDateTime().subtract(duration));
  }

  /// Returns the [Duration] difference between this and [other].
  Duration difference(NepaliDateTime other) {
    return toDateTime().difference(other.toDateTime());
  }

  /// Returns `true` if this occurs before [other].
  bool isBefore(NepaliDateTime other) =>
      _millisecondsSinceEpoch < other._millisecondsSinceEpoch;

  /// Returns `true` if this occurs after [other].
  bool isAfter(NepaliDateTime other) =>
      _millisecondsSinceEpoch > other._millisecondsSinceEpoch;

  /// Returns `true` if this occurs at the same moment as [other].
  bool isAtSameMomentAs(NepaliDateTime other) =>
      _millisecondsSinceEpoch == other._millisecondsSinceEpoch;

  /// Returns `true` if this occurs before or at the same moment as [other].
  bool isAtOrBefore(NepaliDateTime other) =>
      _millisecondsSinceEpoch <= other._millisecondsSinceEpoch;

  /// Returns `true` if this occurs after or at the same moment as [other].
  bool isAtOrAfter(NepaliDateTime other) =>
      _millisecondsSinceEpoch >= other._millisecondsSinceEpoch;

  /// Returns `true` if this occurs strictly before [other].
  bool operator <(NepaliDateTime other) =>
      _millisecondsSinceEpoch < other._millisecondsSinceEpoch;

  /// Returns `true` if this occurs before or at the same moment as [other].
  bool operator <=(NepaliDateTime other) =>
      _millisecondsSinceEpoch <= other._millisecondsSinceEpoch;

  /// Returns `true` if this occurs strictly after [other].
  bool operator >(NepaliDateTime other) =>
      _millisecondsSinceEpoch > other._millisecondsSinceEpoch;

  /// Returns `true` if this occurs after or at the same moment as [other].
  bool operator >=(NepaliDateTime other) =>
      _millisecondsSinceEpoch >= other._millisecondsSinceEpoch;

  @override
  int compareTo(NepaliDateTime other) =>
      _millisecondsSinceEpoch.compareTo(other._millisecondsSinceEpoch);

  /// Returns a copy of this [NepaliDateTime] with the specified fields replaced.
  NepaliDateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
    bool? isUtc,
  }) {
    return _create(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
      isUtc ?? this.isUtc,
    );
  }

  /// Returns an ISO-8601-like formatted string representation (e.g. `"2081-06-13T10:30:00.000"`).
  String toIso8601String() {
    String y = year.toString().padLeft(4, '0');
    String m = month.toString().padLeft(2, '0');
    String d = day.toString().padLeft(2, '0');
    String h = hour.toString().padLeft(2, '0');
    String min = minute.toString().padLeft(2, '0');
    String sec = second.toString().padLeft(2, '0');
    String ms = millisecond.toString().padLeft(3, '0');
    String tz = isUtc ? 'Z' : '';
    return '$y-$m-${d}T$h:$min:$sec.$ms$tz';
  }

  /// Parses a formatted string into a [NepaliDateTime].
  ///
  /// Supports ISO format `YYYY-MM-DD` and `YYYY-MM-DDTHH:mm:ss`.
  static NepaliDateTime parse(String formattedString) {
    final parsed = tryParse(formattedString);
    if (parsed == null) {
      throw NepaliDateParseException(
        'Could not parse string into NepaliDateTime.',
        source: formattedString,
      );
    }
    return parsed;
  }

  /// Like [parse], but returns `null` instead of throwing on invalid input.
  static NepaliDateTime? tryParse(String formattedString) {
    try {
      final normalized = NepaliDigits.toEnglish(formattedString.trim());
      final regex = RegExp(
          r'^(\d{4})[-/](\d{1,2})[-/](\d{1,2})(?:[T ](\d{1,2}):(\d{1,2})(?::(\d{1,2})(?:\.(\d{1,6}))?)?(Z)?)?');
      final match = regex.firstMatch(normalized);
      if (match == null) return null;

      final year = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final day = int.parse(match.group(3)!);
      final hour = match.group(4) != null ? int.parse(match.group(4)!) : 0;
      final minute = match.group(5) != null ? int.parse(match.group(5)!) : 0;
      final second = match.group(6) != null ? int.parse(match.group(6)!) : 0;
      final msStr = match.group(7);
      final millisecond =
          msStr != null ? int.parse(msStr.padRight(3, '0').substring(0, 3)) : 0;
      final isUtc = match.group(8) == 'Z';

      if (!BsCalendarData.isValidBsDate(year, month, day)) return null;

      return _create(
          year, month, day, hour, minute, second, millisecond, 0, isUtc);
    } catch (_) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NepaliDateTime &&
        other._millisecondsSinceEpoch == _millisecondsSinceEpoch &&
        other.isUtc == isUtc;
  }

  @override
  int get hashCode => Object.hash(_millisecondsSinceEpoch, isUtc);

  @override
  String toString() => toIso8601String();
}
