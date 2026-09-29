# Nepali Holiday Specification

## 1. Overview & Nature of Nepali Holidays

Holidays in Nepal do **not** follow fixed Gregorian or static solar patterns. Instead, official national holidays, bank holidays, and cultural festivals are determined through multiple distinct systems:

1. **Fixed Solar Bikram Sambat Dates (सौर पात्रो):**
   - A minority of holidays occur on fixed dates in Bikram Sambat every year.
   - Examples:
     - New Year (*Naya Barsha* / नयाँ वर्ष): **Baisakh 1**
     - Constitution Day (*Samvidhan Diwas* / संविधान दिवस): **Ashwin 3**
     - Martyrs' Day (*Sahid Diwas* / सहिद दिवस): **Magh 16**
     - National Democracy Day (*Prajatantra Diwas* / राष्ट्रिय प्रजातन्त्र दिवस): **Falgun 7**
     - Labor Day (*Majdoor Diwas* / मजदुर दिवस): **Baisakh 18** (May 1)
     - National Unity Day (*Prithvi Jayanti* / राष्ट्रिय एकता दिवस): **Poush 27**
     - Republic Day (*Ganatantra Diwas* / गणतन्त्र दिवस): **Jestha 15**

2. **Lunar Tithi-Based Astronomical Festivals (चान्द्र पात्रो):**
   - The majority of major festivals in Nepal depend on the lunar Hindu/Buddhist/Islamic/Kirat calendars calculated by the *Nepal Panchanga Nirnayak Bikas Samiti* (नेपाल पञ्चाङ्ग निर्णायक विकास समिति).
   - Because the lunar calendar shifts each year relative to the Bikram Sambat solar months:
     - **Dashain (दशैँ):** Ghatasthapana, Fulpati, Maha Ashtami, Maha Nawami, Vijaya Dashami shift across late Ashwin to early Kartik.
     - **Tihar (तिहार / दीपावली):** Laxmi Puja, Gobardhan Puja, Bhai Tika shift across Kartik.
     - **Maha Shivaratri (महाशिवरात्रि):** Magh Krishna Chaturdashi.
     - **Holi / Fagu Purnima (फागु पूर्णिमा):** Falgun Purnima.
     - **Buddha Jayanti (बुद्ध जयन्ती):** Baisakh Purnima.
     - **Janai Purnima / Raksha Bandhan (जनै पूर्णिमा):** Shrawan Purnima.
     - **Teej (हरितालिका तीज):** Bhadra Shukla Tritiya.
     - **Krishna Janmashtami (श्रीकृष्ण जन्माष्टमी):** Bhadra Krishna Ashtami.
     - **Chhath Parva (छठ पर्व):** Kartik Shukla Shashthi.
     - **Eid al-Fitr & Bakra Eid:** Hijri lunar calendar calculations.

3. **Year-Specific Government Gazettes (नेपाल राजपत्र):**
   - The Ministry of Home Affairs (*Griha Mantralaya* / गृह मन्त्रालय) publishes the official list of public holidays (*Sarbajanik Bida* / सार्वजनिक बिदा) annually in the Nepal Gazette before the start of each Bikram Sambat year.
   - The government periodically introduces, removes, or modifies holiday dates, half-day leaves, or regional holidays (e.g. Kathmandu Valley local holidays such as Ghode Jatra, Gai Jatra, and Indra Jatra).

---

## 2. Architectural Design Requirements

To ensure longevity and reliability without breaking changes:

1. **Separation of Concerns:**
   - **Calendar/Date Engine:** Pure calendar logic (`NepaliDate`, `NepaliDateTime`). Zero dependency on holiday data.
   - **Official Holiday Dataset:** Year-keyed holiday registry (`Map<int, List<NepaliHoliday>>`) loaded via pluggable providers.
   - **Custom/User-Defined Holidays:** Applications, banks, corporations, schools, and local municipalities can register custom holidays and override default datasets.

2. **No Static Constancy Assumption:**
   - The system must explicitly document and handle the fact that holiday dates vary by BS year.
   - For years with official gazetted data in the package, accurate dates are provided.
   - For unlisted years, fixed national holidays are provided, and users/administrators can provide a custom `HolidayProvider`.

---

## 3. Holiday Categories (`HolidayCategory`)

- **`national`:** Major national holidays observed across the country (New Year, Constitution Day, Democracy Day, Republic Day, Dashain, Tihar).
- **`public`:** Gazetted general public and banking holidays (Labor Day, International Women's Day, Martyrs' Day).
- **`religious`:** Religious and cultural celebrations (Maha Shivaratri, Buddha Jayanti, Holi, Eid, Christmas, Chhath).
- **`regional`:** Regional or city-specific holidays (e.g. Kathmandu Valley holidays like Indra Jatra, Ghode Jatra, Gai Jatra, Bhoto Jatra).
- **`custom`:** User-defined or company-specific holidays (corporate foundation day, local municipality holidays).
