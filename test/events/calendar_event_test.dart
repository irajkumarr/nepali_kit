import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nepali_kit/nepali_kit.dart';

void main() {
  group('CalendarEvent & CalendarEventCollection Tests', () {
    test('Creates CalendarEvent with proper fields and defaults', () {
      final date = NepaliDate(2081, 6, 13);
      final event = CalendarEvent(
        id: 'evt_1',
        title: 'Team Standup',
        date: date,
        description: 'Daily synchronization',
        type: CalendarEventType.work,
        colorValue: 0xFF2196F3,
        iconName: 'work',
        metadata: const {'priority': 'high', 'room': 'Virtual'},
      );

      expect(event.id, equals('evt_1'));
      expect(event.title, equals('Team Standup'));
      expect(event.date, equals(date));
      expect(event.description, equals('Daily synchronization'));
      expect(event.type, equals(CalendarEventType.work));
      expect(event.colorValue, equals(0xFF2196F3));
      expect(event.iconName, equals('work'));
      expect(event.metadata?['priority'], equals('high'));
      expect(event.dateTime.year, equals(2081));
    });

    test(
        'CalendarEvent.from constructor supports NepaliDate, NepaliDateTime, and DateTime',
        () {
      final bs = NepaliDate(2081, 6, 13);
      final bsDt = NepaliDateTime(2081, 6, 13, 10, 30);
      final ad = bs.toDateTime(); // 2024-09-29

      final e1 = CalendarEvent.from(id: '1', title: 'BS', date: bs);
      final e2 = CalendarEvent.from(id: '2', title: 'BSDT', date: bsDt);
      final e3 = CalendarEvent.from(id: '3', title: 'AD', date: ad);

      expect(e1.date, equals(NepaliDate(2081, 6, 13)));
      expect(e2.date, equals(NepaliDate(2081, 6, 13)));
      expect(e3.date, equals(NepaliDate(2081, 6, 13)));

      expect(
        () => CalendarEvent.from(id: '4', title: 'Err', date: 'invalid_date'),
        throwsArgumentError,
      );
    });

    test('CalendarEvent equality and comparison', () {
      final d1 = NepaliDate(2081, 6, 10);
      final d2 = NepaliDate(2081, 6, 15);

      final e1 = CalendarEvent(id: 'a', title: 'A', date: d1);
      final e2 = CalendarEvent(id: 'a', title: 'A copy', date: d1);
      final e3 = CalendarEvent(id: 'b', title: 'B', date: d2);

      expect(e1, equals(e2));
      expect(e1 == e3, isFalse);
      expect(e1.compareTo(e3), isNegative);
    });

    test('CalendarEventCollection grouping, lookup, and hasEvents', () {
      final d1 = NepaliDate(2081, 6, 13);
      final d2 = NepaliDate(2081, 6, 14);
      final d3 = NepaliDate(2081, 6, 20);

      final event1 = CalendarEvent(id: '1', title: 'Task 1', date: d1);
      final event2 = CalendarEvent(id: '2', title: 'Task 2', date: d1);
      final event3 = CalendarEvent(id: '3', title: 'Task 3', date: d2);

      final collection = CalendarEventCollection([event1, event2, event3]);

      // hasEvents check
      expect(collection.hasEvents(d1), isTrue);
      expect(collection.hasEvents(d2), isTrue);
      expect(collection.hasEvents(d3), isFalse);

      // eventsForDate check
      final d1Events = collection.eventsForDate(d1);
      expect(d1Events.length, equals(2));
      expect(d1Events.map((e) => e.title), containsAll(['Task 1', 'Task 2']));

      final d2Events = collection.eventsForDate(d2);
      expect(d2Events.length, equals(1));
      expect(d2Events.first.title, equals('Task 3'));

      // query via DateTime
      final d1Ad = d1.toDateTime();
      expect(collection.eventsForDate(d1Ad).length, equals(2));

      // allEvents and toMap
      expect(collection.allEvents.length, equals(3));
      expect(collection.toMap().keys, containsAll([d1, d2]));
    });

    test('Empty CalendarEventCollection behavior', () {
      const empty = CalendarEventCollection.empty();
      expect(empty.hasEvents(NepaliDate(2081, 1, 1)), isFalse);
      expect(empty.eventsForDate(NepaliDate(2081, 1, 1)), isEmpty);
      expect(empty.allEvents, isEmpty);
      expect(empty.toMap(), isEmpty);
    });
  });

  group('NepaliCalendarView Event Integration Tests', () {
    testWidgets('Renders multiple event indicators (colored dots) for a date',
        (tester) async {
      final date = NepaliDate(2081, 6, 13);
      final event1 = CalendarEvent(
        id: '1',
        title: 'Event 1',
        date: date,
        colorValue: 0xFFE91E63, // Pink
      );
      final event2 = CalendarEvent(
        id: '2',
        title: 'Event 2',
        date: date,
        colorValue: 0xFF4CAF50, // Green
      );

      final eventsMap = {
        date: [event1, event2],
      };

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NepaliCalendarView(
              initialDate: date,
              events: eventsMap,
            ),
          ),
        ),
      );

      // The day text "१३" should be present
      expect(find.text('१३'), findsOneWidget);

      // Find containers with pink and green dot colors
      final pinkDot = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration is BoxDecoration) {
          final box = widget.decoration as BoxDecoration;
          return box.color == const Color(0xFFE91E63);
        }
        return false;
      });
      final greenDot = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration is BoxDecoration) {
          final box = widget.decoration as BoxDecoration;
          return box.color == const Color(0xFF4CAF50);
        }
        return false;
      });

      expect(pinkDot, findsOneWidget);
      expect(greenDot, findsOneWidget);
    });

    testWidgets('Custom eventIndicatorBuilder overrides default dots',
        (tester) async {
      final date = NepaliDate(2081, 6, 15);
      final event = CalendarEvent(id: '1', title: 'Review', date: date);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NepaliCalendarView(
              initialDate: date,
              events: {
                date: [event],
              },
              eventIndicatorBuilder: (context, d, evts, {required isSelected}) {
                if (d == date) {
                  return const Text('EVT', style: TextStyle(fontSize: 8));
                }
                return null;
              },
            ),
          ),
        ),
      );

      expect(find.text('EVT'), findsOneWidget);
    });

    testWidgets('Coexistence of holiday and user event on the same day',
        (tester) async {
      // Ashwin 3 is Constitution Day (official national holiday)
      final holidayDate = NepaliDate(2081, 6, 3);
      final userEvent = CalendarEvent(
        id: 'h1',
        title: 'Constitution Day Gathering',
        date: holidayDate,
        colorValue: 0xFF9C27B0, // Purple
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NepaliCalendarView(
              initialDate: holidayDate,
              showHolidays: true,
              events: {
                holidayDate: [userEvent],
              },
            ),
          ),
        ),
      );

      // The day number "३" should be present
      expect(find.text('३'), findsOneWidget);

      // User event dot should still be rendered alongside holiday coloring
      final purpleDot = find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration is BoxDecoration) {
          final box = widget.decoration as BoxDecoration;
          return box.color == const Color(0xFF9C27B0);
        }
        return false;
      });
      expect(purpleDot, findsOneWidget);
    });

    testWidgets('DayBuilder receives events parameter', (tester) async {
      final date = NepaliDate(2081, 6, 18);
      final event1 = CalendarEvent(id: 'a', title: 'Task A', date: date);
      final event2 = CalendarEvent(id: 'b', title: 'Task B', date: date);

      int eventsCountReceived = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NepaliCalendarView(
              initialDate: date,
              events: {
                date: [event1, event2],
              },
              dayBuilder: (context, d,
                  {required isDisabled,
                  required hasEvents,
                  required isHoliday,
                  required isSelected,
                  required isToday,
                  List<dynamic> events = const []}) {
                if (d == date) {
                  eventsCountReceived = events.length;
                  return Text('EVENTS_COUNT_${events.length}');
                }
                return null;
              },
            ),
          ),
        ),
      );

      expect(eventsCountReceived, equals(2));
      expect(find.text('EVENTS_COUNT_2'), findsOneWidget);
    });
  });
}
