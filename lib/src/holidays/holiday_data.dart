import '../calendar/nepali_date.dart';
import 'nepali_holiday.dart';

/// Preloaded official gazetted public holidays for Bikram Sambat years.
///
/// **Important Note:**
/// In Nepal, lunar-tithi based festivals (Dashain, Tihar, Shivaratri, Holi, Buddha Jayanti, etc.)
/// and government gazetted leaves are declared year-by-year by the Ministry of Home Affairs.
/// This dataset contains verified historical and current gazetted public holidays.
///
/// Developers or applications requiring holidays for unlisted or future years can register
/// custom holidays or configure dynamic holiday datasets via [NepaliHolidayService].
class HolidayData {
  HolidayData._();

  /// Map of year-specific holidays keyed by Bikram Sambat year.
  static final Map<int, List<NepaliHoliday>> officialHolidays = {
    // 2080 BS Official Gazetted Holidays
    2080: [
      NepaliHoliday(
        id: 'new_year_2080',
        nameNepali: 'नयाँ वर्ष',
        nameEnglish: 'Nepali New Year',
        date: NepaliDate(2080, 1, 1),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'majdoor_diwas_2080',
        nameNepali: 'विश्व मजदुर दिवस',
        nameEnglish: 'International Workers\' Day',
        date: NepaliDate(2080, 1, 18),
        category: HolidayCategory.public,
      ),
      NepaliHoliday(
        id: 'buddha_jayanti_2080',
        nameNepali: 'बुद्ध जयन्ती / उभौली पर्व',
        nameEnglish: 'Buddha Jayanti / Ubhauli',
        date: NepaliDate(2080, 1, 22),
        category: HolidayCategory.religious,
      ),
      NepaliHoliday(
        id: 'ganatantra_diwas_2080',
        nameNepali: 'गणतन्त्र दिवस',
        nameEnglish: 'Republic Day',
        date: NepaliDate(2080, 2, 15),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'janai_purnima_2080',
        nameNepali: 'जनै पूर्णिमा / रक्षाबन्धन',
        nameEnglish: 'Janai Purnima / Raksha Bandhan',
        date: NepaliDate(2080, 5, 14),
        category: HolidayCategory.religious,
      ),
      NepaliHoliday(
        id: 'krishna_janmashtami_2080',
        nameNepali: 'श्रीकृष्ण जन्माष्टमी',
        nameEnglish: 'Shree Krishna Janmashtami',
        date: NepaliDate(2080, 5, 20),
        category: HolidayCategory.religious,
      ),
      NepaliHoliday(
        id: 'constitution_day_2080',
        nameNepali: 'संविधान दिवस (राष्ट्रिय दिवस)',
        nameEnglish: 'Constitution Day',
        date: NepaliDate(2080, 6, 3),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'dashain_ghatasthapana_2080',
        nameNepali: 'घटस्थापना (दशैँ प्रारम्भ)',
        nameEnglish: 'Ghatasthapana',
        date: NepaliDate(2080, 6, 28),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'dashain_fulpati_2080',
        nameNepali: 'फूलपाती',
        nameEnglish: 'Fulpati',
        date: NepaliDate(2080, 7, 4),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'dashain_maha_ashtami_2080',
        nameNepali: 'महाअष्टमी',
        nameEnglish: 'Maha Ashtami',
        date: NepaliDate(2080, 7, 5),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'dashain_maha_nawami_2080',
        nameNepali: 'महानवमी',
        nameEnglish: 'Maha Nawami',
        date: NepaliDate(2080, 7, 6),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'dashain_vijaya_dashami_2080',
        nameNepali: 'विजया दशमी',
        nameEnglish: 'Vijaya Dashami',
        date: NepaliDate(2080, 7, 7),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'tihar_laxmi_puja_2080',
        nameNepali: 'लक्ष्मी पूजा',
        nameEnglish: 'Laxmi Puja',
        date: NepaliDate(2080, 7, 26),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'tihar_bhai_tika_2080',
        nameNepali: 'भाईटीका',
        nameEnglish: 'Bhai Tika',
        date: NepaliDate(2080, 7, 29),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'chhath_2080',
        nameNepali: 'छठ पर्व',
        nameEnglish: 'Chhath Parva',
        date: NepaliDate(2080, 8, 3),
        category: HolidayCategory.religious,
      ),
      NepaliHoliday(
        id: 'prithvi_jayanti_2080',
        nameNepali: 'पृथ्वी जयन्ती (राष्ट्रिय एकता दिवस)',
        nameEnglish: 'National Unity Day (Prithvi Jayanti)',
        date: NepaliDate(2080, 9, 27),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'martyrs_day_2080',
        nameNepali: 'सहिद दिवस',
        nameEnglish: 'Martyrs\' Day',
        date: NepaliDate(2080, 10, 16),
        category: HolidayCategory.public,
      ),
      NepaliHoliday(
        id: 'sonam_lhosar_2080',
        nameNepali: 'सोनाम ल्होसार',
        nameEnglish: 'Sonam Lhosar',
        date: NepaliDate(2080, 10, 28),
        category: HolidayCategory.religious,
      ),
      NepaliHoliday(
        id: 'democracy_day_2080',
        nameNepali: 'राष्ट्रिय प्रजातन्त्र दिवस',
        nameEnglish: 'National Democracy Day',
        date: NepaliDate(2080, 11, 7),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'maha_shivaratri_2080',
        nameNepali: 'महाशिवरात्रि',
        nameEnglish: 'Maha Shivaratri',
        date: NepaliDate(2080, 11, 25),
        category: HolidayCategory.religious,
      ),
      NepaliHoliday(
        id: 'womens_day_2080',
        nameNepali: 'अन्तर्राष्ट्रिय महिला दिवस',
        nameEnglish: 'International Women\'s Day',
        date: NepaliDate(2080, 11, 25),
        category: HolidayCategory.public,
      ),
      NepaliHoliday(
        id: 'holi_hilly_2080',
        nameNepali: 'फागु पूर्णिमा (पहाडी)',
        nameEnglish: 'Fagu Purnima (Hilly)',
        date: NepaliDate(2080, 12, 11),
        category: HolidayCategory.religious,
      ),
      NepaliHoliday(
        id: 'holi_terai_2080',
        nameNepali: 'फागु पूर्णिमा (तराई)',
        nameEnglish: 'Fagu Purnima (Terai)',
        date: NepaliDate(2080, 12, 12),
        category: HolidayCategory.religious,
      ),
    ],

    // 2081 BS Official Gazetted Holidays
    2081: [
      NepaliHoliday(
        id: 'new_year_2081',
        nameNepali: 'नयाँ वर्ष',
        nameEnglish: 'Nepali New Year',
        date: NepaliDate(2081, 1, 1),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'ram_nawami_2081',
        nameNepali: 'राम नवमी',
        nameEnglish: 'Ram Nawami',
        date: NepaliDate(2081, 1, 5),
        category: HolidayCategory.religious,
      ),
      NepaliHoliday(
        id: 'majdoor_diwas_2081',
        nameNepali: 'विश्व मजदुर दिवस',
        nameEnglish: 'International Workers\' Day',
        date: NepaliDate(2081, 1, 19),
        category: HolidayCategory.public,
      ),
      NepaliHoliday(
        id: 'buddha_jayanti_2081',
        nameNepali: 'बुद्ध जयन्ती / उभौली पर्व',
        nameEnglish: 'Buddha Jayanti / Ubhauli',
        date: NepaliDate(2081, 2, 10),
        category: HolidayCategory.religious,
      ),
      NepaliHoliday(
        id: 'ganatantra_diwas_2081',
        nameNepali: 'गणतन्त्र दिवस',
        nameEnglish: 'Republic Day',
        date: NepaliDate(2081, 2, 15),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'janai_purnima_2081',
        nameNepali: 'जनै पूर्णिमा / रक्षाबन्धन',
        nameEnglish: 'Janai Purnima / Raksha Bandhan',
        date: NepaliDate(2081, 5, 3),
        category: HolidayCategory.religious,
      ),
      NepaliHoliday(
        id: 'krishna_janmashtami_2081',
        nameNepali: 'श्रीकृष्ण जन्माष्टमी',
        nameEnglish: 'Shree Krishna Janmashtami',
        date: NepaliDate(2081, 5, 10),
        category: HolidayCategory.religious,
      ),
      NepaliHoliday(
        id: 'teej_2081',
        nameNepali: 'हरितालिका तीज',
        nameEnglish: 'Haritalika Teej',
        date: NepaliDate(2081, 5, 21),
        category: HolidayCategory.religious,
      ),
      NepaliHoliday(
        id: 'constitution_day_2081',
        nameNepali: 'संविधान दिवस (राष्ट्रिय दिवस)',
        nameEnglish: 'Constitution Day',
        date: NepaliDate(2081, 6, 3),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'dashain_ghatasthapana_2081',
        nameNepali: 'घटस्थापना (दशैँ प्रारम्भ)',
        nameEnglish: 'Ghatasthapana',
        date: NepaliDate(2081, 6, 17),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'dashain_fulpati_2081',
        nameNepali: 'फूलपाती',
        nameEnglish: 'Fulpati',
        date: NepaliDate(2081, 6, 24),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'dashain_maha_ashtami_2081',
        nameNepali: 'महाअष्टमी',
        nameEnglish: 'Maha Ashtami',
        date: NepaliDate(2081, 6, 25),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'dashain_maha_nawami_2081',
        nameNepali: 'महानवमी',
        nameEnglish: 'Maha Nawami',
        date: NepaliDate(2081, 6, 26),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'dashain_vijaya_dashami_2081',
        nameNepali: 'विजया दशमी',
        nameEnglish: 'Vijaya Dashami',
        date: NepaliDate(2081, 6, 27),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'tihar_laxmi_puja_2081',
        nameNepali: 'लक्ष्मी पूजा',
        nameEnglish: 'Laxmi Puja',
        date: NepaliDate(2081, 7, 15),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'tihar_gobardhan_puja_2081',
        nameNepali: 'गोवर्धन पूजा / म्ह पूजा',
        nameEnglish: 'Gobardhan Puja / Mha Puja',
        date: NepaliDate(2081, 7, 17),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'tihar_bhai_tika_2081',
        nameNepali: 'भाईटीका',
        nameEnglish: 'Bhai Tika',
        date: NepaliDate(2081, 7, 18),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'chhath_2081',
        nameNepali: 'छठ पर्व',
        nameEnglish: 'Chhath Parva',
        date: NepaliDate(2081, 7, 22),
        category: HolidayCategory.religious,
      ),
      NepaliHoliday(
        id: 'prithvi_jayanti_2081',
        nameNepali: 'पृथ्वी जयन्ती (राष्ट्रिय एकता दिवस)',
        nameEnglish: 'National Unity Day (Prithvi Jayanti)',
        date: NepaliDate(2081, 9, 27),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'maghi_parva_2081',
        nameNepali: 'माघे संक्रान्ति / माघी पर्व',
        nameEnglish: 'Maghe Sankranti / Maghi Parva',
        date: NepaliDate(2081, 10, 1),
        category: HolidayCategory.religious,
      ),
      NepaliHoliday(
        id: 'martyrs_day_2081',
        nameNepali: 'सहिद दिवस',
        nameEnglish: 'Martyrs\' Day',
        date: NepaliDate(2081, 10, 16),
        category: HolidayCategory.public,
      ),
      NepaliHoliday(
        id: 'sonam_lhosar_2081',
        nameNepali: 'सोनाम ल्होसार',
        nameEnglish: 'Sonam Lhosar',
        date: NepaliDate(2081, 10, 16),
        category: HolidayCategory.religious,
      ),
      NepaliHoliday(
        id: 'democracy_day_2081',
        nameNepali: 'राष्ट्रिय प्रजातन्त्र दिवस',
        nameEnglish: 'National Democracy Day',
        date: NepaliDate(2081, 11, 7),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'maha_shivaratri_2081',
        nameNepali: 'महाशिवरात्रि',
        nameEnglish: 'Maha Shivaratri',
        date: NepaliDate(2081, 11, 14),
        category: HolidayCategory.religious,
      ),
      NepaliHoliday(
        id: 'gyalpo_lhosar_2081',
        nameNepali: 'ग्याल्पो ल्होसार',
        nameEnglish: 'Gyalpo Lhosar',
        date: NepaliDate(2081, 11, 16),
        category: HolidayCategory.religious,
      ),
      NepaliHoliday(
        id: 'womens_day_2081',
        nameNepali: 'अन्तर्राष्ट्रिय महिला दिवस',
        nameEnglish: 'International Women\'s Day',
        date: NepaliDate(2081, 11, 24),
        category: HolidayCategory.public,
      ),
      NepaliHoliday(
        id: 'holi_hilly_2081',
        nameNepali: 'फागु पूर्णिमा (पहाडी)',
        nameEnglish: 'Fagu Purnima (Hilly)',
        date: NepaliDate(2081, 11, 29),
        category: HolidayCategory.religious,
      ),
      NepaliHoliday(
        id: 'holi_terai_2081',
        nameNepali: 'फागु पूर्णिमा (तराई)',
        nameEnglish: 'Fagu Purnima (Terai)',
        date: NepaliDate(2081, 11, 30),
        category: HolidayCategory.religious,
      ),
      NepaliHoliday(
        id: 'ghode_jatra_2081',
        nameNepali: 'घोडे जात्रा (काठमाडौँ उपत्यका)',
        nameEnglish: 'Ghode Jatra (Kathmandu Valley)',
        date: NepaliDate(2081, 12, 15),
        category: HolidayCategory.regional,
      ),
    ],

    // 2082 BS Gazetted / Projected Holidays
    2082: [
      NepaliHoliday(
        id: 'new_year_2082',
        nameNepali: 'नयाँ वर्ष',
        nameEnglish: 'Nepali New Year',
        date: NepaliDate(2082, 1, 1),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'majdoor_diwas_2082',
        nameNepali: 'विश्व मजदुर दिवस',
        nameEnglish: 'International Workers\' Day',
        date: NepaliDate(2082, 1, 18),
        category: HolidayCategory.public,
      ),
      NepaliHoliday(
        id: 'buddha_jayanti_2082',
        nameNepali: 'बुद्ध जयन्ती / उभौली पर्व',
        nameEnglish: 'Buddha Jayanti / Ubhauli',
        date: NepaliDate(2082, 1, 29),
        category: HolidayCategory.religious,
      ),
      NepaliHoliday(
        id: 'ganatantra_diwas_2082',
        nameNepali: 'गणतन्त्र दिवस',
        nameEnglish: 'Republic Day',
        date: NepaliDate(2082, 2, 15),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'constitution_day_2082',
        nameNepali: 'संविधान दिवस (राष्ट्रिय दिवस)',
        nameEnglish: 'Constitution Day',
        date: NepaliDate(2082, 6, 3),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'dashain_vijaya_dashami_2082',
        nameNepali: 'विजया दशमी',
        nameEnglish: 'Vijaya Dashami',
        date: NepaliDate(2082, 7, 16),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'prithvi_jayanti_2082',
        nameNepali: 'पृथ्वी जयन्ती (राष्ट्रिय एकता दिवस)',
        nameEnglish: 'National Unity Day (Prithvi Jayanti)',
        date: NepaliDate(2082, 9, 27),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'martyrs_day_2082',
        nameNepali: 'सहिद दिवस',
        nameEnglish: 'Martyrs\' Day',
        date: NepaliDate(2082, 10, 16),
        category: HolidayCategory.public,
      ),
      NepaliHoliday(
        id: 'democracy_day_2082',
        nameNepali: 'राष्ट्रिय प्रजातन्त्र दिवस',
        nameEnglish: 'National Democracy Day',
        date: NepaliDate(2082, 11, 7),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'womens_day_2082',
        nameNepali: 'अन्तर्राष्ट्रिय महिला दिवस',
        nameEnglish: 'International Women\'s Day',
        date: NepaliDate(2082, 11, 24),
        category: HolidayCategory.public,
      ),
    ],
  };

