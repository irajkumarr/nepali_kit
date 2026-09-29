import 'package:meta/meta.dart';

import '../calendar/nepali_date.dart';
import '../calendar/nepali_date_range.dart';
import '../calendar/nepali_date_time.dart';
import '../calendar/nepali_month.dart';
import '../conversion/bs_calendar_data.dart';
import '../core/constants.dart';
import '../core/exceptions.dart';
import '../core/language.dart';
import '../numbers/nepali_digits.dart';
import 'nepali_fiscal_quarter.dart';

/// Represents a Nepal Government Fiscal Year (आर्थिक वर्ष).
///
/// ### Definition:
/// In Nepal, a fiscal year begins on **Shrawan 1** (approx. mid-July) of the starting BS year
/// and concludes on the **last day of Ashadh** (approx. mid-July) of the subsequent BS year.
///
/// For example, the fiscal year **2081/82** (२०८१/८२) spans from **2081-04-01** (Shrawan 1, 2081 BS)
/// to **2082-03-31/32** (Ashadh last day, 2082 BS).
@immutable
class NepaliFiscalYear implements Comparable<NepaliFiscalYear> {
  /// The starting Bikram Sambat year (e.g. 2081 for fiscal year 2081/82).
  final int startYear;

  /// The ending Bikram Sambat year (e.g. 2082 for fiscal year 2081/82).
  final int endYear;

  /// Creates a [NepaliFiscalYear] starting at [startYear].
  ///
  /// Throws [ConversionOutOfBoundsException] if [startYear] falls outside the supported
  /// Bikram Sambat calendar range.
  NepaliFiscalYear(this.startYear) : endYear = startYear + 1 {
    if (startYear < NepaliCalendarConstants.minBsYear ||
        endYear > NepaliCalendarConstants.maxBsYear) {
      throw ConversionOutOfBoundsException(
        'Fiscal year $startYear/${endYear % 100} falls outside supported calendar range.',
        value: startYear,
        minBound: NepaliCalendarConstants.minBsYear,
        maxBound: NepaliCalendarConstants.maxBsYear - 1,
      );
    }
  }

  /// Determines the fiscal year containing the given [date].
  ///
  /// Supports [NepaliDate], [NepaliDateTime], or Gregorian [DateTime].
  factory NepaliFiscalYear.fromDate(dynamic date) {
    final int year;
    final int month;

    if (date is NepaliDate) {
      year = date.year;
      month = date.month;
    } else if (date is NepaliDateTime) {
      year = date.year;
      month = date.month;
    } else if (date is DateTime) {
      final nepali = NepaliDate.fromDateTime(date);
      year = nepali.year;
      month = nepali.month;
    } else {
      throw ArgumentError.value(
        date,
        'date',
        'Expected NepaliDate, NepaliDateTime, or DateTime',
      );
    }

    // Shrawan (4) to Chaitra (12) -> begins in the current year.
    // Baisakh (1) to Ashadh (3) -> belongs to the fiscal year started in the previous year.
    if (month >= NepaliMonth.shrawan.number) {
      return NepaliFiscalYear(year);
    } else {
      return NepaliFiscalYear(year - 1);
    }
  }

  /// Resolves the current fiscal year based on current system time.
  factory NepaliFiscalYear.current() =>
      NepaliFiscalYear.fromDate(NepaliDate.now());

  /// Parses a fiscal year label such as `"2081/82"`, `"2081/2082"`, or `"२०८१/८२"`.
  factory NepaliFiscalYear.parse(String label) {
    final parsed = tryParse(label);
    if (parsed == null) {
      throw NepaliDateParseException(
        'Invalid fiscal year label format.',
        source: label,
        pattern: 'YYYY/YY',
      );
    }
    return parsed;
  }

  /// Safely parses a fiscal year label, returning `null` on invalid formats.
  static NepaliFiscalYear? tryParse(String label) {
    try {
      final cleaned = NepaliDigits.toEnglish(label.trim());
      final parts = cleaned.split('/');
      if (parts.length != 2) return null;

      final start = int.tryParse(parts[0]);
      final second = int.tryParse(parts[1]);
      if (start == null || second == null) return null;

      // Verify the second part is start + 1 (either 2 digits or 4 digits)
      final expectedShort = (start + 1) % 100;
      final expectedFull = start + 1;
      if (second != expectedShort && second != expectedFull) return null;

      return NepaliFiscalYear(start);
    } catch (_) {
      return null;
    }
  }

