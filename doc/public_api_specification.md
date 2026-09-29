# Comprehensive Public API Specification: `nepali_kit`

**Document Version:** 1.0.0  
**Status:** Approved Design Specification (Pre-Implementation)  
**Target Environments:** Pure Dart (CLI/Server/Web) & Flutter (Android/iOS/Web/Desktop)  

---

## 1. Architectural Philosophy & Design Tenets

1. **Parity with Dart Standard Library (`dart:core`)**:
   `NepaliDateTime` matches the method names, parameter order, and operator semantics of Dart's standard `DateTime` (`add`, `subtract`, `difference`, `isBefore`, `isAfter`, `isAtSameMomentAs`, `compareTo`, `year`, `month`, `day`, `weekday`, `copyWith`).
2. **Immutability First**:
   All core models (`NepaliDateTime`, `NepaliDateRange`, `NepaliFiscalYear`, `NepaliFiscalQuarter`, `NepaliHoliday`) are strictly immutable (`@immutable`) and value-comparable (`operator ==` & `hashCode`).
3. **Decoupled Two-Tier Architecture**:
   - **`nepali_kit_core.dart`** (Pure Dart): Zero Flutter dependencies. Contains calendar models, date arithmetic, converters, parsing, formatting, number utilities, currency, fiscal periods, relative time, and holidays.
   - **`nepali_kit.dart`** (Flutter + Core): Re-exports all core features plus rich, customizable Material 3 UI widgets (calendar, pickers, dual date display, theme data).
4. **Strong Typing over String Flags**:
   Explicit enums (`Language`, `CalendarType`, `NepaliMonth`, `NepaliWeekday`, `FiscalQuarter`, `HolidayType`, `NepaliCurrencyFormat`) eliminate typo-induced runtime errors while maintaining ease of use.

---

## 2. Calendar Core API (Pure Dart)

### 2.1 `NepaliDateTime`
- **Layer:** Pure Dart (`nepali_kit_core.dart`)
- **Immutability:** Immutable (`@immutable`)
- **Purpose:** Primary class representing a Bikram Sambat date and time with standard Dart `DateTime` parity.

#### Constructors:
```dart
NepaliDateTime(
  int year, [
  int month = 1,
  int day = 1,
  int hour = 0,
  int minute = 0,
  int second = 0,
  int millisecond = 0,
  int microsecond = 0,
]);

NepaliDateTime.utc(
  int year, [
  int month = 1,
  int day = 1,
  int hour = 0,
  int minute = 0,
  int second = 0,
  int millisecond = 0,
  int microsecond = 0,
]);

NepaliDateTime.now();

NepaliDateTime.fromDateTime(DateTime dateTime);

NepaliDateTime.fromMillisecondsSinceEpoch(
  int millisecondsSinceEpoch, {
  bool isUtc = false,
});

NepaliDateTime.parse(String formattedString);
NepaliDateTime? tryParse(String formattedString);
```

#### Important Properties:
- `final int year` (BS year, e.g. 2081)
- `final int month` (1 to 12)
- `final int day` (1 to 32 depending on month/year)
- `final int hour`, `final int minute`, `final int second`, `final int millisecond`, `final int microsecond`
- `final int weekday` (1 = Sunday / Aaitabar, ..., 7 = Saturday / Sanibar)
- `final bool isUtc`
- `final int millisecondsSinceEpoch`
- `NepaliMonth get nepaliMonth => NepaliMonth.fromIndex(month);`
- `NepaliWeekday get nepaliWeekday => NepaliWeekday.fromIndex(weekday);`
- `int get totalDaysInMonth` (number of days in this specific BS month and year)
- `bool get isSaturday` / `bool get isWeekend` (Saturday is the standard weekend in Nepal)

