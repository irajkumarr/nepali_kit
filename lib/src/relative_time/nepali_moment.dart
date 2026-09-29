import '../calendar/nepali_date.dart';
import '../calendar/nepali_date_time.dart';
import '../core/language.dart';
import '../numbers/nepali_digits.dart';

/// Formatter for relative timestamps ("time ago", "just now", and future relative moments).
///
/// Supports seconds, minutes, hours, days (yesterday, today, tomorrow), weeks, months, and years
/// in both Nepali Devanagari and English with grammatically accurate pluralization.
class NepaliMoment {
  NepaliMoment._();

  /// Formats the relative difference between [date] and [referenceDate] (defaults to now).
  ///
  /// Accepts [NepaliDate], [NepaliDateTime], or Gregorian [DateTime].
  static String fromDate(
    dynamic date, {
    dynamic referenceDate,
    Language language = Language.nepali,
    bool showSeconds = true,
  }) {
    final NepaliDateTime targetDt;
    if (date is NepaliDate) {
      targetDt = date.toNepaliDateTime();
    } else if (date is NepaliDateTime) {
      targetDt = date;
    } else if (date is DateTime) {
      targetDt = NepaliDateTime.fromDateTime(date);
    } else {
      throw ArgumentError.value(
        date,
        'date',
        'Expected NepaliDate, NepaliDateTime, or DateTime',
      );
    }

    final NepaliDateTime refDt;
    if (referenceDate == null) {
      refDt = NepaliDateTime.now();
    } else if (referenceDate is NepaliDate) {
      refDt = referenceDate.toNepaliDateTime();
    } else if (referenceDate is NepaliDateTime) {
      refDt = referenceDate;
    } else if (referenceDate is DateTime) {
      refDt = NepaliDateTime.fromDateTime(referenceDate);
    } else {
      throw ArgumentError.value(
        referenceDate,
        'referenceDate',
        'Expected NepaliDate, NepaliDateTime, or DateTime',
      );
    }

    final difference = refDt.difference(targetDt);
    final isPast = !difference.isNegative;
    final duration = difference.abs();

    final inSeconds = duration.inSeconds;
    final inMinutes = duration.inMinutes;
    final inHours = duration.inHours;
    final inDays = duration.inDays;

    // Check calendar day relationship (today, yesterday, tomorrow)
    final isSameCalendarDay = targetDt.year == refDt.year &&
        targetDt.month == refDt.month &&
        targetDt.day == refDt.day;

    if (isSameCalendarDay) {
      if (inSeconds < 45) {
        return language.isNepali ? 'भर्खरै' : 'just now';
      }

      if (inMinutes < 60) {
        final count = inMinutes <= 0 ? 1 : inMinutes;
        if (language.isNepali) {
          final countStr = NepaliDigits.toNepali(count);
          return isPast ? '$countStr मिनेट अगाडि' : '$countStr मिनेट पछि';
        } else {
          final unit = count == 1 ? 'minute' : 'minutes';
          return isPast ? '$count $unit ago' : 'in $count $unit';
        }
      }

      final count = inHours <= 0 ? 1 : inHours;
      if (language.isNepali) {
        final countStr = NepaliDigits.toNepali(count);
        return isPast ? '$countStr घण्टा अगाडि' : '$countStr घण्टा पछि';
      } else {
        final unit = count == 1 ? 'hour' : 'hours';
        return isPast ? '$count $unit ago' : 'in $count $unit';
      }
    }

    // Yesterday / Tomorrow check based on calendar date difference
    final dayDifference =
        targetDt.toNepaliDate().differenceInDays(refDt.toNepaliDate());
    if (dayDifference == -1) {
      return language.isNepali ? 'हिजो' : 'yesterday';
    }
    if (dayDifference == 1) {
      return language.isNepali ? 'भोलि' : 'tomorrow';
    }
    if (dayDifference == -2) {
      return language.isNepali ? 'अस्ति' : '2 days ago';
    }
    if (dayDifference == 2) {
      return language.isNepali ? 'पर्सि' : 'in 2 days';
    }

    // Days (3 - 6 days)
    if (inDays < 7) {
      final count = inDays;
      if (language.isNepali) {
        final countStr = NepaliDigits.toNepali(count);
        return isPast ? '$countStr दिन अगाडि' : '$countStr दिन पछि';
      } else {
        final unit = count == 1 ? 'day' : 'days';
        return isPast ? '$count $unit ago' : 'in $count $unit';
      }
    }

    // Weeks (1 - 3 weeks)
    final inWeeks = (inDays / 7).floor();
    if (inDays < 30) {
      if (language.isNepali) {
        final countStr = NepaliDigits.toNepali(inWeeks);
        return isPast ? '$countStr हप्ता अगाडि' : '$countStr हप्ता पछि';
      } else {
        final unit = inWeeks == 1 ? 'week' : 'weeks';
        return isPast ? '$inWeeks $unit ago' : 'in $inWeeks $unit';
      }
    }

    // Months (1 - 11 months)
    final inMonths = (inDays / 30.4).floor();
    if (inMonths < 12) {
      final count = inMonths <= 0 ? 1 : inMonths;
      if (language.isNepali) {
        final countStr = NepaliDigits.toNepali(count);
        return isPast ? '$countStr महिना अगाडि' : '$countStr महिना पछि';
      } else {
        final unit = count == 1 ? 'month' : 'months';
        return isPast ? '$count $unit ago' : 'in $count $unit';
      }
    }

    // Years
    final inYears = (inDays / 365.25).floor();
    final count = inYears <= 0 ? 1 : inYears;
    if (language.isNepali) {
      final countStr = NepaliDigits.toNepali(count);
      return isPast ? '$countStr वर्ष अगाडि' : '$countStr वर्ष पछि';
    } else {
      final unit = count == 1 ? 'year' : 'years';
      return isPast ? '$count $unit ago' : 'in $count $unit';
    }
  }
}
