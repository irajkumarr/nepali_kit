import 'package:nepali_kit/nepali_kit_core.dart';
import 'package:test/test.dart';

class MockCorporateHolidayProvider implements HolidayProvider {
  @override
  List<NepaliHoliday> getHolidaysForYear(int year) {
    return [
      NepaliHoliday(
        id: 'corp_anniversary_$year',
        nameNepali: 'कम्पनी स्थापना दिवस',
        nameEnglish: 'Company Foundation Day',
        date: NepaliDate(year, 3, 15),
        category: HolidayCategory.custom,
      ),
    ];
  }
}

void main() {
  setUp(() {
    NepaliHolidayService.clearCustomHolidays();
    NepaliHolidayService.setCustomProvider(null);
  });

  tearDown(() {
    NepaliHolidayService.clearCustomHolidays();
    NepaliHolidayService.setCustomProvider(null);
  });

  group('NepaliHoliday Model & Categories', () {
    test('NepaliHoliday creation and localized names', () {
      final holiday = NepaliHoliday(
        id: 'dashain_vijaya_dashami_2081',
        nameNepali: 'विजया दशमी',
        nameEnglish: 'Vijaya Dashami',
        date: NepaliDate(2081, 6, 27),
        category: HolidayCategory.national,
        description: 'Greatest festival of Nepal',
      );

      expect(holiday.getName(Language.nepali), equals('विजया दशमी'));
      expect(holiday.getName(Language.english), equals('Vijaya Dashami'));
      expect(
          holiday.category.getName(Language.nepali), equals('राष्ट्रिय पर्व'));
      expect(holiday.category.getName(Language.english),
          equals('National Holiday'));
      expect(holiday.dateTime.year, equals(2081));
      expect(holiday.dateTime.month, equals(6));
      expect(holiday.dateTime.day, equals(27));
    });

    test('NepaliHoliday.from factory with different date types', () {
      final fromBsDate = NepaliHoliday.from(
        id: 'h1',
        nameNepali: 'पर्व १',
        nameEnglish: 'Holiday 1',
        date: NepaliDate(2081, 1, 1),
      );
      expect(fromBsDate.date, equals(NepaliDate(2081, 1, 1)));

      final fromBsDateTime = NepaliHoliday.from(
        id: 'h2',
        nameNepali: 'पर्व २',
        nameEnglish: 'Holiday 2',
        date: NepaliDateTime(2081, 1, 1, 10, 0),
      );
      expect(fromBsDateTime.date, equals(NepaliDate(2081, 1, 1)));

      // 2024-04-13 AD is 2081-01-01 BS
      final fromAdDateTime = NepaliHoliday.from(
        id: 'h3',
        nameNepali: 'पर्व ३',
        nameEnglish: 'Holiday 3',
        date: DateTime.utc(2024, 4, 13),
      );
      expect(fromAdDateTime.date, equals(NepaliDate(2081, 1, 1)));
    });

    test('NepaliHoliday equality, comparison, and sorting', () {
      final h1 = NepaliHoliday(
        id: 'h1',
        nameNepali: 'पर्व १',
        nameEnglish: 'Holiday 1',
        date: NepaliDate(2081, 1, 1),
      );
      final h2 = NepaliHoliday(
        id: 'h2',
        nameNepali: 'पर्व २',
        nameEnglish: 'Holiday 2',
        date: NepaliDate(2081, 6, 3),
      );

      expect(h1.compareTo(h2), isNegative);
      expect(h1 == h2, isFalse);

      final list = [h2, h1]..sort();
      expect(list.first.id, equals('h1'));
    });
  });

  group('Year-Specific Official Gazetted Holidays', () {
    test('2080 BS verified gazetted holidays', () {
      final holidays2080 = NepaliHolidayService.holidaysForYear(2080);
      expect(holidays2080.isNotEmpty, isTrue);

      // Dashain Vijaya Dashami 2080 occurred on Kartik 7, 2080
      final dashami2080 =
          NepaliHolidayService.holidaysOn(NepaliDate(2080, 7, 7));
      expect(dashami2080.length, equals(1));
      expect(dashami2080.first.id, equals('dashain_vijaya_dashami_2080'));
      expect(dashami2080.first.nameEnglish, equals('Vijaya Dashami'));

      // New Year on Baisakh 1
      expect(NepaliHolidayService.isHoliday(NepaliDate(2080, 1, 1)), isTrue);
    });

    test('2081 BS verified gazetted holidays', () {
      final holidays2081 = NepaliHolidayService.holidaysForYear(2081);
      expect(holidays2081.isNotEmpty, isTrue);

      // Dashain Vijaya Dashami 2081 occurred on Ashwin 27, 2081 (different from 2080!)
      final dashami2081 =
          NepaliHolidayService.holidaysOn(NepaliDate(2081, 6, 27));
      expect(dashami2081.length, equals(1));
      expect(dashami2081.first.id, equals('dashain_vijaya_dashami_2081'));
      expect(dashami2081.first.nameNepali, equals('विजया दशमी'));

      // In 2081, Kartik 7 was NOT Dashami (proves year-specific shift)
      expect(NepaliHolidayService.isHoliday(NepaliDate(2081, 7, 7)), isFalse);

      // Tihar Bhai Tika in 2081 was Kartik 18
      final bhaiTika2081 =
          NepaliHolidayService.holidayOn(NepaliDate(2081, 7, 18));
      expect(bhaiTika2081, isNotNull);
      expect(bhaiTika2081!.nameNepali, equals('भाईटीका'));

      // Constitution Day: Ashwin 3
      expect(NepaliHolidayService.isHoliday(NepaliDate(2081, 6, 3)), isTrue);
    });

    test('Fixed national holidays fallback for unlisted years', () {
      // 2095 BS does not have a hardcoded lunar gazette in the package
      final holidays2095 = NepaliHolidayService.holidaysForYear(2095);
      expect(holidays2095.isNotEmpty, isTrue);

      // New Year (Baisakh 1) is always present
      expect(NepaliHolidayService.isHoliday(NepaliDate(2095, 1, 1)), isTrue);

      // Constitution Day (Ashwin 3) is always present
      expect(NepaliHolidayService.isHoliday(NepaliDate(2095, 6, 3)), isTrue);

      // Normal day (Ashwin 4) is false
      expect(NepaliHolidayService.isHoliday(NepaliDate(2095, 6, 4)), isFalse);
    });
  });

  group('Monthly Holiday Lookup & Filtering', () {
    test('holidaysForMonth returns holidays strictly within specified month',
        () {
      final kartikHolidays2081 =
          NepaliHolidayService.holidaysForMonth(2081, 7); // Kartik
      expect(kartikHolidays2081.isNotEmpty, isTrue);
      expect(kartikHolidays2081.every((h) => h.date.month == 7), isTrue);

      // Contains Laxmi Puja and Bhai Tika
      final ids = kartikHolidays2081.map((h) => h.id).toList();
      expect(ids.contains('tihar_laxmi_puja_2081'), isTrue);
      expect(ids.contains('tihar_bhai_tika_2081'), isTrue);
    });
  });

  group('Custom and Organization Holiday Support', () {
    test('registerCustomHolidays injects custom holidays into queries', () {
      final customHoliday = NepaliHoliday(
        id: 'bank_annual_closing',
        nameNepali: 'वार्षिक लेखापरीक्षण बिदा',
        nameEnglish: 'Annual Audit Bank Closing',
        date: NepaliDate(2081, 3, 31),
        category: HolidayCategory.custom,
        isPublicHoliday: false,
      );

      expect(NepaliHolidayService.isHoliday(NepaliDate(2081, 3, 31)), isFalse);

      NepaliHolidayService.registerCustomHolidays([customHoliday]);

      expect(NepaliHolidayService.isHoliday(NepaliDate(2081, 3, 31)), isTrue);
      // If only checking public holidays, it should return false
      expect(
        NepaliHolidayService.isHoliday(NepaliDate(2081, 3, 31),
            onlyPublicHolidays: true),
        isFalse,
      );

      final onDate = NepaliHolidayService.holidaysOn(NepaliDate(2081, 3, 31));
      expect(onDate.length, equals(1));
      expect(onDate.first.id, equals('bank_annual_closing'));

      // Cleanup
      NepaliHolidayService.clearCustomHolidays();
      expect(NepaliHolidayService.isHoliday(NepaliDate(2081, 3, 31)), isFalse);
    });

    test('registerOfficialHolidays allows dynamically adding new gazette years',
        () {
      const newGovYear = 2085;
      final holiday = NepaliHoliday(
        id: 'special_peace_day_2085',
        nameNepali: 'विशेष शान्ति दिवस',
        nameEnglish: 'Special Peace Day',
        date: NepaliDate(2085, 8, 20),
        category: HolidayCategory.public,
      );

      expect(NepaliHolidayService.isHoliday(NepaliDate(2085, 8, 20)), isFalse);

      NepaliHolidayService.registerOfficialHolidays(newGovYear, [holiday]);

      expect(NepaliHolidayService.isHoliday(NepaliDate(2085, 8, 20)), isTrue);
      final fetched = NepaliHolidayService.holidayOn(NepaliDate(2085, 8, 20));
      expect(fetched?.nameEnglish, equals('Special Peace Day'));
    });

    test('Pluggable HolidayProvider takes precedence when set', () {
      NepaliHolidayService.setCustomProvider(MockCorporateHolidayProvider());

      final holidays = NepaliHolidayService.holidaysForYear(2081);
      expect(holidays.length, equals(1));
      expect(holidays.first.id, equals('corp_anniversary_2081'));

      expect(NepaliHolidayService.isHoliday(NepaliDate(2081, 3, 15)), isTrue);
      // Default New Year is replaced by the custom provider
      expect(NepaliHolidayService.isHoliday(NepaliDate(2081, 1, 1)), isFalse);

      // Reset
      NepaliHolidayService.setCustomProvider(null);
      expect(NepaliHolidayService.isHoliday(NepaliDate(2081, 1, 1)), isTrue);
    });
  });

  group('Date Extension Methods on NepaliDate, NepaliDateTime, and DateTime',
      () {
    test('.isHoliday and .holidays extensions on NepaliDate', () {
      final newYearBs = NepaliDate(2081, 1, 1);
      expect(newYearBs.isHoliday, isTrue);
      expect(newYearBs.holidays.isNotEmpty, isTrue);
      expect(newYearBs.holidays.first.nameEnglish, equals('Nepali New Year'));

      final regularDay = NepaliDate(2081, 1, 2);
      expect(regularDay.isHoliday, isFalse);
      expect(regularDay.holidays.isEmpty, isTrue);
    });

    test('.isHoliday and .holidays extensions on NepaliDateTime', () {
      final dashamiTime = NepaliDateTime(2081, 6, 27, 10, 30);
      expect(dashamiTime.isHoliday, isTrue);
      expect(dashamiTime.holidays.first.nameNepali, equals('विजया दशमी'));
    });

    test('.isNepaliHoliday and .nepaliHolidays extensions on standard DateTime',
        () {
      // 2024-04-13 AD is 2081-01-01 BS (New Year)
      final adNewYear = DateTime.utc(2024, 4, 13);
      expect(adNewYear.isNepaliHoliday, isTrue);
      expect(adNewYear.nepaliHolidays.first.nameEnglish,
          equals('Nepali New Year'));

      // 2024-04-14 AD is 2081-01-02 BS (Regular day)
      final adRegular = DateTime.utc(2024, 4, 14);
      expect(adRegular.isNepaliHoliday, isFalse);
    });
  });
}
