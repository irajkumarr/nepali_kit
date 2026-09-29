import 'package:nepali_kit/nepali_kit_core.dart';
import 'package:test/test.dart';

void main() {
  group('NepaliDateFormat formatting tokens & locales', () {
    final date = NepaliDateTime(2081, 6, 13, 14, 30, 45);

    test('Devanagari vs English script month names', () {
      const neFormat = NepaliDateFormat('MMMM', Language.nepali);
      const enFormat = NepaliDateFormat('MMMM', Language.english);
      expect(neFormat.format(date), equals('आश्विन'));
      expect(enFormat.format(date), equals('Ashwin'));

      const neShort = NepaliDateFormat('MMM', Language.nepali);
      const enShort = NepaliDateFormat('MMM', Language.english);
      expect(neShort.format(date), equals('आ'));
      expect(enShort.format(date), equals('Ashw'));
    });

    test('Devanagari vs English script weekday names', () {
      const neFull = NepaliDateFormat('EEEE', Language.nepali);
      const enFull = NepaliDateFormat('EEEE', Language.english);
      expect(neFull.format(date), equals('आइतबार'));
      expect(enFull.format(date), equals('Sunday'));

      const neShort = NepaliDateFormat('EEE', Language.nepali);
      const enShort = NepaliDateFormat('EEE', Language.english);
      expect(neShort.format(date), equals('आइत'));
      expect(enShort.format(date), equals('Sun'));
    });

    test('Numeric tokens padding and year formats', () {
      const padFormat = NepaliDateFormat('yyyy/MM/dd', Language.english);
      expect(padFormat.format(date), equals('2081/06/13'));

      const nePadFormat = NepaliDateFormat('yyyy/MM/dd', Language.nepali);
      expect(nePadFormat.format(date), equals('२०८१/०६/१३'));

      const yyFormat = NepaliDateFormat('yy-M-d', Language.english);
      expect(yyFormat.format(date), equals('81-6-13'));
    });

    test('12-hour and 24-hour time tokens', () {
      const time24 = NepaliDateFormat('HH:mm:ss', Language.english);
      expect(time24.format(date), equals('14:30:45'));

      const time12En = NepaliDateFormat('hh:mm:ss a', Language.english);
      expect(time12En.format(date), equals('02:30:45 PM'));

      const time12Ne = NepaliDateFormat('hh:mm a', Language.nepali);
      expect(time12Ne.format(date), equals('०२:३० अपराह्न'));

      final morningDate = NepaliDateTime(2081, 6, 13, 8, 15);
      expect(const NepaliDateFormat('a', Language.nepali).format(morningDate),
          equals('पूर्वाह्न'));
      expect(const NepaliDateFormat('a', Language.english).format(morningDate),
          equals('AM'));
    });

    test('Formatting NepaliDate instance', () {
      final nepaliDate = NepaliDate(2081, 6, 13);
      final format = NepaliDateFormat.yMMMMd(Language.nepali);
      expect(format.format(nepaliDate), equals('१३ आश्विन २०८१'));
    });

    test('Escaped string literals in pattern', () {
      const format = NepaliDateFormat("'मिति:' yyyy-MM-dd", Language.nepali);
      expect(format.format(date), equals('मिति: २०८१-०६-१३'));
    });

    test('Dual BS/AD formatting', () {
      final dual = NepaliDateFormat.formatDual(date);
      expect(dual.contains('२०८१-०६-१३'), isTrue);
      expect(dual.contains('2024-09-29'), isTrue);
    });
  });

  group('NepaliMoment relative time / moments', () {
    final ref = NepaliDateTime(2081, 6, 13, 12, 0, 0);

    test('just now / भर्खरै (boundaries & zero)', () {
      expect(
          NepaliMoment.fromDate(ref,
              referenceDate: ref, language: Language.nepali),
          equals('भर्खरै'));
      expect(
          NepaliMoment.fromDate(ref,
              referenceDate: ref, language: Language.english),
          equals('just now'));

      final tenSecsAgo = ref.subtract(const Duration(seconds: 10));
      expect(
          NepaliMoment.fromDate(tenSecsAgo,
              referenceDate: ref, language: Language.nepali),
          equals('भर्खरै'));
      expect(
          NepaliMoment.fromDate(tenSecsAgo,
              referenceDate: ref, language: Language.english),
          equals('just now'));
    });

    test('minutes singular/plural, past and future', () {
      final oneMinAgo = ref.subtract(const Duration(minutes: 1));
      expect(
          NepaliMoment.fromDate(oneMinAgo,
              referenceDate: ref, language: Language.english),
          equals('1 minute ago'));
      expect(
          NepaliMoment.fromDate(oneMinAgo,
              referenceDate: ref, language: Language.nepali),
          equals('१ मिनेट अगाडि'));

      final fiveMinsAgo = ref.subtract(const Duration(minutes: 5));
      expect(
          NepaliMoment.fromDate(fiveMinsAgo,
              referenceDate: ref, language: Language.english),
          equals('5 minutes ago'));
      expect(
          NepaliMoment.fromDate(fiveMinsAgo,
              referenceDate: ref, language: Language.nepali),
          equals('५ मिनेट अगाडि'));

      final fiveMinsFuture = ref.add(const Duration(minutes: 5));
      expect(
          NepaliMoment.fromDate(fiveMinsFuture,
              referenceDate: ref, language: Language.english),
          equals('in 5 minutes'));
      expect(
          NepaliMoment.fromDate(fiveMinsFuture,
              referenceDate: ref, language: Language.nepali),
          equals('५ मिनेट पछि'));
    });

    test('hours singular/plural, past and future', () {
      final oneHourAgo = ref.subtract(const Duration(hours: 1));
      expect(
          NepaliMoment.fromDate(oneHourAgo,
              referenceDate: ref, language: Language.english),
          equals('1 hour ago'));
      expect(
          NepaliMoment.fromDate(oneHourAgo,
              referenceDate: ref, language: Language.nepali),
          equals('१ घण्टा अगाडि'));

      final threeHoursAgo = ref.subtract(const Duration(hours: 3));
      expect(
          NepaliMoment.fromDate(threeHoursAgo,
              referenceDate: ref, language: Language.english),
          equals('3 hours ago'));
      expect(
          NepaliMoment.fromDate(threeHoursAgo,
              referenceDate: ref, language: Language.nepali),
          equals('३ घण्टा अगाडि'));

      final threeHoursFuture = ref.add(const Duration(hours: 3));
      expect(
          NepaliMoment.fromDate(threeHoursFuture,
              referenceDate: ref, language: Language.english),
          equals('in 3 hours'));
      expect(
          NepaliMoment.fromDate(threeHoursFuture,
              referenceDate: ref, language: Language.nepali),
          equals('३ घण्टा पछि'));
    });

    test('calendar days: yesterday, today, tomorrow, asti, parsi', () {
      final yesterday = ref.subtract(const Duration(days: 1));
      expect(
          NepaliMoment.fromDate(yesterday,
              referenceDate: ref, language: Language.english),
          equals('yesterday'));
      expect(
          NepaliMoment.fromDate(yesterday,
              referenceDate: ref, language: Language.nepali),
          equals('हिजो'));

      final tomorrow = ref.add(const Duration(days: 1));
      expect(
          NepaliMoment.fromDate(tomorrow,
              referenceDate: ref, language: Language.english),
          equals('tomorrow'));
      expect(
          NepaliMoment.fromDate(tomorrow,
              referenceDate: ref, language: Language.nepali),
          equals('भोलि'));

      final asti = ref.subtract(const Duration(days: 2));
      expect(
          NepaliMoment.fromDate(asti,
              referenceDate: ref, language: Language.nepali),
          equals('अस्ति'));
      expect(
          NepaliMoment.fromDate(asti,
              referenceDate: ref, language: Language.english),
          equals('2 days ago'));

      final parsi = ref.add(const Duration(days: 2));
      expect(
          NepaliMoment.fromDate(parsi,
              referenceDate: ref, language: Language.nepali),
          equals('पर्सि'));
      expect(
          NepaliMoment.fromDate(parsi,
              referenceDate: ref, language: Language.english),
          equals('in 2 days'));
    });

    test('weeks singular/plural, past and future', () {
      final oneWeekAgo = ref.subtract(const Duration(days: 8));
      expect(
          NepaliMoment.fromDate(oneWeekAgo,
              referenceDate: ref, language: Language.english),
          equals('1 week ago'));
      expect(
          NepaliMoment.fromDate(oneWeekAgo,
              referenceDate: ref, language: Language.nepali),
          equals('१ हप्ता अगाडि'));

      final twoWeeksAgo = ref.subtract(const Duration(days: 16));
      expect(
          NepaliMoment.fromDate(twoWeeksAgo,
              referenceDate: ref, language: Language.english),
          equals('2 weeks ago'));
      expect(
          NepaliMoment.fromDate(twoWeeksAgo,
              referenceDate: ref, language: Language.nepali),
          equals('२ हप्ता अगाडि'));

      final twoWeeksFuture = ref.add(const Duration(days: 16));
      expect(
          NepaliMoment.fromDate(twoWeeksFuture,
              referenceDate: ref, language: Language.english),
          equals('in 2 weeks'));
      expect(
          NepaliMoment.fromDate(twoWeeksFuture,
              referenceDate: ref, language: Language.nepali),
          equals('२ हप्ता पछि'));
    });

    test('months and years', () {
      final threeMonthsAgo = ref.subtract(const Duration(days: 95));
      expect(
          NepaliMoment.fromDate(threeMonthsAgo,
              referenceDate: ref, language: Language.english),
          equals('3 months ago'));
      expect(
          NepaliMoment.fromDate(threeMonthsAgo,
              referenceDate: ref, language: Language.nepali),
          equals('३ महिना अगाडि'));

      final twoYearsAgo = ref.subtract(const Duration(days: 740));
      expect(
          NepaliMoment.fromDate(twoYearsAgo,
              referenceDate: ref, language: Language.english),
          equals('2 years ago'));
      expect(
          NepaliMoment.fromDate(twoYearsAgo,
              referenceDate: ref, language: Language.nepali),
          equals('२ वर्ष अगाडि'));

      final twoYearsFuture = ref.add(const Duration(days: 740));
      expect(
          NepaliMoment.fromDate(twoYearsFuture,
              referenceDate: ref, language: Language.english),
          equals('in 2 years'));
      expect(
          NepaliMoment.fromDate(twoYearsFuture,
              referenceDate: ref, language: Language.nepali),
          equals('२ वर्ष पछि'));
    });

    test('Works with NepaliDate instances directly', () {
      final d = NepaliDate(2081, 6, 12); // Yesterday relative to 2081-06-13
      final refDate = NepaliDate(2081, 6, 13);
      expect(
          NepaliMoment.fromDate(d,
              referenceDate: refDate, language: Language.nepali),
          equals('हिजो'));
      expect(
          NepaliMoment.fromDate(d,
              referenceDate: refDate, language: Language.english),
          equals('yesterday'));
    });
  });
}
