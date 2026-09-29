import 'package:nepali_kit/nepali_kit_core.dart';
import 'package:test/test.dart';

void main() {
  group('Audit: BS Calendar Engine & Month Boundaries', () {
    test('Every supported year and month has valid first and last day', () {
      for (int year = NepaliCalendarConstants.minBsYear;
          year <= NepaliCalendarConstants.maxBsYear;
          year++) {
        for (int month = 1; month <= 12; month++) {
          final daysInMonth = BsCalendarData.getDaysInMonth(year, month);
          expect(daysInMonth, inInclusiveRange(29, 32));

          // First day
          final firstDay = NepaliDate(year, month, 1);
          expect(firstDay.year, equals(year));
          expect(firstDay.month, equals(month));
          expect(firstDay.day, equals(1));
          expect(firstDay.startOfMonth, equals(firstDay));

          // Last day
          final lastDay = NepaliDate(year, month, daysInMonth);
          expect(lastDay.day, equals(daysInMonth));
          expect(lastDay.endOfMonth, equals(lastDay));
        }
      }
    });

    test('Year boundaries: Min BS year and Max BS year', () {
      final minDate = NepaliDate(NepaliCalendarConstants.minBsYear, 1, 1);
      final maxDays =
          BsCalendarData.getDaysInMonth(NepaliCalendarConstants.maxBsYear, 12);
      final maxDate =
          NepaliDate(NepaliCalendarConstants.maxBsYear, 12, maxDays);

      expect(minDate.isBefore(maxDate), isTrue);
      expect(maxDate.isAfter(minDate), isTrue);

      // Conversions
      final minAd = minDate.toDateTime();
      final maxAd = maxDate.toDateTime();
      expect(NepaliDate.fromDateTime(minAd), equals(minDate));
      expect(NepaliDate.fromDateTime(maxAd), equals(maxDate));

      // Out of bounds throws
      expect(
        () => NepaliDate(NepaliCalendarConstants.minBsYear - 1, 1, 1),
        throwsA(isA<NepaliDateException>()),
      );
      expect(
        () => NepaliDate(NepaliCalendarConstants.maxBsYear + 1, 1, 1),
        throwsA(isA<NepaliDateException>()),
      );
    });

    test('Invalid dates throw NepaliDateException', () {
      // Month 0 or 13
      expect(() => NepaliDate(2081, 0, 1), throwsA(isA<NepaliDateException>()));
      expect(
          () => NepaliDate(2081, 13, 1), throwsA(isA<NepaliDateException>()));

      // Day 0 or 33
      expect(() => NepaliDate(2081, 1, 0), throwsA(isA<NepaliDateException>()));
      expect(
          () => NepaliDate(2081, 1, 33), throwsA(isA<NepaliDateException>()));

      // Exceeding actual days in month
      final maxDay = BsCalendarData.getDaysInMonth(2081, 1);
      expect(() => NepaliDate(2081, 1, maxDay + 1),
          throwsA(isA<NepaliDateException>()));
    });

    test('Leap year detection across multiple years', () {
      // 2076 BS has 365 days; 2077 BS has 366 days
      final d2076 = NepaliDate(2076, 1, 1);
      final d2077 = NepaliDate(2077, 1, 1);
      expect(d2076.isLeapYear, isFalse);
      expect(d2077.isLeapYear, isTrue);
      expect(d2076.totalDaysInYear, equals(365));
      expect(d2077.totalDaysInYear, equals(366));
    });
  });

  group('Audit: Invariant BS ↔ AD ↔ BS Conversions', () {
    test('Comprehensive BS → AD → BS round trip for every month', () {
      for (int y = 2000; y <= 2090; y += 5) {
        for (int m = 1; m <= 12; m++) {
          final maxDay = BsCalendarData.getDaysInMonth(y, m);
          for (final d in [1, 15, maxDay]) {
            final bsDate = NepaliDate(y, m, d);
            final adDate = bsDate.toDateTime();
            final reconverted = NepaliDate.fromDateTime(adDate);
            expect(reconverted, equals(bsDate),
                reason: 'Failed roundtrip for BS $y-$m-$d');
          }
        }
      }
    });

    test('Timezone safety: UTC vs Local conversion invariance', () {
      final utcAd = DateTime.utc(2024, 9, 29, 0, 0, 0);
      final bs1 = NepaliDate.fromDateTime(utcAd);
      expect(bs1, equals(NepaliDate(2081, 6, 13)));

      final bsDt = NepaliDateTime(2081, 6, 13, 15, 30);
      expect(bsDt.toNepaliDate(), equals(NepaliDate(2081, 6, 13)));
    });
  });

  group('Audit: Date Arithmetic Invariants', () {
    test('date.addDays(n).subtractDays(n) == date invariant', () {
      final testDates = [
        NepaliDate(2081, 1, 1),
        NepaliDate(2081, 6, 13),
        NepaliDate(2081, 12, 30),
      ];
      final offsets = [1, 5, 29, 365, 1000];

      for (final date in testDates) {
        for (final offset in offsets) {
          expect(date.addDays(offset).subtractDays(offset), equals(date));
        }
      }
    });

    test('addMonths and subtractMonths with year rollover and day clamping',
        () {
      final date = NepaliDate(2081, 6, 15);
      expect(date.addMonths(1), equals(NepaliDate(2081, 7, 15)));
      expect(date.addMonths(7), equals(NepaliDate(2082, 1, 15)));
      expect(date.subtractMonths(6),
          equals(NepaliDate(2080, 12, 15))); // Chaitra 2080

      // Day clamping: month with 32 days added to month with 29 days
      final endDay = NepaliDate(2081, 3, 32); // Ashadh 32
      final addedMonth = endDay.addMonths(6); // Poush (29 days)
      expect(addedMonth.month, equals(9));
      expect(addedMonth.day,
          lessThanOrEqualTo(BsCalendarData.getDaysInMonth(2081, 9)));
    });

    test('addYears and subtractYears', () {
      final date = NepaliDate(2080, 6, 13);
      expect(date.addYears(1), equals(NepaliDate(2081, 6, 13)));
      expect(date.subtractYears(5), equals(NepaliDate(2075, 6, 13)));
    });

    test('difference and differenceInDays', () {
      final d1 = NepaliDate(2081, 6, 1);
      final d2 = NepaliDate(2081, 6, 15);
      expect(d2.differenceInDays(d1), equals(14));
      expect(d1.differenceInDays(d2), equals(-14));
      expect(d2.difference(d1), equals(const Duration(days: 14)));
    });
  });

  group('Audit: Serialization & Parsing Invariance', () {
    test('date == NepaliDate.parse(date.toIso8601String())', () {
      final dates = [
        NepaliDate(1975, 1, 1),
        NepaliDate(2081, 6, 13),
        NepaliDate(2099, 12, 30),
      ];

      for (final d in dates) {
        final iso = d.toIso8601String();
        final parsed = NepaliDate.parse(iso);
        expect(parsed, equals(d));
      }
    });

    test('Devanagari string parsing invariance', () {
      final d = NepaliDate(2081, 6, 13);
      const nepaliStr = '२०८१-०६-१३';
      final parsed = NepaliDate.parse(nepaliStr);
      expect(parsed, equals(d));
    });
  });

  group('Audit: Formatting Tokens & Locales', () {
    final testDt = NepaliDateTime(2081, 6, 13, 14, 5, 9);

    test('Every supported pattern token in Nepali and English', () {
      // Year tokens
      expect(const NepaliDateFormat('yyyy', Language.english).format(testDt),
          equals('2081'));
      expect(const NepaliDateFormat('yy', Language.english).format(testDt),
          equals('81'));
      expect(const NepaliDateFormat('yyyy', Language.nepali).format(testDt),
          equals('२०८१'));
      expect(const NepaliDateFormat('yy', Language.nepali).format(testDt),
          equals('८१'));

      // Month tokens
      expect(const NepaliDateFormat('MMMM', Language.english).format(testDt),
          equals('Ashwin'));
      expect(const NepaliDateFormat('MMM', Language.english).format(testDt),
          equals('Ashw'));
      expect(const NepaliDateFormat('MM', Language.english).format(testDt),
          equals('06'));
      expect(const NepaliDateFormat('M', Language.english).format(testDt),
          equals('6'));
      expect(const NepaliDateFormat('MMMM', Language.nepali).format(testDt),
          equals('आश्विन'));
      expect(const NepaliDateFormat('MMM', Language.nepali).format(testDt),
          equals('आ'));
      expect(const NepaliDateFormat('MM', Language.nepali).format(testDt),
          equals('०६'));

      // Day tokens
      expect(const NepaliDateFormat('dd', Language.english).format(testDt),
          equals('13'));
      expect(const NepaliDateFormat('d', Language.english).format(testDt),
          equals('13'));
      expect(const NepaliDateFormat('dd', Language.nepali).format(testDt),
          equals('१३'));

      // Weekday tokens (2081-06-13 is Sunday)
      expect(const NepaliDateFormat('EEEE', Language.english).format(testDt),
          equals('Sunday'));
      expect(const NepaliDateFormat('EEE', Language.english).format(testDt),
          equals('Sun'));
      expect(const NepaliDateFormat('EEEE', Language.nepali).format(testDt),
          equals('आइतबार'));
      expect(const NepaliDateFormat('EEE', Language.nepali).format(testDt),
          equals('आइत'));

      // Time tokens (14:05:09)
      expect(
          const NepaliDateFormat('HH:mm:ss', Language.english).format(testDt),
          equals('14:05:09'));
      expect(
          const NepaliDateFormat('hh:mm:ss a', Language.english).format(testDt),
          equals('02:05:09 PM'));
      expect(const NepaliDateFormat('h:m:s a', Language.english).format(testDt),
          equals('2:5:9 PM'));
      expect(
          const NepaliDateFormat('hh:mm:ss a', Language.nepali).format(testDt),
          equals('०२:०५:०९ अपराह्न'));
    });

    test('formatDual generates valid dual BS and AD representations', () {
      final dualStr = NepaliDateFormat.formatDual(
        testDt,
        language: Language.english,
      );
      expect(dualStr.contains('2081-06-13'), isTrue);
      expect(dualStr.contains('2024-09-29'), isTrue);
    });
  });

  group('Audit: Numbers, Grouping, & Number-To-Words', () {
    test('Zero, negative, decimal, and large numbers formatting', () {
      expect(NepaliNumberFormat.format(0), equals('0'));
      expect(
          NepaliNumberFormat.format(0, language: Language.nepali), equals('०'));

      expect(NepaliNumberFormat.format(-12345.67), equals('-12,345.67'));
      expect(NepaliNumberFormat.format(-12345.67, language: Language.nepali),
          equals('-१२,३४५.६७'));

      // South Asian grouping: 12,34,56,789
      expect(NepaliNumberFormat.format(123456789), equals('12,34,56,789'));
      expect(NepaliNumberFormat.format(123456789, language: Language.nepali),
          equals('१२,३४,५६,७८९'));
    });

    test('Currency formatting', () {
      expect(NepaliNumberFormat.currency(50000), equals('रु ५०,०००.००'));
      expect(NepaliNumberFormat.currency(50000, language: Language.english),
          equals('Rs. 50,000.00'));
    });

    test('Number to words: zero, units, thousands, lakhs, crores, decimals',
        () {
      expect(NepaliNumberToWords.convert(0), equals('शून्य'));
      expect(NepaliNumberToWords.convert(0, language: Language.english),
          equals('Zero'));

      expect(NepaliNumberToWords.convert(5), equals('पाँच'));
      expect(NepaliNumberToWords.convert(5, language: Language.english),
          equals('Five'));

      expect(
          NepaliNumberToWords.convert(1234), equals('एक हजार दुई सय चौंतीस'));
      expect(NepaliNumberToWords.convert(1234, language: Language.english),
          equals('One Thousand Two Hundred Thirty Four'));

      expect(NepaliNumberToWords.convert(100000), equals('एक लाख'));
      expect(NepaliNumberToWords.convert(10000000), equals('एक करोड'));

      // Decimals and negatives
      expect(
          NepaliNumberToWords.convert(-25.5), equals('ऋण पच्चीस दशमलव पाँच'));
    });
  });

  group('Audit: Fiscal Year & Quarters', () {
    test('Fiscal year boundaries and transitions', () {
      // 2081-04-01 (Shrawan 1) is start of 2081/82
      final d1 = NepaliDate(2081, 4, 1);
      final fy1 = d1.fiscalYear;
      expect(fy1.startYear, equals(2081));
      expect(fy1.endYear, equals(2082));
      expect(fy1.startDate, equals(NepaliDate(2081, 4, 1)));

      // 2081-03-31 (Ashadh last day) belongs to 2080/81
      final d2 = NepaliDate(2081, 3, 31);
      final fy2 = d2.fiscalYear;
      expect(fy2.startYear, equals(2080));
      expect(fy2.endYear, equals(2081));

      // Quarters Q1 - Q4
      expect(NepaliFiscalQuarter.fromDate(NepaliDate(2081, 4, 1)).quarter,
          equals(FiscalQuarterIndex.q1));
      expect(NepaliFiscalQuarter.fromDate(NepaliDate(2081, 7, 1)).quarter,
          equals(FiscalQuarterIndex.q2));
      expect(NepaliFiscalQuarter.fromDate(NepaliDate(2081, 10, 1)).quarter,
          equals(FiscalQuarterIndex.q3));
      expect(NepaliFiscalQuarter.fromDate(NepaliDate(2082, 1, 1)).quarter,
          equals(FiscalQuarterIndex.q4));
    });
  });

  group('Audit: Holidays & Custom Providers', () {
    setUp(() => NepaliHolidayService.reset());
    tearDown(() => NepaliHolidayService.reset());

    test('Known gazetted holidays check', () {
      // Constitution Day is Ashwin 3
      final constDay = NepaliDate(2081, 6, 3);
      expect(NepaliHolidayService.isHoliday(constDay), isTrue);

      final holiday = NepaliHolidayService.holidayOn(constDay);
      expect(holiday, isNotNull);
      expect(holiday!.nameEnglish, equals('Constitution Day'));
    });

    test('Custom holiday registration and reset', () {
      final customDate = NepaliDate(2081, 2, 20);
      expect(NepaliHolidayService.isHoliday(customDate), isFalse);

      NepaliHolidayService.registerCustomHolidays([
        NepaliHoliday(
          id: 'org_anniversary',
          nameNepali: 'संस्था वार्षिकोत्सव',
          nameEnglish: 'Company Anniversary',
          date: customDate,
          category: HolidayCategory.custom,
        ),
      ]);

      expect(NepaliHolidayService.isHoliday(customDate), isTrue);
      final customH = NepaliHolidayService.holidayOn(customDate);
      expect(customH?.nameEnglish, equals('Company Anniversary'));

      // Service reset clears custom holidays
      NepaliHolidayService.reset();
      expect(NepaliHolidayService.isHoliday(customDate), isFalse);
    });
  });
}
