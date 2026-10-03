/// Constants defining the verified boundaries and epochs of the calendar system.
class NepaliCalendarConstants {
  NepaliCalendarConstants._();

  /// The minimum supported Bikram Sambat year (inclusive).
  static const int minBsYear = 1969;

  /// The maximum supported Bikram Sambat year (inclusive).
  static const int maxBsYear = 2250;

  /// Minimum supported Gregorian AD year corresponding to the BS range.
  static const int minAdYear = 1912;

  /// Maximum supported Gregorian AD year corresponding to the BS range.
  static const int maxAdYear = 2194;

  /// Minimum supported month index (Baisakh).
  static const int minMonth = 1;

  /// Maximum supported month index (Chaitra).
  static const int maxMonth = 12;

  /// Minimum supported day index.
  static const int minDay = 1;

  /// Maximum supported day index in any BS month.
  static const int maxDay = 32;

  /// Nepal Standard Time (NPT) offset from UTC: UTC +05:45.
  static const Duration nepalTimezoneOffset = Duration(hours: 5, minutes: 45);
}
