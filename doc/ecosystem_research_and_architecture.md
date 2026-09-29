# Comprehensive Ecosystem Research & Architectural Analysis: `nepali_kit`

**Document Version:** 1.0.0  
**Date:** September 2026  
**Target:** Production-grade all-in-one Nepali Utilities Toolkit for Dart & Flutter  

---

## 1. Executive Summary

In the current Dart and Flutter ecosystem, developers creating applications for the Nepali market are forced to assemble fragmented dependencies across multiple single-purpose packages. For example, a developer typically adds `nepali_utils` for date conversion and numbers, `nepali_date_picker` for date selection dialogs, a custom or third-party package for calendars (like `clean_nepali_calendar` or `nepali_calendar_plus`), and custom in-house code for Nepali fiscal years, holiday lookups, and dual calendar displays.

This fragmentation causes severe issues:
1. **Transitive Dependency Clashes:** Conflicting versions of base date models or formatting utilities.
2. **Inconsistent APIs & Paradigms:** Divergent naming schemes (`NepaliDateTime` vs `BikramSambatDate`), differing date ranges, and incompatible parameter structures.
3. **Flutter-Coupling in Non-UI Code:** Many date picker or calendar packages bundle Flutter dependencies into foundational date conversion logic, preventing use in server-side Dart (Dart Frog, Serverpod), command-line tools, or headless background workers.
4. **Maintenance Stagnation:** Several older packages on pub.dev are either minimally maintained, carry outdated design patterns (pre-Material 3), or have gaps in edge-case date arithmetic, leap-year handling, and timezone transitions.

`nepali_kit` solves this by delivering an **architecturally cohesive, production-grade, all-in-one toolkit** that keeps the pure Dart domain logic 100% decoupled from Flutter UI while exposing an intuitive, modern, Material 3-aligned Flutter UI layer under a single, unified package.

---

## 2. Research & Ecosystem Analysis of Existing Packages

### 2.1 `nepali_utils`
- **Main Functionality:** Bikram Sambat date conversion (`NepaliDateTime`), date formatting (`NepaliDateFormat`), Nepali numbers (`NepaliNumberFormat`), Nepali Unicode transliteration, and relative moments (`NepaliMoment`).
- **Public API Style:** Heavily mirrors Dart's standard library (`DateTime`, `intl.DateFormat`).
- **Supported BS Date Range:** 1970 BS – 2090/2100 BS (depending on version release).
- **Date Conversion Implementation:** Fixed look-up table containing days per month for each BS year; offsets calculated relative to an anchor epoch.
- **Flutter Dependencies:** Pure Dart (no Flutter dependencies).
- **Dart SDK Compatibility:** Dart 2.x & 3.x with sound null safety.
- **Known Limitations:**
  - Lacks fiscal year calculations and fiscal quarter boundaries.
  - No public holiday database or tithi/festival metadata.
  - No calendar widgets or date picker dialogs (requires separate `nepali_date_picker`).
  - Formatting tokens deviate slightly from the full Unicode CLDR / ICU standards in edge cases.
  - Number-to-words conversion has limitations with very large numbers (Arba, Kharba, Shankha) and nuanced Nepali grammatical inflections (currency paisa handling).
- **Licensing:** MIT License.
- **Maintenance / Activity:** Historically popular and stable, but updates are conservative and focused primarily on core maintenance rather than expanding the ecosystem scope.

### 2.2 `nepali_date_picker`
- **Main Functionality:** Material and Cupertino date picker dialogs, date range picker dialog, and calendar views for Bikram Sambat dates.
- **Public API Style:** Mimics Flutter's `showDatePicker` and `showDateRangePicker`.
- **Supported BS Date Range:** 1970 BS – 2250 BS (extended lookup/projection data).
- **Date Conversion Implementation:** Relies on its internal or paired `NepaliDateTime` mapping.
- **Flutter Dependencies:** Hard dependency on Flutter (`flutter/material.dart`, `flutter/cupertino.dart`).
- **Dart SDK Compatibility:** Dart 3.x.
- **Known Limitations:**
  - Dialog-centric: lacks an embeddable, customizable inline calendar widget designed for dashboards or agenda feeds.
  - UI styling can feel dated when integrated into modern Flutter 3 Material 3 applications (needs explicit manual theming).
  - Tightly coupled to Flutter framework, cannot be consumed by backend or shared logic layers without dragging UI dependencies.
- **Licensing:** MIT License.
- **Maintenance / Activity:** Active, verified publisher, widely recognized in the community.

