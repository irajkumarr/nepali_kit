import 'package:nepali_kit/nepali_kit_core.dart';
import 'package:test/test.dart';

void main() {
  group('Deterministic BS ↔ AD ↔ BS Invariant Tests', () {
    test('Every month across all 125 supported years converts consistently',
        () {
      for (int year = NepaliCalendarConstants.minBsYear;
          year <= NepaliCalendarConstants.maxBsYear;
          year++) {
        for (int month = 1; month <= 12; month++) {
          final maxDay = BsCalendarData.getDaysInMonth(year, month);

          // Test first day, middle day, and last day of every month
          final sampleDays = [1, 15, maxDay];
          for (final day in sampleDays) {
            final (adY, adM, adD) = BsAdConverter.bsToAd(year, month, day);
            final (bsY, bsM, bsD) = BsAdConverter.adToBs(adY, adM, adD);

            expect(bsY, equals(year),
                reason: 'Failed year round trip for BS $year-$month-$day');
            expect(bsM, equals(month),
                reason: 'Failed month round trip for BS $year-$month-$day');
            expect(bsD, equals(day),
                reason: 'Failed day round trip for BS $year-$month-$day');
          }
        }
      }
    });

    test('Boundary dates convert accurately', () {
      // First supported BS date: 1975-01-01 -> 1918-04-13
      final (firstAdY, firstAdM, firstAdD) = BsAdConverter.bsToAd(1975, 1, 1);
      expect(firstAdY, equals(1918));
      expect(firstAdM, equals(4));
      expect(firstAdD, equals(13));

      final (backFirstBsY, backFirstBsM, backFirstBsD) =
          BsAdConverter.adToBs(1918, 4, 13);
      expect(backFirstBsY, equals(1975));
      expect(backFirstBsM, equals(1));
      expect(backFirstBsD, equals(1));

      // Last supported BS date: 2099-12-30 -> 2043-04-13
      final lastDay = BsCalendarData.getDaysInMonth(2099, 12);
      final (lastAdY, lastAdM, lastAdD) =
          BsAdConverter.bsToAd(2099, 12, lastDay);
      expect(lastAdY, equals(2043));
      expect(lastAdM, equals(4));
      expect(lastAdD, equals(13));

      final (backLastBsY, backLastBsM, backLastBsD) =
          BsAdConverter.adToBs(2043, 4, 13);
      expect(backLastBsY, equals(2099));
      expect(backLastBsM, equals(12));
      expect(backLastBsD, equals(lastDay));
    });

    test('AD → BS → AD round trip preserves valid dates', () {
      final adSamples = [
        DateTime.utc(1918, 4, 13),
        DateTime.utc(1950, 1, 1),
        DateTime.utc(2000, 2, 29), // Leap year in AD
        DateTime.utc(2024, 4, 13),
        DateTime.utc(2024, 9, 29),
        DateTime.utc(2043, 4, 13),
      ];

      for (final ad in adSamples) {
        final (bsY, bsM, bsD) = BsAdConverter.adToBs(ad.year, ad.month, ad.day);
        final (resAdY, resAdM, resAdD) = BsAdConverter.bsToAd(bsY, bsM, bsD);

        expect(resAdY, equals(ad.year));
        expect(resAdM, equals(ad.month));
        expect(resAdD, equals(ad.day));
      }
    });

    test('Out of bounds conversion throws ConversionOutOfBoundsException', () {
      expect(
        () => BsAdConverter.bsToAd(1974, 1, 1),
        throwsA(isA<ConversionOutOfBoundsException>()),
      );
      expect(
        () => BsAdConverter.bsToAd(2100, 1, 1),
        throwsA(isA<ConversionOutOfBoundsException>()),
      );
      expect(
        () => BsAdConverter.adToBs(1917, 12, 31),
        throwsA(isA<ConversionOutOfBoundsException>()),
      );
      expect(
        () => BsAdConverter.adToBs(2044, 1, 1),
        throwsA(isA<ConversionOutOfBoundsException>()),
      );
    });
  });

  group('NepaliDate date-only unit tests', () {
    test('construction, start/end of month/year, dayOfYear', () {
      final date = NepaliDate(2081, 6, 13);
      expect(date.year, equals(2081));
      expect(date.month, equals(6));
      expect(date.day, equals(13));
      expect(date.nepaliMonth, equals(NepaliMonth.ashwin));
      expect(date.startOfMonth, equals(NepaliDate(2081, 6, 1)));
      expect(date.endOfMonth, equals(NepaliDate(2081, 6, 30)));
      expect(date.startOfYear, equals(NepaliDate(2081, 1, 1)));
      expect(date.endOfYear, equals(NepaliDate(2081, 12, 30)));
      expect(date.dayOfYear, equals(31 + 31 + 32 + 32 + 31 + 13));
      expect(date.totalDaysInMonth, equals(30));
    });

    test('month and year rollover arithmetic', () {
      // End of Ashwin to Kartik 1
      final endOfAshwin = NepaliDate(2081, 6, 30);
      final nextDay = endOfAshwin.addDays(1);
      expect(nextDay, equals(NepaliDate(2081, 7, 1)));

      final prevDay = nextDay.subtractDays(1);
      expect(prevDay, equals(endOfAshwin));

      // End of Chaitra 2081 to Baisakh 1, 2082
      final endOfYear = NepaliDate(2081, 12, 30);
      final newYearDay = endOfYear.addDays(1);
      expect(newYearDay, equals(NepaliDate(2082, 1, 1)));

      final prevYearLastDay = newYearDay.subtractDays(1);
      expect(prevYearLastDay, equals(endOfYear));
    });

    test('comparisons, equality, hashCode', () {
      final d1 = NepaliDate(2081, 6, 13);
      final d2 = NepaliDate(2081, 6, 14);
      final d3 = NepaliDate(2081, 6, 13);

      expect(d1.isBefore(d2), isTrue);
      expect(d2.isAfter(d1), isTrue);
      expect(d1.isAtSameMomentAs(d3), isTrue);
      expect(d1.isAtOrBefore(d2), isTrue);
      expect(d1.isAtOrBefore(d3), isTrue);
      expect(d2.isAtOrAfter(d1), isTrue);
      expect(d1.isAtOrAfter(d3), isTrue);
      // Operator tests
      expect(d1 < d2, isTrue);
      expect(d1 <= d2, isTrue);
      expect(d1 <= d3, isTrue);
      expect(d2 > d1, isTrue);
      expect(d2 >= d1, isTrue);
      expect(d1 >= d3, isTrue);
      expect(d1.compareTo(d2), isNegative);
      expect(d2.compareTo(d1), isPositive);
      expect(d1.compareTo(d3), isZero);
      expect(d1, equals(d3));
      expect(d1.hashCode, equals(d3.hashCode));
      expect(d1.differenceInDays(d2), equals(-1));
      expect(d2.differenceInDays(d1), equals(1));
    });

    test('parsing and tryParse with ASCII and Devanagari numerals', () {
      expect(NepaliDate.parse('2081-06-13'), equals(NepaliDate(2081, 6, 13)));
      expect(NepaliDate.parse('2081/6/13'), equals(NepaliDate(2081, 6, 13)));
      expect(NepaliDate.parse('२०८१-०६-१३'), equals(NepaliDate(2081, 6, 13)));
      expect(NepaliDate.tryParse('invalid-date'), isNull);
      expect(NepaliDate.tryParse('2081-02-35'), isNull);
    });

    test('nextMonth, previousMonth, monthRange, and yearRange on NepaliDate',
        () {
      final date = NepaliDate(2081, 6, 15);
      expect(date.nextMonth, equals(NepaliDate(2081, 7, 1)));
      expect(date.previousMonth, equals(NepaliDate(2081, 5, 1)));

      final chaitra = NepaliDate(2081, 12, 10);
      expect(chaitra.nextMonth, equals(NepaliDate(2082, 1, 1)));

      final baisakh = NepaliDate(2081, 1, 10);
      expect(baisakh.previousMonth, equals(NepaliDate(2080, 12, 1)));

      expect(date.daysInMonth, equals(date.totalDaysInMonth));
      expect(date.daysInYear, equals(date.totalDaysInYear));
      expect(date.isLeapYear, isA<bool>());

      final mRange = date.monthRange;
      expect(mRange.startDate, equals(NepaliDate(2081, 6, 1)));
      expect(mRange.endDate, equals(NepaliDate(2081, 6, 30)));

      final yRange = date.yearRange;
      expect(yRange.startDate, equals(NepaliDate(2081, 1, 1)));
      expect(yRange.endDate, equals(NepaliDate(2081, 12, 30)));
    });
  });

  group('NepaliDateTime parity and boundaries', () {
    test('startOfDay and endOfDay', () {
      final dt = NepaliDateTime(2081, 6, 13, 14, 25, 30);
      final start = dt.startOfDay;
      expect(start.hour, equals(0));
      expect(start.minute, equals(0));
      expect(start.second, equals(0));

      final end = dt.endOfDay;
      expect(end.hour, equals(23));
      expect(end.minute, equals(59));
      expect(end.second, equals(59));
    });

    test(
        'startOfMonth, endOfMonth, startOfYear, endOfYear, nextMonth, previousMonth',
        () {
      final dt = NepaliDateTime(2081, 6, 13, 10, 0);
      expect(dt.startOfMonth.day, equals(1));
      expect(dt.endOfMonth.day, equals(30));
      expect(dt.startOfYear.month, equals(1));
      expect(dt.startOfYear.day, equals(1));
      expect(dt.endOfYear.month, equals(12));
      expect(dt.endOfYear.day, equals(30));
      expect(dt.nextMonth, equals(NepaliDateTime(2081, 7, 1)));
      expect(dt.previousMonth, equals(NepaliDateTime(2081, 5, 1)));

      // Comparison operators on NepaliDateTime
      final dt2 = NepaliDateTime(2081, 6, 14, 10, 0);
      expect(dt < dt2, isTrue);
      expect(dt <= dt2, isTrue);
      expect(dt2 > dt, isTrue);
      expect(dt2 >= dt, isTrue);
      expect(dt.isAtOrBefore(dt2), isTrue);
      expect(dt2.isAtOrAfter(dt), isTrue);

      expect(dt.daysInMonth, equals(30));
      expect(dt.daysInYear, isPositive);
    });

    test('toNepaliDate conversion', () {
      final dt = NepaliDateTime(2081, 6, 13, 10, 30);
      final d = dt.toNepaliDate();
      expect(d, equals(NepaliDate(2081, 6, 13)));
    });

    test('Devanagari parsing in NepaliDateTime.parse', () {
      final parsed = NepaliDateTime.parse('२०८१-०६-१३');
      expect(parsed.year, equals(2081));
      expect(parsed.month, equals(6));
      expect(parsed.day, equals(13));
    });
  });

  group('NepaliMonth & NepaliWeekday cycling', () {
    test('NepaliMonth next and previous wrap correctly', () {
      expect(NepaliMonth.baisakh.previous, equals(NepaliMonth.chaitra));
      expect(NepaliMonth.chaitra.next, equals(NepaliMonth.baisakh));
      expect(NepaliMonth.ashwin.next, equals(NepaliMonth.kartik));
      expect(NepaliMonth.ashwin.previous, equals(NepaliMonth.bhadra));
    });

    test('NepaliWeekday next and previous wrap correctly', () {
      expect(NepaliWeekday.sunday.previous, equals(NepaliWeekday.saturday));
      expect(NepaliWeekday.saturday.next, equals(NepaliWeekday.sunday));
      expect(NepaliWeekday.wednesday.next, equals(NepaliWeekday.thursday));
    });
  });

  group('NepaliDateRange days iterator', () {
    test('yields all consecutive NepaliDate items in range', () {
      final range = NepaliDateRange(
        start: NepaliDate(2081, 6, 28),
        end: NepaliDate(2081, 7, 2),
      );
      final daysList = range.days.toList();
      expect(daysList.length, equals(range.inDays));
      expect(daysList.first, equals(NepaliDate(2081, 6, 28)));
      expect(daysList.last, equals(NepaliDate(2081, 7, 2)));
    });
  });
}