#### Important Methods:
- `DateTime toDateTime()` (converts to Gregorian AD `DateTime`)
- `NepaliDateTime add(Duration duration)`
- `NepaliDateTime subtract(Duration duration)`
- `Duration difference(NepaliDateTime other)`
- `bool isBefore(NepaliDateTime other)`
- `bool isAfter(NepaliDateTime other)`
- `bool isAtSameMomentAs(NepaliDateTime other)`
- `int compareTo(NepaliDateTime other)`
- `NepaliDateTime copyWith({...})`
- `String toIso8601String()` (e.g. `"2081-05-15T10:30:00"`)
- `String format([String pattern = 'yyyy-MM-dd', Language language = Language.nepali])`
- `NepaliDateTime startOfDay`, `NepaliDateTime endOfDay`
- `NepaliDateTime startOfMonth`, `NepaliDateTime endOfMonth`
- `NepaliDateTime startOfYear`, `NepaliDateTime endOfYear`

#### Example Usage:
```dart
final today = NepaliDateTime.now();
print('Today: ${today.year}/${today.month}/${today.day}');

// Standard arithmetic
final nextWeek = today.add(const Duration(days: 7));
final adEquivalent = today.toDateTime();

// Parsing
final parsed = NepaliDateTime.parse('2081-06-15');
```

#### Edge Cases:
- Month lengths vary between 29 to 32 days in Bikram Sambat depending on the solar astronomical cycle. Calling `NepaliDateTime(2081, 1, 32)` must throw a `NepaliDateException` if Baisakh has only 31 days in 2081.
- Timezone offsets when converting around midnight (handled via epoch millisecond alignment in UTC+5:45).

---

### 2.2 `NepaliMonth` & `NepaliWeekday` Enums
- **Layer:** Pure Dart (`nepali_kit_core.dart`)
- **Immutability:** Immutable Enum
- **Purpose:** Strongly-typed representation of Nepali calendar months and weekdays with bilingual naming helpers.

```dart
enum NepaliMonth {
  baisakh(1, 'बैशाख', 'Baisakh', 'बै'),
  jestha(2, 'जेठ', 'Jestha', 'जे'),
  ashadh(3, 'असार', 'Ashadh', 'अ'),
  shrawan(4, 'श्रावण', 'Shrawan', 'श्रा'),
  bhadra(5, 'भाद्र', 'Bhadra', 'भा'),
  ashwin(6, 'आश्विन', 'Ashwin', 'आ'),
  kartik(7, 'कार्तिक', 'Kartik', 'का'),
  mangsir(8, 'मंसिर', 'Mangsir', 'मं'),
  poush(9, 'पौष', 'Poush', 'पौ'),
  magh(10, 'माघ', 'Magh', 'मा'),
  falgun(11, 'फाल्गुन', 'Falgun', 'फा'),
  chaitra(12, 'चैत', 'Chaitra', 'चै');

  final int number;
  final String nameNepali;
  final String nameEnglish;
  final String shortNepali;

  const NepaliMonth(this.number, this.nameNepali, this.nameEnglish, this.shortNepali);

  static NepaliMonth fromIndex(int monthIndex);
  String getName([Language language = Language.nepali]);
}

enum NepaliWeekday {
  sunday(1, 'आइतबार', 'Sunday', 'आइत', 'Sun'),
  monday(2, 'सोमबार', 'Monday', 'सोम', 'Mon'),
  tuesday(3, 'मंगलबार', 'Tuesday', 'मंगल', 'Tue'),
  wednesday(4, 'बुधबार', 'Wednesday', 'बुध', 'Wed'),
  thursday(5, 'बिहीबार', 'Thursday', 'बिही', 'Thu'),
  friday(6, 'शुक्रबार', 'Friday', 'शुक्र', 'Fri'),
  saturday(7, 'शनिबार', 'Saturday', 'शनि', 'Sat');

  final int number;
  final String nameNepali;
  final String nameEnglish;
  final String shortNepali;
  final String shortEnglish;

  const NepaliWeekday(this.number, this.nameNepali, this.nameEnglish, this.shortNepali, this.shortEnglish);

  static NepaliWeekday fromIndex(int weekdayIndex);
  bool get isWeekend => this == saturday;
}
```

---