### 2.3 `clean_nepali_calendar`
- **Main Functionality:** Feature-rich customizable inline Nepali calendar widget inspired by `table_calendar`.
- **Public API Style:** Controller-based (`NepaliCalendarController`), customizable builders for days, headers, and markers.
- **Supported BS Date Range:** Typically spans 2000 BS to 2090 BS.
- **Date Conversion Implementation:** Hardcoded month mapping tables.
- **Flutter Dependencies:** Tightly coupled to Flutter framework.
- **Dart SDK Compatibility:** Dart 3.x compatible.
- **Known Limitations:**
  - Narrow focus: Only provides the inline calendar widget. Does not provide number formatting, Unicode, fiscal years, or standalone date pickers.
  - Distinct date model: Often forces developers to translate between its calendar model and other date models.
- **Licensing:** MIT License.
- **Maintenance / Activity:** Moderately active, community-driven.

### 2.4 `nepali_calendar_plus`
- **Main Functionality:** Modern Nepali calendar with horizontal/vertical scrolling, year view grids, holiday indicators, and event dots.
- **Public API Style:** Declarative widgets with `NepaliCalendarTheme` and builder callbacks.
- **Supported BS Date Range:** 2000 BS – 2089+ BS.
- **Date Conversion Implementation:** Preloaded tabular dataset with timezone adjustment considerations for Nepal Standard Time (NPT, UTC+5:45).
- **Flutter Dependencies:** Flutter-dependent.
- **Dart SDK Compatibility:** Dart 3.x.
- **Known Limitations:**
  - Relatively new, focused on UI views rather than utility broadness.
  - No fiscal year models, currency parser, or number-to-words.
- **Licensing:** MIT / Open Source.
- **Maintenance / Activity:** Active recent updates addressing UTC+5:45 timezone quirks.

### 2.5 `bikram_sambat` & `nepali_date_converter`
- **Main Functionality:** Specialized, minimal packages targeting strictly BS ↔ AD conversion and simple string formatting.
- **Public API Style:** Object-oriented or static helper methods (e.g. `BikramSambat.toGregorian()`).
- **Supported BS Date Range:** Usually 1970 BS – 2090 BS.
- **Flutter Dependencies:** Pure Dart.
- **Dart SDK Compatibility:** Varied (some older packages lack modern Dart 3 features like records, pattern matching, class modifiers).
- **Known Limitations:**
  - Very narrow utility surface. Installing these still leaves 80% of an app's Nepali requirements unaddressed.
- **Licensing:** MIT / BSD.
- **Maintenance / Activity:** Many converter-only packages are inactive or abandoned on pub.dev.

---

## 3. Comparison Matrix of Existing Ecosystem vs `nepali_kit`

| Feature Domain | `nepali_utils` | `nepali_date_picker` | `clean_nepali_calendar` | `nepali_calendar_plus` | **`nepali_kit` (Target)** |
|---|:---:|:---:|:---:|:---:|:---:|
| **Pure Dart Core (CLI/Backend)** | Yes | No | No | No | **Yes (`nepali_kit_core`)** |
| **BS ↔ AD Date Conversion** | Yes | Yes | Limited | Limited | **Yes (1970 – 2100+ BS)** |
| **DateTime Parity (`NepaliDateTime`)** | Yes | Yes | Partial | Partial | **Yes (Full Dart DateTime API)** |
| **Date Arithmetic & Comparisons** | Yes | Yes | Limited | Limited | **Yes (Immutable, type-safe)** |
| **Date Formatting & ICU-like Tokens** | Yes | Yes | No | No | **Yes (Devanagari & English)** |
| **Date Parsing & Validation** | Basic | Basic | No | No | **Yes (Robust, pattern-based)** |
| **Date Range Model** | No | Internal | No | No | **Yes (`NepaliDateRange`)** |
| **Nepali Numbers (०-९)** | Yes | No | No | No | **Yes (Bidirectional)** |
| **Nepali Currency & Grouping** | Basic | No | No | No | **Yes (South Asian grouping, Lakh/Crore)** |
| **Number to Nepali Words** | Basic | No | No | No | **Yes (Up to Kharba, Np + En)** |
| **Nepali Fiscal Year & Quarters** | No | No | No | No | **Yes (Shrawan-Ashadh, Q1-Q4)** |
| **Nepali Public Holidays & Data** | No | No | No | Basic dots | **Yes (Categorized, extensible)** |
| **Unicode & Transliteration** | Basic | No | No | No | **Yes (Comprehensive)** |
| **Relative Moments ("time ago")** | Yes | No | No | No | **Yes (Devanagari & English)** |
| **Flutter Date Picker Dialog** | No | Yes | No | No | **Yes (Material 3 standard)** |
| **Flutter Date Range Picker Dialog** | No | Yes | No | No | **Yes (Modern Material 3)** |
| **Flutter Month / Year Picker** | No | Basic | No | Yes | **Yes (Quick accounting/age pickers)** |
| **Inline Calendar Widget** | No | No | Yes | Yes | **Yes (Highly customizable)** |
| **Dual Date Display (BS + AD)** | No | No | No | No | **Yes (Synchronized badge/card)** |

