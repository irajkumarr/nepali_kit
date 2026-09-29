import 'package:meta/meta.dart';

import 'nepali_date.dart';
import 'nepali_date_time.dart';

/// An immutable representation of a date range in the Bikram Sambat calendar.
@immutable
class NepaliDateRange {
  /// The beginning of the date range as [NepaliDateTime].
  final NepaliDateTime start;

  /// The end of the date range as [NepaliDateTime].
  final NepaliDateTime end;

  /// The beginning of the date range as date-only [NepaliDate].
  NepaliDate get startDate => start.toNepaliDate();

  /// The end of the date range as date-only [NepaliDate].
  NepaliDate get endDate => end.toNepaliDate();

  /// Creates a [NepaliDateRange] from [start] to [end].
  ///
  /// Supports [NepaliDate], [NepaliDateTime], or [DateTime] for [start] and [end].
  /// Throws [ArgumentError] if [start] is after [end].
  NepaliDateRange({
    required dynamic start,
    required dynamic end,
  })  : start = _toDateTime(start, 'start'),
        end = _toDateTime(end, 'end') {
    if (this.start.isAfter(this.end)) {
      throw ArgumentError.value(
        end,
        'end',
        'The start date cannot be after the end date.',
      );
    }
  }

  static NepaliDateTime _toDateTime(dynamic date, String paramName) {
    if (date is NepaliDateTime) return date;
    if (date is NepaliDate) return date.toNepaliDateTime();
    if (date is DateTime) return NepaliDateTime.fromDateTime(date);
    throw ArgumentError.value(
      date,
      paramName,
      'Expected NepaliDate, NepaliDateTime, or DateTime',
    );
  }

  /// The duration between [start] and [end].
  Duration get duration => end.difference(start);

  /// The total number of full days in this range (inclusive).
  int get inDays => endDate.difference(startDate).inDays + 1;

  /// Returns an iterable over every calendar [NepaliDate] in this range from [startDate] to [endDate] inclusive.
  Iterable<NepaliDate> get days sync* {
    var current = startDate;
    while (!current.isAfter(endDate)) {
      yield current;
      current = current.addDays(1);
    }
  }

  /// Returns `true` if this range contains the given [date] (inclusive).
  bool contains(dynamic date) {
    final d = _toDateTime(date, 'date');
    return !d.isBefore(start) && !d.isAfter(end);
  }

  /// Returns `true` if this range overlaps with [other].
  bool overlaps(NepaliDateRange other) {
    return !start.isAfter(other.end) && !other.start.isAfter(end);
  }

  /// Returns the intersection between this range and [other], or `null` if they do not overlap.
  NepaliDateRange? intersection(NepaliDateRange other) {
    if (!overlaps(other)) return null;
    final newStart = start.isAfter(other.start) ? start : other.start;
    final newEnd = end.isBefore(other.end) ? end : other.end;
    return NepaliDateRange(start: newStart, end: newEnd);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NepaliDateRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'NepaliDateRange($start to $end)';
}
