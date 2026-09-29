/// Base exception for all errors thrown within the `nepali_kit` package.
abstract class NepaliKitException implements Exception {
  /// A message describing the error.
  final String message;

  const NepaliKitException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when an invalid Bikram Sambat date is encountered or constructed.
class NepaliDateException extends NepaliKitException {
  /// The invalid year, if applicable.
  final int? year;

  /// The invalid month, if applicable.
  final int? month;

  /// The invalid day, if applicable.
  final int? day;

  const NepaliDateException(
    super.message, {
    this.year,
    this.month,
    this.day,
  });

  @override
  String toString() {
    if (year != null || month != null || day != null) {
      return 'NepaliDateException: $message (year: $year, month: $month, day: $day)';
    }
    return 'NepaliDateException: $message';
  }
}

/// Thrown when a string fails to parse into a valid Nepali date or number.
class NepaliDateParseException extends NepaliKitException {
  /// The source string that could not be parsed.
  final String source;

  /// The pattern that was expected, if known.
  final String? pattern;

  const NepaliDateParseException(
    super.message, {
    required this.source,
    this.pattern,
  });

  @override
  String toString() {
    if (pattern != null) {
      return 'NepaliDateParseException: $message [source: "$source", pattern: "$pattern"]';
    }
    return 'NepaliDateParseException: $message [source: "$source"]';
  }
}

/// Thrown when date conversion is attempted outside supported calendar bounds.
class ConversionOutOfBoundsException extends NepaliKitException {
  /// The out-of-bounds year or value.
  final int value;

  /// The minimum supported bound.
  final int minBound;

  /// The maximum supported bound.
  final int maxBound;

  const ConversionOutOfBoundsException(
    super.message, {
    required this.value,
    required this.minBound,
    required this.maxBound,
  });

  @override
  String toString() =>
      'ConversionOutOfBoundsException: $message (value: $value, supported range: $minBound - $maxBound)';
}