### 2.3 `NepaliDateRange`
- **Layer:** Pure Dart (`nepali_kit_core.dart`)
- **Immutability:** Immutable (`@immutable`)
- **Purpose:** Encapsulates a start and end BS date for date ranges, filters, reporting periods, and UI pickers.

#### Constructors & Properties:
```dart
class NepaliDateRange {
  final NepaliDateTime start;
  final NepaliDateTime end;

  NepaliDateRange({required this.start, required this.end}) {
    assert(!start.isAfter(end), 'start cannot be after end date.');
  }

  Duration get duration => end.difference(start);
  int get inDays => duration.inDays;
  bool contains(NepaliDateTime date);
  bool overlaps(NepaliDateRange other);
  NepaliDateRange? intersection(NepaliDateRange other);
}
```

---

### 2.4 `NepaliCalendarData` (Lookup & Validation Engine)
- **Layer:** Pure Dart (`nepali_kit_core.dart`)
- **Immutability:** Immutable Utility / Service
- **Purpose:** Encapsulates verified month-length mappings (1970–2100+ BS) and anchor conversion points.

#### Important Methods:
```dart
class NepaliCalendarData {
  static const int minYear = 1970;
  static const int maxYear = 2100;

  static bool isValidBsDate(int year, int month, int day);
  static int daysInMonth(int year, int month);
  static int daysInYear(int year);
  static bool isLeapYear(int year); // Year length > 365 days
}
```

---

## 3. Bidirectional Date Conversion API (Pure Dart)

### 3.1 `NepaliDateConverter`
- **Layer:** Pure Dart (`nepali_kit_core.dart`)
- **Purpose:** Fast, mathematical conversion between Gregorian (`DateTime`) and Bikram Sambat (`NepaliDateTime`).

```dart
class NepaliDateConverter {
  /// Converts Gregorian [dateTime] (AD) to Bikram Sambat [NepaliDateTime] (BS).
  static NepaliDateTime toNepaliDate(DateTime dateTime);

  /// Converts Bikram Sambat [nepaliDate] (BS) to Gregorian [DateTime] (AD).
  static DateTime toGregorianDate(NepaliDateTime nepaliDate);

  /// Raw conversion by integer components.
  static (int year, int month, int day) bsToAd(int bsYear, int bsMonth, int bsDay);
  static (int year, int month, int day) adToBs(int adYear, int adMonth, int adDay);
}
```

#### Example Usage:
```dart
final bsDate = NepaliDateConverter.toNepaliDate(DateTime(2024, 9, 29));
final adDate = NepaliDateConverter.toGregorianDate(NepaliDateTime(2081, 6, 13));

// Direct extension method shortcuts:
final bs = DateTime.now().toNepaliDateTime();
final ad = NepaliDateTime.now().toDateTime();
```

---

## 4. Formatting & Parsing API (Pure Dart)

### 4.1 `NepaliDateFormat`
- **Layer:** Pure Dart (`nepali_kit_core.dart`)
- **Immutability:** Immutable (`@immutable`)
- **Purpose:** Formats and parses `NepaliDateTime` using ICU-standard tokens in both Devanagari and English.

#### Constructors:
```dart
class NepaliDateFormat {
  final String pattern;
  final Language language;

  NepaliDateFormat([this.pattern = 'yyyy-MM-dd', this.language = Language.nepali]);

  // Factory constructors for common standard patterns:
  factory NepaliDateFormat.yMd([Language language = Language.nepali]);
  factory NepaliDateFormat.yMMMMd([Language language = Language.nepali]);
  factory NepaliDateFormat.yMMMMEEEEd([Language language = Language.nepali]);
  factory NepaliDateFormat.jms([Language language = Language.nepali]);
}
```

