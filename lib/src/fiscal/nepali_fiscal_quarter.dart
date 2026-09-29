import 'package:meta/meta.dart';

import '../calendar/nepali_date.dart';
import '../calendar/nepali_date_range.dart';
import '../calendar/nepali_date_time.dart';
import '../conversion/bs_calendar_data.dart';
import '../core/language.dart';
import 'nepali_fiscal_year.dart';

/// The 4 standard quarters of a Nepal Government fiscal year.
enum FiscalQuarterIndex {
  /// Q1: Shrawan 1 to Ashoj end (First Quarter / प्रथम त्रैमासिक)
  q1(1, 'प्रथम त्रैमासिक', 'Q1 (First Quarter)'),

  /// Q2: Kartik 1 to Poush end (Second Quarter / दोस्रो त्रैमासिक)
  q2(2, 'दोस्रो त्रैमासिक', 'Q2 (Second Quarter)'),

  /// Q3: Magh 1 to Chaitra end (Third Quarter / तेस्रो त्रैमासिक)
  q3(3, 'तेस्रो त्रैमासिक', 'Q3 (Third Quarter)'),

  /// Q4: Baisakh 1 to Ashadh end (Fourth Quarter / चौथो त्रैमासिक)
  q4(4, 'चौथो त्रैमासिक', 'Q4 (Fourth Quarter)');

  /// 1-based quarter number (1 to 4).
  final int number;

  /// Localized name in Nepali Devanagari.
  final String nameNepali;

  /// Localized name in English.
  final String nameEnglish;

  const FiscalQuarterIndex(this.number, this.nameNepali, this.nameEnglish);

  /// Returns the localized name based on [language].
  String getName([Language language = Language.nepali]) {
    return language.isNepali ? nameNepali : nameEnglish;
  }
}

/// Represents a specific financial quarter in a Nepali fiscal year.
@immutable
class NepaliFiscalQuarter implements Comparable<NepaliFiscalQuarter> {
  /// The parent fiscal year.
  final NepaliFiscalYear fiscalYear;

  /// The quarter index (Q1 to Q4).
  final FiscalQuarterIndex quarter;

  const NepaliFiscalQuarter(this.fiscalYear, this.quarter);

  /// Resolves the fiscal quarter containing the given [date].
  ///
  /// Supports [NepaliDate], [NepaliDateTime], or [DateTime].
  factory NepaliFiscalQuarter.fromDate(dynamic date) {
    final fy = NepaliFiscalYear.fromDate(date);
    final int month;

    if (date is NepaliDate) {
      month = date.month;
    } else if (date is NepaliDateTime) {
      month = date.month;
    } else if (date is DateTime) {
      month = NepaliDate.fromDateTime(date).month;
    } else {
      throw ArgumentError.value(date, 'date', 'Unsupported date type');
    }

    FiscalQuarterIndex q;
    if (month >= 4 && month <= 6) {
      q = FiscalQuarterIndex.q1;
    } else if (month >= 7 && month <= 9) {
      q = FiscalQuarterIndex.q2;
    } else if (month >= 10 && month <= 12) {
      q = FiscalQuarterIndex.q3;
    } else {
      q = FiscalQuarterIndex.q4;
    }

    return NepaliFiscalQuarter(fy, q);
  }

  /// Current fiscal quarter based on current system time.
  factory NepaliFiscalQuarter.current() =>
      NepaliFiscalQuarter.fromDate(NepaliDate.now());

  /// The start date of this fiscal quarter as a date-only [NepaliDate].
  NepaliDate get startDate {
    return switch (quarter) {
      FiscalQuarterIndex.q1 => NepaliDate(fiscalYear.startYear, 4, 1),
      FiscalQuarterIndex.q2 => NepaliDate(fiscalYear.startYear, 7, 1),
      FiscalQuarterIndex.q3 => NepaliDate(fiscalYear.startYear, 10, 1),
      FiscalQuarterIndex.q4 => NepaliDate(fiscalYear.endYear, 1, 1),
    };
  }

  /// The end date of this fiscal quarter as a date-only [NepaliDate].
  NepaliDate get endDate {
    return switch (quarter) {
      FiscalQuarterIndex.q1 => NepaliDate(
          fiscalYear.startYear,
          6,
          BsCalendarData.getDaysInMonth(fiscalYear.startYear, 6),
        ),
      FiscalQuarterIndex.q2 => NepaliDate(
          fiscalYear.startYear,
          9,
          BsCalendarData.getDaysInMonth(fiscalYear.startYear, 9),
        ),
      FiscalQuarterIndex.q3 => NepaliDate(
          fiscalYear.startYear,
          12,
          BsCalendarData.getDaysInMonth(fiscalYear.startYear, 12),
        ),
      FiscalQuarterIndex.q4 => NepaliDate(
          fiscalYear.endYear,
          3,
          BsCalendarData.getDaysInMonth(fiscalYear.endYear, 3),
        ),
    };
  }

