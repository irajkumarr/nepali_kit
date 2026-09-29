import 'package:nepali_kit/nepali_kit_core.dart';
import 'package:test/test.dart';

void main() {
  group('NepaliFiscalYear boundaries & calculations', () {
    test('Shrawan 1 boundary (first day of fiscal year)', () {
      final shrawan1 = NepaliDate(2081, 4, 1);
      final fy = NepaliFiscalYear.fromDate(shrawan1);
      expect(fy.startYear, equals(2081));
      expect(fy.endYear, equals(2082));
      expect(fy.format(Language.english), equals('2081/82'));
      expect(fy.contains(shrawan1), isTrue);
    });

    test('Ashadh last day boundary (final day of fiscal year)', () {
      final ashadhEnd2081 = NepaliDate(2081, 3, 31);
      final fy = NepaliFiscalYear.fromDate(ashadhEnd2081);
      expect(fy.startYear, equals(2080));
      expect(fy.endYear, equals(2081));
      expect(fy.format(Language.english), equals('2080/81'));
      expect(fy.contains(ashadhEnd2081), isTrue);
    });

    test('Fiscal year from standard Gregorian DateTime', () {
      // 2024-07-16 AD corresponds to Shrawan 1, 2081 BS
      final adDate = DateTime.utc(2024, 7, 16);
      final fy = NepaliFiscalYear.fromDate(adDate);
      expect(fy.startYear, equals(2081));
      expect(fy.endYear, equals(2082));

      // 2024-07-15 AD corresponds to Ashadh 31, 2081 BS
      final adPrev = DateTime.utc(2024, 7, 15);
      final fyPrev = NepaliFiscalYear.fromDate(adPrev);
      expect(fyPrev.startYear, equals(2080));
      expect(fyPrev.endYear, equals(2081));
    });

    test('Fiscal year start and end dates', () {
      final fy = NepaliFiscalYear(2081);
      expect(fy.startDate, equals(NepaliDate(2081, 4, 1)));
      expect(fy.endDate.year, equals(2082));
      expect(fy.endDate.month, equals(3));
      expect(fy.endDate.day, equals(NepaliDate(2082, 3, 1).totalDaysInMonth));

      expect(fy.contains(NepaliDate(2081, 4, 1)), isTrue);
      expect(fy.contains(NepaliDate(2082, 3, 31)), isTrue);
      expect(fy.contains(NepaliDate(2081, 3, 31)), isFalse);
      expect(fy.contains(NepaliDate(2082, 4, 1)), isFalse);
    });

    test('Parsing fiscal year strings', () {
      expect(NepaliFiscalYear.parse('2081/82').startYear, equals(2081));
      expect(NepaliFiscalYear.parse('2081/2082').startYear, equals(2081));
      expect(NepaliFiscalYear.parse('२०८१/८२').startYear, equals(2081));
      expect(NepaliFiscalYear.tryParse('invalid'), isNull);
      expect(
          NepaliFiscalYear.tryParse('2081/83'), isNull); // must be consecutive
    });

    test('Comparison, equality, and progression', () {
      final fy80 = NepaliFiscalYear(2080);
      final fy81 = NepaliFiscalYear(2081);

      expect(fy80.isBefore(fy81), isTrue); // via compareTo
      expect(fy80.compareTo(fy81), isNegative);
      expect(fy81.previous, equals(fy80));
      expect(fy80.next, equals(fy81));
      expect(fy81.format(Language.nepali), equals('२०८१/८२'));
      expect(fy81.labelEnglish, equals('FY 2081/82'));
    });
  });

  group('NepaliFiscalQuarter boundaries & financial quarters', () {
    test('Q1: Shrawan 1 to Ashwin end', () {
      final q1Start = NepaliDate(2081, 4, 1);
      final q1End = NepaliDate(2081, 6, 30);
      final q = NepaliFiscalQuarter.fromDate(q1Start);

      expect(q.quarter, equals(FiscalQuarterIndex.q1));
      expect(q.startDate, equals(q1Start));
      expect(q.endDate, equals(q1End));
      expect(q.contains(q1Start), isTrue);
      expect(q.contains(q1End), isTrue);
      expect(q.contains(NepaliDate(2081, 7, 1)), isFalse);
      expect(q.format(Language.english), equals('2081/82 Q1'));
    });

    test('Q2: Kartik 1 to Poush end', () {
      final q2Date = NepaliDate(2081, 8, 15);
      final q = NepaliFiscalQuarter.fromDate(q2Date);
      expect(q.quarter, equals(FiscalQuarterIndex.q2));
      expect(q.startDate, equals(NepaliDate(2081, 7, 1)));
      expect(q.endDate, equals(NepaliDate(2081, 9, 29)));
      expect(q.contains(q2Date), isTrue);
    });

    test('Q3: Magh 1 to Chaitra end', () {
      final q3Date = NepaliDate(2081, 11, 20);
      final q = NepaliFiscalQuarter.fromDate(q3Date);
      expect(q.quarter, equals(FiscalQuarterIndex.q3));
      expect(q.startDate, equals(NepaliDate(2081, 10, 1)));
      expect(q.endDate, equals(NepaliDate(2081, 12, 30)));
    });

    test('Q4: Baisakh 1 to Ashadh end', () {
      final q4Date = NepaliDate(2081, 2, 10); // Jestha 2081
      final q = NepaliFiscalQuarter.fromDate(q4Date);
      // Jestha 2081 belongs to FY 2080/81 Q4!
      expect(q.fiscalYear.startYear, equals(2080));
      expect(q.fiscalYear.endYear, equals(2081));
      expect(q.quarter, equals(FiscalQuarterIndex.q4));
      expect(q.startDate, equals(NepaliDate(2081, 1, 1)));
      expect(q.endDate.month, equals(3));
      expect(q.endDate.year, equals(2081));
    });

    test('Quarter progression (previous / next)', () {
      final fy = NepaliFiscalYear(2081);
      final q1 = NepaliFiscalQuarter(fy, FiscalQuarterIndex.q1);
      final q2 = q1.next;
      final q3 = q2.next;
      final q4 = q3.next;
      final q1NextYear = q4.next;

      expect(q2.quarter, equals(FiscalQuarterIndex.q2));
      expect(q3.quarter, equals(FiscalQuarterIndex.q3));
      expect(q4.quarter, equals(FiscalQuarterIndex.q4));
      expect(q4.fiscalYear.startYear, equals(2081));

      expect(q1NextYear.fiscalYear.startYear, equals(2082));
      expect(q1NextYear.quarter, equals(FiscalQuarterIndex.q1));

      expect(q1.previous.fiscalYear.startYear, equals(2080));
      expect(q1.previous.quarter, equals(FiscalQuarterIndex.q4));
    });

    test('Fiscal quarter comparisons and operators', () {
      final fy = NepaliFiscalYear(2081);
      final q1 = NepaliFiscalQuarter(fy, FiscalQuarterIndex.q1);
      final q2 = NepaliFiscalQuarter(fy, FiscalQuarterIndex.q2);

      expect(q1 < q2, isTrue);
      expect(q1 <= q2, isTrue);
      expect(q2 > q1, isTrue);
      expect(q2 >= q1, isTrue);
      expect(q1.isBefore(q2), isTrue);
      expect(q2.isAfter(q1), isTrue);
    });

    test('NepaliFiscalYear quarters collection', () {
      final fy = NepaliFiscalYear(2081);
      final quarters = fy.quarters;
      expect(quarters.length, equals(4));
      expect(quarters[0].quarter, equals(FiscalQuarterIndex.q1));
      expect(quarters[1].quarter, equals(FiscalQuarterIndex.q2));
      expect(quarters[2].quarter, equals(FiscalQuarterIndex.q3));
      expect(quarters[3].quarter, equals(FiscalQuarterIndex.q4));
    });

    test('Date fiscal extensions on NepaliDate, NepaliDateTime, and DateTime',
        () {
      final bsDate = NepaliDate(2081, 4, 15);
      expect(bsDate.fiscalYear.startYear, equals(2081));
      expect(bsDate.fiscalQuarter.quarter, equals(FiscalQuarterIndex.q1));

      final bsDateTime = NepaliDateTime(2081, 2, 10, 14, 30);
      expect(bsDateTime.fiscalYear.startYear, equals(2080));
      expect(bsDateTime.fiscalQuarter.quarter, equals(FiscalQuarterIndex.q4));

      final adDateTime = DateTime.utc(2024, 7, 16); // Shrawan 1, 2081 BS
      expect(adDateTime.nepaliFiscalYear.startYear, equals(2081));
      expect(adDateTime.nepaliFiscalQuarter.quarter,
          equals(FiscalQuarterIndex.q1));
    });
  });
}
