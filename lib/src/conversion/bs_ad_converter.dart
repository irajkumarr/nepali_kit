import '../core/constants.dart';
import '../core/exceptions.dart';
import 'bs_calendar_data.dart';

/// Core bidirectional converter between Bikram Sambat (BS) and Gregorian (AD) dates.
class BsAdConverter {
  BsAdConverter._();

  // Cached cumulative days table from anchor (BS 1969-01-01 / AD 1912-04-12)
  static final List<int> _cumulativeDaysByYear = _initCumulativeDays();

  static List<int> _initCumulativeDays() {
    final list = <int>[0];
    int total = 0;
    for (int i = 0; i < BsCalendarData.monthData.length; i++) {
      int yearDays = 0;
      for (final days in BsCalendarData.monthData[i]) {
        yearDays += days;
      }
      total += yearDays;
      list.add(total);
    }
    return list;
  }

  /// Converts a Bikram Sambat date to Gregorian AD components `(year, month, day)`.
  static (int year, int month, int day) bsToAd(
      int bsYear, int bsMonth, int bsDay) {
    if (bsYear < NepaliCalendarConstants.minBsYear ||
        bsYear > NepaliCalendarConstants.maxBsYear) {
      throw ConversionOutOfBoundsException(
        'Bikram Sambat year falls outside supported calendar range.',
        value: bsYear,
        minBound: NepaliCalendarConstants.minBsYear,
        maxBound: NepaliCalendarConstants.maxBsYear,
      );
    }

    if (!BsCalendarData.isValidBsDate(bsYear, bsMonth, bsDay)) {
      throw NepaliDateException(
        'Invalid Bikram Sambat date.',
        year: bsYear,
        month: bsMonth,
        day: bsDay,
      );
    }

    final yearIndex = bsYear - NepaliCalendarConstants.minBsYear;
    int daysOffset = _cumulativeDaysByYear[yearIndex];

    final months = BsCalendarData.monthData[yearIndex];
    for (int m = 0; m < bsMonth - 1; m++) {
      daysOffset += months[m];
    }
    daysOffset += (bsDay - 1);

    final adDate = BsCalendarData.anchorAdDate.add(Duration(days: daysOffset));
    return (adDate.year, adDate.month, adDate.day);
  }

  /// Converts a Gregorian AD date components `(year, month, day)` to Bikram Sambat `(year, month, day)`.
  static (int year, int month, int day) adToBs(
      int adYear, int adMonth, int adDay) {
    final targetAd = DateTime.utc(adYear, adMonth, adDay);
    final daysOffset = targetAd.difference(BsCalendarData.anchorAdDate).inDays;

    if (daysOffset < 0 || daysOffset >= _cumulativeDaysByYear.last) {
      throw ConversionOutOfBoundsException(
        'Gregorian date falls outside supported Bikram Sambat conversion range.',
        value: adYear,
        minBound: NepaliCalendarConstants.minAdYear,
        maxBound: NepaliCalendarConstants.maxAdYear,
      );
    }

    // Binary search to find the BS year
    int low = 0;
    int high = _cumulativeDaysByYear.length - 2;
    int yearIndex = 0;

    while (low <= high) {
      final mid = (low + high) ~/ 2;
      if (_cumulativeDaysByYear[mid] <= daysOffset) {
        yearIndex = mid;
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }

    int remainingDays = daysOffset - _cumulativeDaysByYear[yearIndex];
    final bsYear = NepaliCalendarConstants.minBsYear + yearIndex;
    final months = BsCalendarData.monthData[yearIndex];

    int bsMonth = 1;
    for (int m = 0; m < 12; m++) {
      if (remainingDays < months[m]) {
        bsMonth = m + 1;
        break;
      }
      remainingDays -= months[m];
    }

    final bsDay = remainingDays + 1;
    return (bsYear, bsMonth, bsDay);
  }
}
