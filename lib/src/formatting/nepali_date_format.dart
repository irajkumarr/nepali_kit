import 'package:meta/meta.dart';

import '../calendar/nepali_date.dart';
import '../calendar/nepali_date_time.dart';
import '../calendar/nepali_month.dart';
import '../calendar/nepali_weekday.dart';
import '../core/exceptions.dart';
import '../core/language.dart';
import '../numbers/nepali_digits.dart';

/// Formatter and parser for [NepaliDateTime] and [NepaliDate] supporting standard ICU tokens.
@immutable
class NepaliDateFormat {
  /// The pattern to format with.
  final String pattern;

  /// The language/script to render outputs in.
  final Language language;

  const NepaliDateFormat([
    this.pattern = 'yyyy-MM-dd',
    this.language = Language.nepali,
  ]);

  /// Preset: `yyyy-MM-dd` (e.g. `२०८१-०६-१३` or `2081-06-13`)
  factory NepaliDateFormat.yMd([Language language = Language.nepali]) =>
      NepaliDateFormat('yyyy-MM-dd', language);

  /// Preset: `d MMMM yyyy` (e.g. `१३ आश्विन २०८१` or `13 Ashwin 2081`)
  factory NepaliDateFormat.yMMMMd([Language language = Language.nepali]) =>
      NepaliDateFormat('d MMMM yyyy', language);

  /// Preset: `MMM d, yyyy` (e.g. `आश्व १३, २०८१` or `Ashw 13, 2081`)
  factory NepaliDateFormat.yMMMd([Language language = Language.nepali]) =>
      NepaliDateFormat('MMM d, yyyy', language);

  /// Preset: `EEEE, d MMMM yyyy` (e.g. `आइतबार, १३ आश्विन २०८१`)
  factory NepaliDateFormat.yMMMMEEEEd([Language language = Language.nepali]) =>
      NepaliDateFormat('EEEE, d MMMM yyyy', language);

  /// Preset: `EEE, d MMM yyyy` (e.g. `आइत, १३ आश्व २०८१` or `Sun, 13 Ashw 2081`)
  factory NepaliDateFormat.yMMMEd([Language language = Language.nepali]) =>
      NepaliDateFormat('EEE, d MMM yyyy', language);

  /// Preset: 24-hour time `HH:mm:ss`
  factory NepaliDateFormat.hms([Language language = Language.nepali]) =>
      NepaliDateFormat('HH:mm:ss', language);

  /// Preset: 12-hour time `hh:mm:ss a`
  factory NepaliDateFormat.jms([Language language = Language.nepali]) =>
      NepaliDateFormat('hh:mm:ss a', language);

  /// Formats the given [date] according to [pattern] and [language].
  ///
  /// Supports [NepaliDate], [NepaliDateTime], and Gregorian [DateTime].
  String format(dynamic date) {
    if (date is NepaliDate) {
      return formatDateTime(date.toNepaliDateTime());
    } else if (date is NepaliDateTime) {
      return formatDateTime(date);
    } else if (date is DateTime) {
      return formatDateTime(NepaliDateTime.fromDateTime(date));
    } else {
      throw ArgumentError.value(
        date,
        'date',
        'Expected NepaliDate, NepaliDateTime, or DateTime, received ${date.runtimeType}',
      );
    }
  }

  // Token regex matching in precedence order
  static final RegExp _tokenRegex = RegExp(
    r"'[^']*'|yyyy|yy|MMMM|MMM|MM|M|EEEE|EEE|dd|d|HH|H|hh|h|mm|m|ss|s|a",
  );

  /// Formats a [NepaliDateTime] instance using a single tokenized pass.
  String formatDateTime(NepaliDateTime date) {
    return pattern.replaceAllMapped(_tokenRegex, (match) {
      final token = match.group(0)!;

      // Handle quoted text literals: 'Date:' -> Date:
      if (token.startsWith("'") && token.endsWith("'")) {
        return token.length > 2 ? token.substring(1, token.length - 1) : '';
      }

      switch (token) {
        case 'yyyy':
          return _formatYear(date.year, 4);
        case 'yy':
          return _formatYear(date.year, 2);
        case 'MMMM':
          return NepaliMonth.fromIndex(date.month).getName(language);
        case 'MMM':
          return NepaliMonth.fromIndex(date.month).getShortName(language);
        case 'MM':
          return _formatDigits(date.month, 2);
        case 'M':
          return _formatDigits(date.month, 1);
        case 'EEEE':
          return NepaliWeekday.fromIndex(date.weekday).getName(language);
        case 'EEE':
          return NepaliWeekday.fromIndex(date.weekday).getShortName(language);
        case 'dd':
          return _formatDigits(date.day, 2);
        case 'd':
          return _formatDigits(date.day, 1);
        case 'HH':
          return _formatDigits(date.hour, 2);
        case 'H':
          return _formatDigits(date.hour, 1);
        case 'hh':
          final h12 = date.hour == 0
              ? 12
              : (date.hour > 12 ? date.hour - 12 : date.hour);
          return _formatDigits(h12, 2);
        case 'h':
          final h12 = date.hour == 0
              ? 12
              : (date.hour > 12 ? date.hour - 12 : date.hour);
          return _formatDigits(h12, 1);
        case 'mm':
          return _formatDigits(date.minute, 2);
        case 'm':
          return _formatDigits(date.minute, 1);
        case 'ss':
          return _formatDigits(date.second, 2);
        case 's':
          return _formatDigits(date.second, 1);
        case 'a':
          final isAm = date.hour < 12;
          return language.isNepali
              ? (isAm ? 'पूर्वाह्न' : 'अपराह्न')
              : (isAm ? 'AM' : 'PM');
        default:
          return token;
      }
    });
  }

  /// Formats both the Bikram Sambat date and its corresponding Gregorian AD date together.
  static String formatDual(
    dynamic date, {
    String bsPattern = 'yyyy-MM-dd',
    Language language = Language.nepali,
    String separator = ' • ',
  }) {
    final nepaliDate =
        date is NepaliDate ? date.toNepaliDateTime() : (date as NepaliDateTime);

    final ad = nepaliDate.toDateTime();
    final bsFormatted =
        NepaliDateFormat(bsPattern, language).format(nepaliDate);

    const enMonths = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final adFormatted =
        '${ad.year}-${ad.month.toString().padLeft(2, '0')}-${ad.day.toString().padLeft(2, '0')} (${ad.day} ${enMonths[ad.month - 1]} ${ad.year})';

    return '$bsFormatted$separator$adFormatted';
  }

  /// Parses a string into a [NepaliDateTime].
  NepaliDateTime parse(String dateString) {
    final cleaned = NepaliDigits.toEnglish(dateString);
    final parsed = NepaliDateTime.tryParse(cleaned);
    if (parsed != null) return parsed;

    throw NepaliDateParseException(
      'Could not parse string according to pattern.',
      source: dateString,
      pattern: pattern,
    );
  }

  String _formatYear(int year, int digits) {
    var str = year.toString();
    if (digits == 2 && str.length >= 4) {
      str = str.substring(str.length - 2);
    }
    return language.isNepali ? NepaliDigits.toNepali(str) : str;
  }

  String _formatDigits(int value, int padding) {
    final str = value.toString().padLeft(padding, '0');
    return language.isNepali ? NepaliDigits.toNepali(str) : str;
  }
}
