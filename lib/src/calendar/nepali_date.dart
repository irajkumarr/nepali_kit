import 'package:meta/meta.dart';

import '../conversion/bs_ad_converter.dart';
import '../conversion/bs_calendar_data.dart';
import '../core/constants.dart';
import '../core/exceptions.dart';
import '../numbers/nepali_digits.dart';
import 'nepali_date_range.dart';
import 'nepali_date_time.dart';
import 'nepali_month.dart';
import 'nepali_weekday.dart';

/// An immutable date-only representation in the Bikram Sambat (BS) calendar.
///
/// Unlike [NepaliDateTime], [NepaliDate] contains strictly year, month, and day components,
/// completely eliminating timezone conversions or time-of-day offsets.
@immutable
class NepaliDate implements Comparable<NepaliDate> {
  /// The Bikram Sambat year (e.g. 2081).
  final int year;

  /// The month of the year (1 to 12).
  final int month;

  /// The day of the month (1 to 32).
  final int day;

  /// Creates an immutable [NepaliDate].
  ///
  /// Throws [NepaliDateException] if the date is invalid or falls outside
  /// the supported range [NepaliCalendarConstants.minBsYear]–[NepaliCalendarConstants.maxBsYear].
  NepaliDate(this.year, [this.month = 1, this.day = 1]) {
    if (!BsCalendarData.isValidBsDate(year, month, day)) {
      throw NepaliDateException(
        'Invalid Bikram Sambat date components.',
        year: year,
        month: month,
        day: day,
      );
    }
  }

  /// Constructs a [NepaliDate] representing the current date in local time.
  factory NepaliDate.now() {
    final now = DateTime.now();
    final (y, m, d) = BsAdConverter.adToBs(now.year, now.month, now.day);
    return NepaliDate(y, m, d);
  }

  /// Constructs a [NepaliDate] from a standard Gregorian [DateTime].
  factory NepaliDate.fromDateTime(DateTime dateTime) {
    final (y, m, d) = BsAdConverter.adToBs(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );
    return NepaliDate(y, m, d);
  }

  /// Converts this [NepaliDate] into a [NepaliDateTime] with time set to 00:00:00.
  NepaliDateTime toNepaliDateTime({
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
    bool isUtc = false,
  }) {
    return isUtc
        ? NepaliDateTime.utc(
            year,
            month,
            day,
            hour,
            minute,
            second,
            millisecond,
            microsecond,
          )
        : NepaliDateTime(
            year,
            month,
            day,
            hour,
            minute,
            second,
            millisecond,
            microsecond,
          );
  }

  /// Converts this [NepaliDate] to a Gregorian AD [DateTime] at midnight (00:00:00 UTC).
  DateTime toDateTime() {
    final (adYear, adMonth, adDay) = BsAdConverter.bsToAd(year, month, day);
    return DateTime.utc(adYear, adMonth, adDay);
  }

  /// Alias for [toDateTime].
  DateTime toGregorianDateTime() => toDateTime();

  /// Strongly-typed month enum representation.
  NepaliMonth get nepaliMonth => NepaliMonth.fromIndex(month);

  /// Strongly-typed weekday enum representation.
  NepaliWeekday get nepaliWeekday => NepaliWeekday.fromIndex(weekday);

  /// Day of the week (1 = Sunday / Aaitabar, ..., 7 = Saturday / Sanibar).
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

  /// Total number of days in this specific month and year.
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

  /// Whether this day is Saturday (standard weekend in Nepal).
  bool get isSaturday => weekday == 7;

  /// Alias for [isSaturday].
  bool get isWeekend => isSaturday;

