import 'package:nepali_kit/nepali_kit_core.dart';
import 'package:test/test.dart';

void main() {
  group('NepaliMonth and NepaliWeekday', () {
    test('month index and names', () {
      expect(NepaliMonth.baisakh.number, equals(1));
      expect(NepaliMonth.baisakh.nameNepali, equals('बैशाख'));
      expect(NepaliMonth.baisakh.nameEnglish, equals('Baisakh'));
      expect(NepaliMonth.fromIndex(12), equals(NepaliMonth.chaitra));
      expect(() => NepaliMonth.fromIndex(0), throwsRangeError);
      expect(() => NepaliMonth.fromIndex(13), throwsRangeError);
    });

    test('weekday index and weekend check', () {
      expect(NepaliWeekday.sunday.number, equals(1));
      expect(NepaliWeekday.saturday.number, equals(7));
      expect(NepaliWeekday.saturday.isWeekend, isTrue);
      expect(NepaliWeekday.sunday.isWeekend, isFalse);
    });

    test('Language enum', () {
      expect(Language.nepali.code, equals('ne'));
      expect(Language.english.code, equals('en'));
      expect(Language.nepali.isNepali, isTrue);
      expect(Language.english.isEnglish, isTrue);
    });
  });
}