  /// Returns fixed national holidays for years that do not have dedicated gazetted entries.
  ///
  /// Fixed national holidays occur on identical Bikram Sambat solar dates every year:
  /// - Baisakh 1: Nepali New Year
  /// - Jestha 15: Republic Day
  /// - Ashwin 3: Constitution Day
  /// - Poush 27: National Unity Day
  /// - Magh 16: Martyrs' Day
  /// - Falgun 7: National Democracy Day
  static List<NepaliHoliday> getFixedHolidaysForYear(int year) {
    return [
      NepaliHoliday(
        id: 'new_year_$year',
        nameNepali: 'नयाँ वर्ष',
        nameEnglish: 'Nepali New Year',
        date: NepaliDate(year, 1, 1),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'ganatantra_diwas_$year',
        nameNepali: 'गणतन्त्र दिवस',
        nameEnglish: 'Republic Day',
        date: NepaliDate(year, 2, 15),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'constitution_day_$year',
        nameNepali: 'संविधान दिवस (राष्ट्रिय दिवस)',
        nameEnglish: 'Constitution Day',
        date: NepaliDate(year, 6, 3),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'prithvi_jayanti_$year',
        nameNepali: 'पृथ्वी जयन्ती (राष्ट्रिय एकता दिवस)',
        nameEnglish: 'National Unity Day (Prithvi Jayanti)',
        date: NepaliDate(year, 9, 27),
        category: HolidayCategory.national,
      ),
      NepaliHoliday(
        id: 'martyrs_day_$year',
        nameNepali: 'सहिद दिवस',
        nameEnglish: 'Martyrs\' Day',
        date: NepaliDate(year, 10, 16),
        category: HolidayCategory.public,
      ),
      NepaliHoliday(
        id: 'democracy_day_$year',
        nameNepali: 'राष्ट्रिय प्रजातन्त्र दिवस',
        nameEnglish: 'National Democracy Day',
        date: NepaliDate(year, 11, 7),
        category: HolidayCategory.national,
      ),
    ];
  }
}
