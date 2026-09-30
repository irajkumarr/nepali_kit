# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2026-09-30

- Improved package description metadata to meet pub.dev recommendations.
- Fixed an invalid local `file://` reference in the README.
- Improved README documentation and code references.
- No API or functionality changes.



## [1.0.0] - 2026-09-29

### Added
- **Core Calendar Engine**:
  - Pure Dart immutable `NepaliDate` (date-only) and `NepaliDateTime` (date + time).
  - Verified bidirectional BS ↔ AD conversion spanning 1975 BS to 2099 BS.
  - Invariant round-trip mathematical guarantees (`BS -> AD -> BS == BS`, `AD -> BS -> AD == AD`).
  - Month and year arithmetic with day-clamping (`addDays`, `subtractDays`, `addMonths`, `subtractMonths`, `addYears`, `subtractYears`).
  - `NepaliDateRange` with iterable date sequence and duration calculations.
  - Complete weekday and month models (`NepaliWeekday`, `NepaliMonth`) in Nepali and English.
- **Formatting, Locales & Relative Time**:
  - `NepaliDateFormat` supporting standard tokens (`yyyy`, `MMMM`, `dd`, `EEEE`, `hh:mm a`).
  - Devanagari numerals and English transliterations.
  - `formatDual()` for combined BS + AD date strings.
  - `NepaliMoment` for relative time ("भर्खरै", "५ मिनेट अगाडि", "हिजो", "भोलि").
- **Numbers, Currency & Spoken Words**:
  - South Asian comma grouping (`12,34,567.89`) via `NepaliNumberFormat`.
  - Currency formatting (`रु ५२,४५०.००` / `Rs. 52,450.00`).
  - `NepaliNumberToWords` converting numbers to Nepali words up to Kharba and Arab.
  - Number digit conversions (`NepaliDigits`).
- **Fiscal Year & Holidays**:
  - `NepaliFiscalYear` based on official Nepal Government cycle (Shrawan 1 to Ashadh end).
  - `NepaliFiscalQuarter` providing exact Q1–Q4 breakdowns.
  - `HolidayService` with national gazetted holidays and custom holiday provider support.
- **Flutter Widgets & Material 3 Pickers**:
  - `NepaliCalendarView` and `ADCalendarView` with multi-event dots and day builders.
  - `showNepaliDatePicker` and `showNepaliDateRangePicker`.
  - `NepaliMonthPicker` and `NepaliYearPicker`.
  - `DualDateDisplay` and `NepaliCalendarThemeData`.
- **Zero External Core Dependencies**:
  - Pure Dart core exposed via `nepali_kit_core.dart`.
  - Unified Flutter UI exposed via `nepali_kit.dart`.
