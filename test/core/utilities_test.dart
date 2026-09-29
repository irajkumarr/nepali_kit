import 'package:nepali_kit/nepali_kit_core.dart';
import 'package:test/test.dart';

void main() {
  group('NepaliDigits', () {
    test('toNepali conversion', () {
      expect(NepaliDigits.toNepali(2081), equals('२०८१'));
      expect(NepaliDigits.toNepali('Date: 12345'), equals('Date: १२३४५'));
    });

    test('toEnglish conversion', () {
      expect(NepaliDigits.toEnglish('२०८१'), equals('2081'));
    });

    test('containsNepaliDigits check', () {
      expect(NepaliDigits.containsNepaliDigits('२०८१'), isTrue);
      expect(NepaliDigits.containsNepaliDigits('2081'), isFalse);
    });
  });

  group('NepaliDateFormat', () {
    test('standard formatting in Nepali', () {
      final date = NepaliDateTime(2081, 6, 13);
      const format = NepaliDateFormat('yyyy-MM-dd', Language.nepali);
      expect(format.format(date), equals('२०८१-०६-१३'));
    });

    test('standard formatting in English', () {
      final date = NepaliDateTime(2081, 6, 13);
      const format = NepaliDateFormat('yyyy-MM-dd', Language.english);
      expect(format.format(date), equals('2081-06-13'));
    });
  });

  group('NepaliFiscalYear and Quarters', () {
    test('fiscal year resolution', () {
      // Month 6 (Ashwin) belongs to fiscal year started in Baisakh/Shrawan
      final date1 = NepaliDateTime(2081, 6, 13);
      final fy1 = NepaliFiscalYear.fromDate(date1);
      expect(fy1.startYear, equals(2081));
      expect(fy1.endYear, equals(2082));
      expect(fy1.format(Language.english), equals('2081/82'));

      // Month 2 (Jestha) belongs to fiscal year that started previous year
      final date2 = NepaliDateTime(2081, 2, 10);
      final fy2 = NepaliFiscalYear.fromDate(date2);
      expect(fy2.startYear, equals(2080));
      expect(fy2.endYear, equals(2081));
    });

    test('fiscal quarters', () {
      final date = NepaliDateTime(2081, 6, 13);
      final quarter = NepaliFiscalQuarter.fromDate(date);
      expect(quarter.quarter, equals(FiscalQuarterIndex.q1));
      expect(quarter.contains(date), isTrue);
    });
  });

  group('NepaliHolidayService', () {
    test('fixed holidays', () {
      final newYear = NepaliDateTime(2081, 1, 1);
      expect(NepaliHolidayService.isHoliday(newYear), isTrue);

      final normalDay = NepaliDateTime(2081, 1, 2);
      expect(NepaliHolidayService.isHoliday(normalDay), isFalse);
    });
  });

  group('NepaliMoment', () {
    test('relative moments', () {
      final now = NepaliDateTime(2081, 6, 13, 12, 0);
      final fiveMinsAgo = now.subtract(const Duration(minutes: 5));
      expect(
        NepaliMoment.fromDate(fiveMinsAgo,
            referenceDate: now, language: Language.nepali),
        equals('५ मिनेट अगाडि'),
      );
    });
  });
}