#### Supported Tokens:
- `yyyy` / `yy`: Year (e.g. `२०८१` or `2081`)
- `MMMM` / `MMM` / `MM` / `M`: Month full/short/numeric (`आश्विन`, `आश्व`, `०६`, `६`)
- `dd` / `d`: Day (`१३`, `13`)
- `EEEE` / `EEE`: Weekday name (`आइतबार`, `आइत`, `Sunday`, `Sun`)
- `hh` / `HH` / `mm` / `ss`: Time components
- `a`: Ante/Post meridiem (`पूर्वाह्न` / `अपराह्न` or `AM` / `PM`)

#### Important Methods:
```dart
String format(NepaliDateTime date);
NepaliDateTime parse(String dateString);
NepaliDateTime? tryParse(String dateString);
```

#### Example Usage:
```dart
final formatter = NepaliDateFormat('EEEE, d MMMM yyyy', Language.nepali);
print(formatter.format(NepaliDateTime(2081, 6, 13)));
// Output: आइतबार, १३ आश्विन २०८१

final enFormatter = NepaliDateFormat('EEE, MMM d, yyyy', Language.english);
print(enFormatter.format(NepaliDateTime(2081, 6, 13)));
// Output: Sun, Ashwin 13, 2081
```

---

## 5. Numbers, Currency & Number-to-Words API (Pure Dart)

### 5.1 `NepaliDigits`
- **Layer:** Pure Dart (`nepali_kit_core.dart`)
- **Purpose:** Bidirectional conversion between ASCII `0-9` and Devanagari `०-९`.

```dart
class NepaliDigits {
  /// Converts English digits in a string or number to Devanagari digits.
  /// Example: '2081' -> '२०८१'
  static String toNepali(dynamic input);

  /// Converts Devanagari digits in a string to English digits.
  /// Example: '२०८१' -> '2081'
  static String toEnglish(String input);

  /// Checks if character or string contains Nepali digits.
  static bool containsNepaliDigits(String input);
}
```

### 5.2 `NepaliNumberFormat`
- **Layer:** Pure Dart (`nepali_kit_core.dart`)
- **Immutability:** Immutable (`@immutable`)
- **Purpose:** Formats numbers with South Asian/Indian-Nepali grouping (e.g., `12,34,567.89` instead of Western `1,234,567.89`).

```dart
class NepaliNumberFormat {
  final Language language;
  final int decimalDigits;
  final bool isGroupingEnabled;

  const NepaliNumberFormat({
    this.language = Language.nepali,
    this.decimalDigits = 2,
    this.isGroupingEnabled = true,
  });

  String format(num number);
  static String formatNumber(num number, {Language language = Language.nepali, int decimalDigits = 2});
}
```

### 5.3 `NepaliCurrency`
- **Layer:** Pure Dart (`nepali_kit_core.dart`)
- **Immutability:** Immutable (`@immutable`)
- **Purpose:** Currency formatting with symbols (`रु`, `रु.`, `Rs.`, `NPR`), paisa display rules, and negative balance formats.

```dart
enum CurrencySymbolType {
  rupeesShort('रु'),
  rupeesDotted('रु.'),
  englishRs('Rs.'),
  isoNpr('NPR');

  final String symbol;
  const CurrencySymbolType(this.symbol);
}

class NepaliCurrency {
  static String format(
    num amount, {
    CurrencySymbolType symbol = CurrencySymbolType.rupeesShort,
    Language language = Language.nepali,
    bool showPaisa = true,
    bool spaceBetween = true,
  });
}
```
*Example:* `NepaliCurrency.format(154200.50)` $\rightarrow$ `"रु १,५४,२००.५०"`

### 5.4 `NepaliNumberToWords`
- **Layer:** Pure Dart (`nepali_kit_core.dart`)
- **Purpose:** Converts integers and decimal currency into spelled-out words in both Nepali Devanagari and English Romanized.
- **Scale:** Ones, Tens, Hundreds, Thousands (हजार), Lakhs (लाख), Crores (करोड), Arba (अरब), Kharba (खर्ब), Shankha (शंख).

```dart
class NepaliNumberToWords {
  /// Converts [number] into words.
  /// Example: 152500 -> "एक लाख बाउन्न हजार पाँच सय"
  static String convert(
    num number, {
    Language language = Language.nepali,
    bool isCurrency = false, // If true, appends "रुपैयाँ" / "पैसा"
  });
}
```