  /// Start date as [NepaliDateTime].
  NepaliDateTime get startDateTime => startDate.toNepaliDateTime();

  /// End date as [NepaliDateTime] (end of the day).
  NepaliDateTime get endDateTime => endDate.toNepaliDateTime().endOfDay;

  /// The [NepaliDateRange] spanning this quarter.
  NepaliDateRange get dateRange =>
      NepaliDateRange(start: startDateTime, end: endDateTime);

  /// Previous quarter.
  NepaliFiscalQuarter get previous {
    return switch (quarter) {
      FiscalQuarterIndex.q1 =>
        NepaliFiscalQuarter(fiscalYear.previous, FiscalQuarterIndex.q4),
      FiscalQuarterIndex.q2 =>
        NepaliFiscalQuarter(fiscalYear, FiscalQuarterIndex.q1),
      FiscalQuarterIndex.q3 =>
        NepaliFiscalQuarter(fiscalYear, FiscalQuarterIndex.q2),
      FiscalQuarterIndex.q4 =>
        NepaliFiscalQuarter(fiscalYear, FiscalQuarterIndex.q3),
    };
  }

  /// Next quarter.
  NepaliFiscalQuarter get next {
    return switch (quarter) {
      FiscalQuarterIndex.q1 =>
        NepaliFiscalQuarter(fiscalYear, FiscalQuarterIndex.q2),
      FiscalQuarterIndex.q2 =>
        NepaliFiscalQuarter(fiscalYear, FiscalQuarterIndex.q3),
      FiscalQuarterIndex.q3 =>
        NepaliFiscalQuarter(fiscalYear, FiscalQuarterIndex.q4),
      FiscalQuarterIndex.q4 =>
        NepaliFiscalQuarter(fiscalYear.next, FiscalQuarterIndex.q1),
    };
  }

  /// Returns `true` if this quarter contains the given [date].
  bool contains(dynamic date) {
    if (date is NepaliDate) {
      return !date.isBefore(startDate) && !date.isAfter(endDate);
    } else if (date is NepaliDateTime) {
      return contains(date.toNepaliDate());
    } else if (date is DateTime) {
      return contains(NepaliDate.fromDateTime(date));
    }
    return false;
  }

  /// Label for reporting (e.g. `"२०८१/८२ Q1"` or `"2081/82 Q1"`).
  String format([Language language = Language.nepali]) {
    final fyStr = fiscalYear.format(language);
    final qStr = 'Q${quarter.number}';
    return '$fyStr $qStr';
  }

  /// Returns `true` if this quarter is strictly before [other].
  bool isBefore(NepaliFiscalQuarter other) => compareTo(other) < 0;

  /// Returns `true` if this quarter is strictly after [other].
  bool isAfter(NepaliFiscalQuarter other) => compareTo(other) > 0;

  /// Returns `true` if this quarter is before or same as [other].
  bool isAtOrBefore(NepaliFiscalQuarter other) => compareTo(other) <= 0;

  /// Returns `true` if this quarter is after or same as [other].
  bool isAtOrAfter(NepaliFiscalQuarter other) => compareTo(other) >= 0;

  bool operator <(NepaliFiscalQuarter other) => compareTo(other) < 0;
  bool operator <=(NepaliFiscalQuarter other) => compareTo(other) <= 0;
  bool operator >(NepaliFiscalQuarter other) => compareTo(other) > 0;
  bool operator >=(NepaliFiscalQuarter other) => compareTo(other) >= 0;

  @override
  int compareTo(NepaliFiscalQuarter other) {
    final fyComp = fiscalYear.compareTo(other.fiscalYear);
    if (fyComp != 0) return fyComp;
    return quarter.number.compareTo(other.quarter.number);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NepaliFiscalQuarter &&
          other.fiscalYear == fiscalYear &&
          other.quarter == quarter;

  @override
  int get hashCode => Object.hash(fiscalYear, quarter);

  @override
  String toString() =>
      '${fiscalYear.format(Language.english)} Q${quarter.number}';
}