---

## 4. Key Differentiators of `nepali_kit`

1. **True All-in-One Without Bloat:**
   Developers do not need to install 4-5 different packages. A single package covers conversion, formatting, UI pickers, fiscal periods, numbers, currency, and holidays.
2. **Strict Separation of Concerns:**
   Pure Dart logic is isolated in `nepali_kit_core.dart`. Developers building Serverpod/Dart Frog backends or command-line scripts can import `package:nepali_kit/nepali_kit_core.dart` with zero Flutter dependencies pulled into their binary.
3. **First-Class Nepali Fiscal Year & Quarters:**
   In Nepal, almost every ERP, fintech, tax, payroll, and billing app operates on the Shrawan 1 to Ashadh 31 fiscal year calendar. No existing major package offers a dedicated, comprehensive fiscal year and quarterly calculation API.
4. **First-Class Nepali Holidays & Metadata:**
   Preloaded national public holidays with categorization (gazetted national holiday, bank holiday, cultural/religious) and a pluggable interface for custom or corporate calendars.
5. **Modern Material 3 Flutter UI:**
   Existing pickers largely reflect older Material 2 specs. `nepali_kit`'s calendar and picker widgets are natively built around Flutter 3's Material 3 design system, supporting dynamic color schemes, dark/light modes, elevation levels, and responsive layouts.
6. **Dual BS + AD Coexistence:**
   Real-world Nepali apps constantly need to show both BS and AD simultaneously (e.g. Flight tickets, bank statements, government invoices). We provide out-of-the-box UI widgets and data structures for dual-calendar presentation.

---

## 5. Architectural Design & Boundaries

### 5.1 Pure Dart Core Layer (`lib/nepali_kit_core.dart`)
Must contain zero imports from `package:flutter/...`.
- **`date/`**:
  - `bs_calendar_data.dart`: Compact, verified historical month-days table (1970–2100+ BS) and anchor epoch offsets.
  - `bs_ad_converter.dart`: Bidirectional conversion algorithms with mathematical validation and caching.
  - `nepali_date_time.dart`: Complete implementation of `Comparable<NepaliDateTime>`, implementing standard Dart `DateTime` semantics (`year`, `month`, `day`, `hour`, `minute`, `second`, `weekday`, `add`, `subtract`, `difference`, `copyWith`).
  - `date_range.dart`: `NepaliDateRange` for start/end duration, overlap detection, and intersection.
  - `date_parser.dart`: Flexible string parser with custom formats, ISO-8601 variations, and validation helpers (`isValidBsDate(y, m, d)`).
  - `nepali_date_format.dart`: Pattern formatter supporting both Devanagari numerals/months/weekdays and English transliterated text.
- **`numbers/`**:
  - `nepali_digits.dart`: Fast string mapping between ASCII (`0-9`) and Devanagari (`०-९`).
  - `nepali_number_format.dart`: South Asian grouping (`12,34,567.89`), precision control, prefix/suffix handling.
  - `nepali_currency.dart`: Symbol formats (`रु`, `रु.`, `Rs.`, `NPR`), paisa display rules, accounting negative formats `(रु ५००)`.
  - `number_to_words.dart`: Cardinal and currency conversion up to Kharba/Shankha in both Nepali and English Romanized.
- **`fiscal/`**:
  - `nepali_fiscal_year.dart`: Fiscal year model (e.g., `2081/82`), start/end `NepaliDateTime` and Gregorian `DateTime`, previous/next transitions.
  - `nepali_fiscal_quarter.dart`: Q1 (Shrawan–Ashoj), Q2 (Kartik–Poush), Q3 (Magh–Chaitra), Q4 (Baisakh–Ashadh), quarter progress percentage, date containment.
- **`holidays/`**:
  - `nepali_holiday.dart`: Holiday model (name in Nepali & English, date, category, isGazettedPublicHoliday).
  - `holiday_provider.dart`: Interface for querying holidays by year/month or checking if a given date is a holiday/weekend.