---

## 6. Nepali Fiscal Year & Quarters API (Pure Dart)

### 6.1 `NepaliFiscalYear`
- **Layer:** Pure Dart (`nepali_kit_core.dart`)
- **Immutability:** Immutable (`@immutable`)
- **Purpose:** Represents a Nepal Government fiscal year (Shrawan 1 to Ashadh end).

```dart
class NepaliFiscalYear implements Comparable<NepaliFiscalYear> {
  final int startYear; // e.g. 2081
  final int endYear;   // e.g. 2082

  NepaliFiscalYear(this.startYear) : endYear = startYear + 1;

  factory NepaliFiscalYear.fromDate(NepaliDateTime date);
  factory NepaliFiscalYear.current();

  NepaliDateTime get startDate => NepaliDateTime(startYear, 4, 1);
  NepaliDateTime get endDate => NepaliDateTime(endYear, 3, NepaliCalendarData.daysInMonth(endYear, 3));

  DateTime get adStartDate => startDate.toDateTime();
  DateTime get adEndDate => endDate.toDateTime();

  NepaliFiscalYear get previous => NepaliFiscalYear(startYear - 1);
  NepaliFiscalYear get next => NepaliFiscalYear(startYear + 1);

  bool contains(NepaliDateTime date);
  String format([Language language = Language.nepali]); // "२०८१/८२" or "2081/82"
}
```

### 6.2 `NepaliFiscalQuarter`
- **Layer:** Pure Dart (`nepali_kit_core.dart`)
- **Immutability:** Immutable (`@immutable`)
- **Purpose:** Represents one of the 4 fiscal quarters:
  - **Q1:** Shrawan 1 – Ashoj end
  - **Q2:** Kartik 1 – Poush end
  - **Q3:** Magh 1 – Chaitra end
  - **Q4:** Baisakh 1 – Ashadh end

```dart
enum FiscalQuarterIndex { q1, q2, q3, q4 }

class NepaliFiscalQuarter {
  final NepaliFiscalYear fiscalYear;
  final FiscalQuarterIndex quarter;

  NepaliFiscalQuarter(this.fiscalYear, this.quarter);
  factory NepaliFiscalQuarter.fromDate(NepaliDateTime date);

  NepaliDateTime get startDate;
  NepaliDateTime get endDate;
  NepaliDateRange get dateRange => NepaliDateRange(start: startDate, end: endDate);
  bool contains(NepaliDateTime date);
  String get nameNepali; // "प्रथम त्रैमासिक"
  String get nameEnglish; // "First Quarter (Q1)"
}
```

---

## 7. Public Holidays API (Pure Dart)

### 7.1 `NepaliHoliday` & `NepaliHolidayProvider`
- **Layer:** Pure Dart (`nepali_kit_core.dart`)
- **Immutability:** Immutable (`@immutable`)
- **Purpose:** Representation of national public holidays, festival metadata, and pluggable custom holiday calendars.

```dart
enum HolidayCategory {
  national, // Dashain, Tihar, Constitution Day, New Year
  public,   // Gazetted public holiday
  religious,// Chhath, Teej, Buddha Jayanti, Eid, Christmas
  regional  // City or regional holiday (e.g. Indra Jatra in KTM valley)
}

class NepaliHoliday {
  final String id;
  final String nameNepali;
  final String nameEnglish;
  final NepaliDateTime date;
  final HolidayCategory category;
  final bool isPublicHoliday;
  final String? description;

  const NepaliHoliday({
    required this.id,
    required this.nameNepali,
    required this.nameEnglish,
    required this.date,
    this.category = HolidayCategory.national,
    this.isPublicHoliday = true,
    this.description,
  });
}

class NepaliHolidayService {
  static void registerCustomHolidays(List<NepaliHoliday> holidays);
  static bool isHoliday(NepaliDateTime date);
  static List<NepaliHoliday> holidaysOn(NepaliDateTime date);
  static List<NepaliHoliday> holidaysForMonth(int year, int month);
  static List<NepaliHoliday> holidaysForYear(int year);
}
```

