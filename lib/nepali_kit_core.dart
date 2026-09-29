/// Pure Dart library entry point for nepali_kit.
///
/// Contains zero dependencies on Flutter. Safe to import in backend servers
/// (Dart Frog, Serverpod), command-line tools, and pure Dart scripts.
library nepali_kit_core;

// Core base enums and exceptions
export 'src/core/constants.dart';
export 'src/core/exceptions.dart';
export 'src/core/language.dart';

// Calendar models and date representation
export 'src/calendar/nepali_date.dart';
export 'src/calendar/nepali_date_range.dart';
export 'src/calendar/nepali_date_time.dart';
export 'src/calendar/nepali_month.dart';
export 'src/calendar/nepali_weekday.dart';

// Conversion engine and extensions
export 'src/conversion/bs_ad_converter.dart';
export 'src/conversion/bs_calendar_data.dart' show BsCalendarData;
export 'src/conversion/date_extensions.dart';

// Formatting & parsing
export 'src/formatting/nepali_date_format.dart';

// Numbers & digits
export 'src/numbers/nepali_digits.dart';
export 'src/numbers/nepali_number_format.dart';

// Fiscal year & quarters
export 'src/fiscal/nepali_fiscal_quarter.dart';
export 'src/fiscal/nepali_fiscal_year.dart';

// Holidays
export 'src/holidays/holiday_data.dart' show HolidayData;
export 'src/holidays/holiday_service.dart';
export 'src/holidays/nepali_holiday.dart';

// Relative time / moments
export 'src/relative_time/nepali_moment.dart';

// Calendar events & collections
export 'src/events/calendar_event.dart';
