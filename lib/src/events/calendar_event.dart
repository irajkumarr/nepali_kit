import 'package:meta/meta.dart';

import '../calendar/nepali_date.dart';
import '../calendar/nepali_date_time.dart';

/// Categories/types of calendar events.
enum CalendarEventType {
  /// General reminder or task.
  general,

  /// Meeting, appointment, or interview.
  meeting,

  /// Work or deadline.
  work,

  /// Personal milestone (birthday, anniversary, etc.).
  personal,

  /// Financial or tax deadline.
  financial,

  /// Custom category.
  custom,
}

/// Represents an immutable calendar event associated with a Bikram Sambat date.
///
/// Designed to be independent of UI, supporting multiple events per day,
/// custom metadata, and optional presentation styling (e.g. color hex/RGB or icon identifiers).
@immutable
class CalendarEvent implements Comparable<CalendarEvent> {
  /// Unique identifier for the event.
  final String id;

  /// Title or short summary of the event.
  final String title;

  /// The date of the event in the Bikram Sambat calendar.
  final NepaliDate date;

  /// Optional detailed description.
  final String? description;

  /// Category / event type classification.
  final CalendarEventType type;

  /// Optional 32-bit ARGB color value (e.g. 0xFF4CAF50) for pure Dart styling compatibility.
  final int? colorValue;

  /// Optional icon identifier or name (e.g. 'work', 'birthday', 'event').
  final String? iconName;

  /// Arbitrary user or system metadata (e.g. database ID, JSON payload, custom flags).
  final Map<String, dynamic>? metadata;

  const CalendarEvent({
    required this.id,
    required this.title,
    required this.date,
    this.description,
    this.type = CalendarEventType.general,
    this.colorValue,
    this.iconName,
    this.metadata,
  });

  /// Factory constructor supporting [NepaliDate], [NepaliDateTime], or [DateTime].
  factory CalendarEvent.from({
    required String id,
    required String title,
    required dynamic date,
    String? description,
    CalendarEventType type = CalendarEventType.general,
    int? colorValue,
    String? iconName,
    Map<String, dynamic>? metadata,
  }) {
    final NepaliDate bsDate;
    if (date is NepaliDate) {
      bsDate = date;
    } else if (date is NepaliDateTime) {
      bsDate = date.toNepaliDate();
    } else if (date is DateTime) {
      bsDate = NepaliDate.fromDateTime(date);
    } else {
      throw ArgumentError.value(
        date,
        'date',
        'Expected NepaliDate, NepaliDateTime, or DateTime',
      );
    }

    return CalendarEvent(
      id: id,
      title: title,
      date: bsDate,
      description: description,
      type: type,
      colorValue: colorValue,
      iconName: iconName,
      metadata: metadata,
    );
  }

  /// The date as a [NepaliDateTime] at 00:00:00.
  NepaliDateTime get dateTime => date.toNepaliDateTime();

  @override
  int compareTo(CalendarEvent other) {
    final dateComp = date.compareTo(other.date);
    if (dateComp != 0) return dateComp;
    return id.compareTo(other.id);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarEvent && other.id == id && other.date == date;

  @override
  int get hashCode => Object.hash(id, date);

  @override
  String toString() => 'CalendarEvent($id: "$title" on $date)';
}

/// A lightweight, immutable registry and query helper for [CalendarEvent]s.
@immutable
class CalendarEventCollection {
  final Map<NepaliDate, List<CalendarEvent>> _eventsMap;

  CalendarEventCollection(Iterable<CalendarEvent> events)
      : _eventsMap = _groupEvents(events);

  const CalendarEventCollection.empty() : _eventsMap = const {};

  CalendarEventCollection.fromMap(Map<NepaliDate, List<CalendarEvent>> map)
      : _eventsMap = Map<NepaliDate, List<CalendarEvent>>.unmodifiable(
          map.map((k, v) => MapEntry(k, List<CalendarEvent>.unmodifiable(v))),
        );

  static Map<NepaliDate, List<CalendarEvent>> _groupEvents(
      Iterable<CalendarEvent> events) {
    final map = <NepaliDate, List<CalendarEvent>>{};
    for (final event in events) {
      map.putIfAbsent(event.date, () => <CalendarEvent>[]).add(event);
    }
    return Map<NepaliDate, List<CalendarEvent>>.unmodifiable(
      map.map(
          (k, v) => MapEntry(k, List<CalendarEvent>.unmodifiable(v..sort()))),
    );
  }

  /// Returns `true` if there is at least one event registered on [date].
  bool hasEvents(dynamic date) {
    return eventsForDate(date).isNotEmpty;
  }

  /// Returns all events registered for the specified [date].
  List<CalendarEvent> eventsForDate(dynamic date) {
    final NepaliDate key;
    if (date is NepaliDate) {
      key = date;
    } else if (date is NepaliDateTime) {
      key = date.toNepaliDate();
    } else if (date is DateTime) {
      key = NepaliDate.fromDateTime(date);
    } else {
      return const [];
    }

    return _eventsMap[key] ?? const [];
  }

  /// Returns all registered events as a flat list sorted by date.
  List<CalendarEvent> get allEvents {
    final list = _eventsMap.values.expand((element) => element).toList();
    return list..sort();
  }

  /// Returns the underlying map of events.
  Map<NepaliDate, List<CalendarEvent>> toMap() => _eventsMap;
}