---

## 8. Relative Time / Moments API (Pure Dart)

### 8.1 `NepaliMoment`
- **Layer:** Pure Dart (`nepali_kit_core.dart`)
- **Purpose:** Relative time strings ("भर्खरै", "५ मिनेट अगाडि", "हिजो", "अस्ति", "२ हप्ता अगाडि", "भोलि", "३ दिन पछि").

```dart
class NepaliMoment {
  static String fromDate(
    NepaliDateTime date, {
    NepaliDateTime? referenceDate,
    Language language = Language.nepali,
    bool showFullDateIfOld = true, // fallback to formatted date if > 1 year
  });
}

// Extension convenience:
extension NepaliMomentExtension on NepaliDateTime {
  String toRelativeTime([Language language = Language.nepali]) =>
      NepaliMoment.fromDate(this, language: language);
}
```

---

## 9. Nepali Text & Unicode Utilities (Pure Dart)

### 9.1 `NepaliUnicode` & `NepaliText`
- **Layer:** Pure Dart (`nepali_kit_core.dart`)
- **Purpose:** Phonetic English-to-Nepali transliteration, Devanagari character identification, and text collation.

```dart
class NepaliUnicode {
  /// Phonetic transliteration from Romanized text to Devanagari.
  /// Example: 'nepal' -> 'नेपाल', 'namaste' -> 'नमस्ते'
  static String transliterate(String romanText);
}

class NepaliText {
  static bool isDevanagari(String text);
  static bool hasNepaliCharacters(String text);
  static int compareNepali(String a, String b); // Alphabetical Devanagari collation
}
```

---

## 10. Flutter Widgets & Pickers API (`package:nepali_kit/nepali_kit.dart`)

### 10.1 `NepaliCalendar` (Inline Calendar Widget)
- **Layer:** Flutter (`src/widgets/calendar/`)
- **Purpose:** Highly customizable inline monthly calendar view with event dots, holiday badges, Saturday highlights, and gesture swiping.

```dart
class NepaliCalendar extends StatefulWidget {
  final NepaliDateTime initialDate;
  final NepaliDateTime firstDate;
  final NepaliDateTime lastDate;
  final NepaliDateTime? selectedDate;
  final ValueChanged<NepaliDateTime>? onDateSelected;
  final ValueChanged<NepaliDateTime>? onMonthChanged;
  final Language language;
  final List<NepaliHoliday>? holidays;
  final Map<NepaliDateTime, List<dynamic>>? events;
  final Widget Function(BuildContext context, NepaliDateTime date, bool isSelected, bool isToday, bool isHoliday)? dayBuilder;
  final NepaliCalendarThemeData? theme;

  const NepaliCalendar({
    Key? key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.selectedDate,
    this.onDateSelected,
    this.onMonthChanged,
    this.language = Language.nepali,
    this.holidays,
    this.events,
    this.dayBuilder,
    this.theme,
  }) : super(key: key);
}
```

### 10.2 `showNepaliDatePicker`
- **Layer:** Flutter (`src/widgets/pickers/`)
- **Purpose:** Standard Material 3 modal date picker dialog for Bikram Sambat.

```dart
Future<NepaliDateTime?> showNepaliDatePicker({
  required BuildContext context,
  required NepaliDateTime initialDate,
  required NepaliDateTime firstDate,
  required NepaliDateTime lastDate,
  Language language = Language.nepali,
  bool Function(NepaliDateTime date)? selectableDayPredicate,
  NepaliCalendarThemeData? theme,
});
```

### 10.3 `showNepaliDateRangePicker`
- **Layer:** Flutter (`src/widgets/pickers/`)
- **Purpose:** Material 3 modal date range picker dialog.