  /// The start date of this fiscal year (Shrawan 1) as a [NepaliDate].
  NepaliDate get startDate => NepaliDate(startYear, 4, 1);

  /// The end date of this fiscal year (Ashadh last day) as a [NepaliDate].
  NepaliDate get endDate =>
      NepaliDate(endYear, 3, BsCalendarData.getDaysInMonth(endYear, 3));

  /// The start date of this fiscal year (Shrawan 1, 00:00:00) as a [NepaliDateTime].
  NepaliDateTime get startDateTime => NepaliDateTime(startYear, 4, 1);

  /// The end date of this fiscal year (Ashadh last day, 23:59:59) as a [NepaliDateTime].
  NepaliDateTime get endDateTime =>
      NepaliDateTime(endYear, 3, BsCalendarData.getDaysInMonth(endYear, 3))
          .endOfDay;

  /// The Gregorian AD start date.
  DateTime get adStartDate => startDate.toDateTime();

  /// The Gregorian AD end date.
  DateTime get adEndDate => endDate.toDateTime();

  /// The complete [NepaliDateRange] spanning this entire fiscal year.
  NepaliDateRange get dateRange =>
      NepaliDateRange(start: startDateTime, end: endDateTime);

  /// The preceding fiscal year.
  NepaliFiscalYear get previous => NepaliFiscalYear(startYear - 1);

  /// The following fiscal year.
  NepaliFiscalYear get next => NepaliFiscalYear(startYear + 1);

  /// Returns `true` if the given [date] (BS or AD) falls within this fiscal year.
  bool contains(dynamic date) {
    if (date is NepaliDate) {
      return !date.isBefore(startDate) && !date.isAfter(endDate);
    } else if (date is NepaliDateTime) {
      return date.isAfter(startDateTime) || date.isAtSameMomentAs(startDateTime)
          ? date.isBefore(endDateTime) || date.isAtSameMomentAs(endDateTime)
          : false;
    } else if (date is DateTime) {
      final nepali = NepaliDate.fromDateTime(date);
      return contains(nepali);
    }
    return false;
  }

  /// Formats the fiscal year label (e.g. `"२०८१/८२"` or `"2081/82"`).
  ///
  /// If [shortEndYear] is false, renders full 4-digit end year: `"2081/2082"`.
  String format(
      [Language language = Language.nepali, bool shortEndYear = true]) {
    final s = startYear.toString();
    final e = shortEndYear
        ? (endYear % 100).toString().padLeft(2, '0')
        : endYear.toString();
    final formatted = '$s/$e';
    return language.isNepali ? NepaliDigits.toNepali(formatted) : formatted;
  }

  /// Standard fiscal year label (alias for [format]).
  String get label => format(Language.nepali);

  /// English fiscal year label (e.g. `"FY 2081/82"`).
  String get labelEnglish => 'FY ${format(Language.english)}';

  /// All 4 financial quarters in chronological order for this fiscal year.
  List<NepaliFiscalQuarter> get quarters => [
        NepaliFiscalQuarter(this, FiscalQuarterIndex.q1),
        NepaliFiscalQuarter(this, FiscalQuarterIndex.q2),
        NepaliFiscalQuarter(this, FiscalQuarterIndex.q3),
        NepaliFiscalQuarter(this, FiscalQuarterIndex.q4),
      ];

  /// Returns `true` if this fiscal year is strictly before [other].
  bool isBefore(NepaliFiscalYear other) => startYear < other.startYear;

  /// Returns `true` if this fiscal year is strictly after [other].
  bool isAfter(NepaliFiscalYear other) => startYear > other.startYear;

  /// Returns `true` if this fiscal year is before or same as [other].
  bool isAtOrBefore(NepaliFiscalYear other) => startYear <= other.startYear;

  /// Returns `true` if this fiscal year is after or same as [other].
  bool isAtOrAfter(NepaliFiscalYear other) => startYear >= other.startYear;

  bool operator <(NepaliFiscalYear other) => startYear < other.startYear;
  bool operator <=(NepaliFiscalYear other) => startYear <= other.startYear;
  bool operator >(NepaliFiscalYear other) => startYear > other.startYear;
  bool operator >=(NepaliFiscalYear other) => startYear >= other.startYear;

  @override
  int compareTo(NepaliFiscalYear other) => startYear.compareTo(other.startYear);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NepaliFiscalYear && other.startYear == startYear;

  @override
  int get hashCode => startYear.hashCode;

  @override
  String toString() => format(Language.english);
}