- **`moments/`**:
  - `nepali_moments.dart`: Relative time formatting ("भर्खरै", "५ मिनेट अगाडि", "हिजो", "२ महिना पछि").
- **`unicode/`**:
  - `nepali_unicode.dart`: Smart phonetic Romanized-to-Devanagari transliteration and Devanagari text normalization.

### 5.2 Flutter UI Layer (`lib/nepali_kit.dart` & `src/widgets/`)
Built with Flutter framework dependencies:
- **`calendar/`**:
  - `nepali_calendar_view.dart`: Month/week grid view with gesture navigation, weekend highlighting (Saturday / Shaniwar in red), event indicators, and custom cell builders.
  - `calendar_theme.dart`: Granular theme configuration inheriting from ambient `Theme.of(context)`.
- **`pickers/`**:
  - `show_nepali_date_picker.dart`: Material 3 modal/dialog date picker.
  - `show_nepali_date_range_picker.dart`: Material 3 date range selector.
  - `nepali_month_year_picker.dart`: Fast month-year wheel/grid picker.
- **`dual_date/`**:
  - `dual_date_display.dart`: Responsive badge, card, or subtitle widget showing synchronized BS and AD dates.

---

## 6. Critical API Decisions to Prevent Breaking Changes

1. **Immutability of Date Objects:**
   `NepaliDateTime` must be immutable (`@immutable`) with all fields `final`, matching standard Dart `DateTime`. Mutation methods like `.add()` must return new instances.
2. **Interface Parity with Standard Library:**
   Method names and signatures must mirror Dart's `DateTime` exactly (`year`, `month`, `day`, `weekday`, `isBefore`, `isAfter`, `isAtSameMomentAs`, `compareTo`, `difference`, `add`, `subtract`, `toIso8601String`). This reduces cognitive friction and ensures drop-in familiarity.
3. **Explicit Language & Locale Enum:**
   Use a strongly typed `Language` enum (`Language.nepali`, `Language.english`) or `NepaliLocale` rather than arbitrary string identifiers ("ne", "en") in core methods, preventing runtime spelling bugs while supporting string parsing where necessary.
4. **Timezone Clarity:**
   Default all date-only operations to standard local time or Nepal Standard Time (UTC+5:45) without causing midnight-offset rollover bugs when running in foreign timezones (a common bug in existing packages).
5. **Separation of Core vs UI in Export Files:**
   Exporting `nepali_kit_core.dart` guarantees non-Flutter environments never break when importing the package.

---

## 7. Versioning & Phasing Strategy

### 7.1 Included in v1.0.0 (MVP Target)
- Complete BS ↔ AD conversion engine (1970 BS – 2100+ BS).
- `NepaliDateTime` with 100% `DateTime` parity.
- `NepaliDateFormat` (ICU token parsing and formatting in Devanagari & English).
- `NepaliDateRange` with containment and overlap logic.
- Nepali digits conversion (`0-9` ↔ `०-९`).
- South Asian number formatting with lakhs/crores comma separation.
- Nepali currency formatting (`रु`, `Rs.`) with customizable symbol placement and paisa control.
- Number to Nepali words (Devanagari & English, supporting units up to Kharba).
- Nepali Fiscal Year (`2080/81`) and Quarters (Q1–Q4).
- Relative time / moments ("भर्खरै", "३ दिन अगाडि").
- Nepali public holidays foundation with major national gazetted holidays.
- Basic Unicode normalization and Romanized Nepali transliteration.
- Flutter `showNepaliDatePicker` (Material 3).
- Flutter `showNepaliDateRangePicker`.
- Flutter `NepaliCalendarView` (inline customizable monthly grid).
- Flutter `DualDateDisplay` widget.
- 100% sound null safety, zero compiler warnings, comprehensive unit tests, and Flutter showcase example app.

### 7.2 Postponed to Future Minor Releases (v1.1+ / v1.2+)
- Full astronomical Tithi & Panchanga calculation engine (tithi, nakshatra, yoga, karana, sunrise/sunset).
- Cupertino-specific iOS wheel pickers (`showCupertinoNepaliDatePicker`).
- Complex OCR / image date extraction.
- Corporate / banking calendar sync plugins.

---

## 8. Summary & Next Steps

This research and architecture analysis demonstrates the clear need and roadmap for `nepali_kit`. By structuring the project cleanly with `nepali_kit_core.dart` for pure Dart capabilities and `nepali_kit.dart` for Flutter additions, we ensure maximum reach, architectural integrity, and developer delight across the entire Dart and Flutter community.