  /// Whether this date represents today in the local system time.
  bool get isToday {
    final now = NepaliDate.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// The start date of the current month (day 1).
  NepaliDate get startOfMonth => NepaliDate(year, month, 1);

  /// The end date of the current month.
  NepaliDate get endOfMonth => NepaliDate(year, month, totalDaysInMonth);

  /// The [NepaliDateRange] spanning this entire month.
  NepaliDateRange get monthRange =>
      NepaliDateRange(start: startOfMonth, end: endOfMonth);

  /// The start date of the current year (Baisakh 1).
  NepaliDate get startOfYear => NepaliDate(year, 1, 1);

  /// The end date of the current year (Chaitra last day).
  NepaliDate get endOfYear =>
      NepaliDate(year, 12, BsCalendarData.getDaysInMonth(year, 12));

  /// The [NepaliDateRange] spanning this entire year.
  NepaliDateRange get yearRange =>
      NepaliDateRange(start: startOfYear, end: endOfYear);

  /// Returns the first day of the next chronological month.
  NepaliDate get nextMonth {
    if (month == 12) {
      return NepaliDate(year + 1, 1, 1);
    }
    return NepaliDate(year, month + 1, 1);
  }

  /// Returns the first day of the previous chronological month.
  NepaliDate get previousMonth {
    if (month == 1) {
      return NepaliDate(year - 1, 12, 1);
    }
    return NepaliDate(year, month - 1, 1);
  }

  /// Adds a number of days to this date, handling month and year rollover correctly.
  NepaliDate addDays(int days) {
    if (days == 0) return this;
    final ad = toDateTime().add(Duration(days: days));
    return NepaliDate.fromDateTime(ad);
  }

  /// Subtracts a number of days from this date.
  NepaliDate subtractDays(int days) => addDays(-days);

  /// Adds a number of months to this date, adjusting year and clamping days if target month has fewer days.
  NepaliDate addMonths(int months) {
    if (months == 0) return this;
    final totalMonths = (year * 12 + (month - 1)) + months;
    final targetYear = totalMonths ~/ 12;
    final targetMonth = (totalMonths % 12) + 1;
    final maxDays = BsCalendarData.getDaysInMonth(targetYear, targetMonth);
    final targetDay = day > maxDays ? maxDays : day;
    return NepaliDate(targetYear, targetMonth, targetDay);
  }

  /// Subtracts a number of months from this date.
  NepaliDate subtractMonths(int months) => addMonths(-months);

  /// Adds a number of years to this date, clamping days if target year has fewer days in this month.
  NepaliDate addYears(int years) {
    if (years == 0) return this;
    final targetYear = year + years;
    final maxDays = BsCalendarData.getDaysInMonth(targetYear, month);
    final targetDay = day > maxDays ? maxDays : day;
    return NepaliDate(targetYear, month, targetDay);
  }

  /// Subtracts a number of years from this date.
  NepaliDate subtractYears(int years) => addYears(-years);

  /// Adds [duration] to this date (taking only whole days).
  NepaliDate add(Duration duration) => addDays(duration.inDays);

  /// Subtracts [duration] from this date.
  NepaliDate subtract(Duration duration) => addDays(-duration.inDays);

  /// Computes the difference as a [Duration] between this and [other].
  Duration difference(NepaliDate other) {
    return toDateTime().difference(other.toDateTime());
  }

  /// Computes the difference in days between this and [other].
  int differenceInDays(NepaliDate other) {
    return difference(other).inDays;
  }

  /// Returns `true` if this date is strictly before [other].
  bool isBefore(NepaliDate other) {
    if (year != other.year) return year < other.year;
    if (month != other.month) return month < other.month;
    return day < other.day;
  }

  /// Returns `true` if this date is strictly after [other].
  bool isAfter(NepaliDate other) {
    if (year != other.year) return year > other.year;
    if (month != other.month) return month > other.month;
    return day > other.day;
  }

  /// Returns `true` if this date is the same calendar day as [other].
  bool isAtSameMomentAs(NepaliDate other) => this == other;

  /// Returns `true` if this date is before or at the same moment as [other].
  bool isAtOrBefore(NepaliDate other) => isBefore(other) || this == other;

  /// Returns `true` if this date is after or at the same moment as [other].
  bool isAtOrAfter(NepaliDate other) => isAfter(other) || this == other;

  /// Returns `true` if this date is strictly before [other].
  bool operator <(NepaliDate other) => isBefore(other);

  /// Returns `true` if this date is before or equal to [other].
  bool operator <=(NepaliDate other) => isBefore(other) || this == other;

  /// Returns `true` if this date is strictly after [other].
  bool operator >(NepaliDate other) => isAfter(other);

  /// Returns `true` if this date is after or equal to [other].
  bool operator >=(NepaliDate other) => isAfter(other) || this == other;

  @override
  int compareTo(NepaliDate other) {
    if (year != other.year) return year.compareTo(other.year);
    if (month != other.month) return month.compareTo(other.month);
    return day.compareTo(other.day);
  }

  /// Creates a copy of this date with specified fields replaced.
  NepaliDate copyWith({int? year, int? month, int? day}) {
    return NepaliDate(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
    );
  }

  /// Returns an ISO-formatted string representation (`YYYY-MM-DD`).
  String toIso8601String() {
    final y = year.toString().padLeft(4, '0');
    final m = month.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Parses a string into a [NepaliDate]. Supports `YYYY-MM-DD` or `YYYY/MM/DD`.
  static NepaliDate parse(String formattedString) {
    final parsed = tryParse(formattedString);
    if (parsed == null) {
      throw NepaliDateParseException(
        'Could not parse string into NepaliDate.',
        source: formattedString,
      );
    }
    return parsed;
  }

  /// Like [parse], but returns `null` instead of throwing on invalid input.
  static NepaliDate? tryParse(String formattedString) {
    try {
      final normalized = NepaliDigits.toEnglish(formattedString.trim());
      final regex = RegExp(r'^(\d{4})[-/](\d{1,2})[-/](\d{1,2})$');
      final match = regex.firstMatch(normalized);
      if (match == null) return null;

      final year = int.parse(match.group(1)!);
      final month = int.parse(match.group(2)!);
      final day = int.parse(match.group(3)!);

      if (!BsCalendarData.isValidBsDate(year, month, day)) return null;
      return NepaliDate(year, month, day);
    } catch (_) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NepaliDate &&
        other.year == year &&
        other.month == month &&
        other.day == day;
  }

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => toIso8601String();
}
