import 'package:nepali_kit/nepali_kit_core.dart';
import 'package:test/test.dart';

void main() {
  group('NepaliDateTime', () {
    test('construction and basic properties', () {
      final date = NepaliDateTime(2081, 6, 13, 10, 30);
      expect(date.year, equals(2081));
      expect(date.month, equals(6));
      expect(date.day, equals(13));
      expect(date.hour, equals(10));
      expect(date.minute, equals(30));
      expect(date.nepaliMonth, equals(NepaliMonth.ashwin));
    });

    test('invalid date throws NepaliDateException', () {
      expect(
        () => NepaliDateTime(2081, 13, 1),
        throwsA(isA<NepaliDateException>()),
      );
      expect(
        () => NepaliDateTime(2081, 1, 35),
        throwsA(isA<NepaliDateException>()),
      );
    });

    test('AD ↔ BS round trip conversion', () {
      final testAd = DateTime.utc(2024, 9, 29);
      final bs = NepaliDateTime.fromDateTime(testAd);
      expect(bs.year, equals(2081));
      expect(bs.month, equals(6));
      expect(bs.day, equals(13));

      final convertedAd = bs.toDateTime();
      expect(convertedAd.year, equals(2024));
      expect(convertedAd.month, equals(9));
      expect(convertedAd.day, equals(29));
    });

    test('arithmetic operations', () {
      final date = NepaliDateTime(2081, 6, 13);
      final tomorrow = date.add(const Duration(days: 1));
      expect(tomorrow.day, equals(14));

      final diff = tomorrow.difference(date);
      expect(diff.inDays, equals(1));
      expect(date.isBefore(tomorrow), isTrue);
      expect(tomorrow.isAfter(date), isTrue);
    });

    test('parsing and ISO string', () {
      final date = NepaliDateTime.parse('2081-06-13');
      expect(date.year, equals(2081));
      expect(date.month, equals(6));
      expect(date.day, equals(13));

      final iso = date.toIso8601String();
      expect(iso.startsWith('2081-06-13'), isTrue);
    });
  });

  group('NepaliDateRange', () {
    test('contains and overlaps', () {
      final start = NepaliDateTime(2081, 1, 1);
      final end = NepaliDateTime(2081, 1, 15);
      final range = NepaliDateRange(start: start, end: end);

      expect(range.contains(NepaliDateTime(2081, 1, 5)), isTrue);
      expect(range.contains(NepaliDateTime(2081, 1, 20)), isFalse);

      final overlapping = NepaliDateRange(
        start: NepaliDateTime(2081, 1, 10),
        end: NepaliDateTime(2081, 1, 25),
      );
      expect(range.overlaps(overlapping), isTrue);

      final intersection = range.intersection(overlapping);
      expect(intersection, isNotNull);
      expect(intersection!.start, equals(NepaliDateTime(2081, 1, 10)));
      expect(intersection.end, equals(NepaliDateTime(2081, 1, 15)));
    });
  });
}