```dart
Future<NepaliDateRange?> showNepaliDateRangePicker({
  required BuildContext context,
  required NepaliDateTime firstDate,
  required NepaliDateTime lastDate,
  NepaliDateRange? initialDateRange,
  Language language = Language.nepali,
  NepaliCalendarThemeData? theme,
});
```

### 10.4 `showNepaliMonthYearPicker`
- **Layer:** Flutter (`src/widgets/pickers/`)
- **Purpose:** Fast picker for selecting only Year and Month (ideal for billing, statement filters, and birth dates).

```dart
Future<NepaliDateTime?> showNepaliMonthYearPicker({
  required BuildContext context,
  required NepaliDateTime initialDate,
  required NepaliDateTime firstDate,
  required NepaliDateTime lastDate,
  Language language = Language.nepali,
});
```

### 10.5 `DualDateDisplay`
- **Layer:** Flutter (`src/widgets/dual_date/`)
- **Purpose:** Displays synchronized BS and AD dates simultaneously with customizable layouts (row, stacked, badge).

```dart
enum DualDateDisplayStyle { inline, stacked, card, chip }

class DualDateDisplay extends StatelessWidget {
  final NepaliDateTime nepaliDate;
  final DateTime? gregorianDate; // Auto-calculated if null
  final DualDateDisplayStyle style;
  final Language primaryLanguage;
  final TextStyle? primaryTextStyle;
  final TextStyle? secondaryTextStyle;

  const DualDateDisplay({
    Key? key,
    required this.nepaliDate,
    this.gregorianDate,
    this.style = DualDateDisplayStyle.inline,
    this.primaryLanguage = Language.nepali,
    this.primaryTextStyle,
    this.secondaryTextStyle,
  }) : super(key: key);
}
```

---

## 11. API Summary Table

| Class / Function | Purpose | Layer | Immutability |
|---|---|:---:|:---:|
| `NepaliDateTime` | Primary BS date/time model with `DateTime` parity | Pure Dart | Immutable |
| `NepaliMonth` / `NepaliWeekday` | Enums with bilingual name lookups | Pure Dart | Immutable |
| `NepaliDateRange` | Date range with duration & overlap queries | Pure Dart | Immutable |
| `NepaliCalendarData` | Days-in-month lookup & BS validation | Pure Dart | Immutable |
| `NepaliDateConverter` | Bidirectional BS ↔ AD conversion engine | Pure Dart | Static / Pure |
| `NepaliDateFormat` | ICU token formatting & parsing | Pure Dart | Immutable |
| `NepaliDigits` | ASCII `0-9` ↔ Devanagari `०-९` converter | Pure Dart | Static / Pure |
| `NepaliNumberFormat` | South Asian grouping (`12,34,567.89`) | Pure Dart | Immutable |
| `NepaliCurrency` | Currency formatting (`रु`, `Rs.`, paisa) | Pure Dart | Static / Pure |
| `NepaliNumberToWords` | Number to Nepali words up to Kharba | Pure Dart | Static / Pure |
| `NepaliFiscalYear` | Shrawan–Ashadh fiscal year model | Pure Dart | Immutable |
| `NepaliFiscalQuarter` | Q1–Q4 fiscal quarter calculations | Pure Dart | Immutable |
| `NepaliHoliday` / `Service` | Public holiday models & lookup engine | Pure Dart | Immutable |
| `NepaliMoment` | Relative time strings ("भर्खरै", "५ मि अगाडि") | Pure Dart | Static / Pure |
| `NepaliUnicode` | Romanized to Devanagari transliteration | Pure Dart | Static / Pure |
| `NepaliCalendar` | Inline monthly calendar UI widget | Flutter | Widget |
| `showNepaliDatePicker` | Material 3 single date picker dialog | Flutter | Async Function |
| `showNepaliDateRangePicker`| Material 3 date range picker dialog | Flutter | Async Function |
| `showNepaliMonthYearPicker`| Month and Year picker dialog | Flutter | Async Function |
| `DualDateDisplay` | Synchronized BS + AD presentation widget | Flutter | Widget |

---
