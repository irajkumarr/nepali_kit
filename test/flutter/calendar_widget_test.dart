import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nepali_kit/nepali_kit.dart';

void main() {
  group('NepaliCalendarView Widget Tests', () {
    testWidgets('Renders month name and year in Devanagari by default',
        (tester) async {
      final initialDate = NepaliDate(2081, 6, 13);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NepaliCalendarView(
              initialDate: initialDate,
            ),
          ),
        ),
      );

      // Header should display "आश्विन २०८१"
      expect(find.text('आश्विन २०८१'), findsOneWidget);
      // Weekday abbreviation for Saturday: "शनि"
      expect(find.text('शनि'), findsOneWidget);
      // Day 13 in Nepali digits: "१३"
      expect(find.text('१३'), findsOneWidget);
    });

    testWidgets('Renders in English when language is Language.english',
        (tester) async {
      final initialDate = NepaliDate(2081, 6, 13);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NepaliCalendarView(
              initialDate: initialDate,
              language: Language.english,
            ),
          ),
        ),
      );

      expect(find.text('Ashwin 2081'), findsOneWidget);
      expect(find.text('Sat'), findsOneWidget);
      expect(find.text('13'), findsOneWidget);
    });

    testWidgets('Tapping on a date triggers onDateSelected callback',
        (tester) async {
      NepaliDate? selected;
      final initialDate = NepaliDate(2081, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NepaliCalendarView(
              initialDate: initialDate,
              onDateSelected: (date) {
                selected = date;
              },
            ),
          ),
        ),
      );

      // Tap on day 15 ("१५")
      await tester.tap(find.text('१५'));
      await tester.pumpAndSettle();

      expect(selected, isNotNull);
      expect(selected!.year, equals(2081));
      expect(selected!.month, equals(6));
      expect(selected!.day, equals(15));
    });

    testWidgets('Month navigation advances and regresses months',
        (tester) async {
      final initialDate = NepaliDate(2081, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NepaliCalendarView(
              initialDate: initialDate,
            ),
          ),
        ),
      );

      expect(find.text('आश्विन २०८१'), findsOneWidget);

      // Tap next month icon
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();

      // Now Kartik 2081: "कार्तिक २०८१"
      expect(find.text('कार्तिक २०८१'), findsOneWidget);

      // Tap previous month icon
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();

      expect(find.text('आश्विन २०८१'), findsOneWidget);
    });

    testWidgets('Disabled date predicate prevents selection and tapping',
        (tester) async {
      NepaliDate? selected;
      final initialDate = NepaliDate(2081, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NepaliCalendarView(
              initialDate: initialDate,
              // Disable day 10
              selectableDayPredicate: (date) => date.day != 10,
              onDateSelected: (date) => selected = date,
            ),
          ),
        ),
      );

      // Try tapping on disabled day 10 ("१०")
      await tester.tap(find.text('१०'));
      await tester.pumpAndSettle();

      expect(selected, isNull);

      // Tap on allowed day 11 ("११")
      await tester.tap(find.text('११'));
      await tester.pumpAndSettle();

      expect(selected, equals(NepaliDate(2081, 6, 11)));
    });

    testWidgets('Min and max date boundaries disable out-of-bound navigation',
        (tester) async {
      final initialDate = NepaliDate(2081, 6, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NepaliCalendarView(
              initialDate: initialDate,
              firstDate: NepaliDate(2081, 6, 1),
              lastDate: NepaliDate(2081, 6, 30),
            ),
          ),
        ),
      );

      // Previous button should be disabled because firstDate is in the current month
      final prevBtn = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.chevron_left),
      );
      expect(prevBtn.onPressed, isNull);

      // Next button should also be disabled
      final nextBtn = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.chevron_right),
      );
      expect(nextBtn.onPressed, isNull);
    });

    testWidgets('Custom dayBuilder overrides day rendering', (tester) async {
      final initialDate = NepaliDate(2081, 6, 13);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NepaliCalendarView(
              initialDate: initialDate,
              dayBuilder: (context, date,
                  {required isDisabled,
                  required hasEvents,
                  required isHoliday,
                  required isSelected,
                  required isToday,
                  List<dynamic> events = const []}) {
                if (date.day == 13) {
                  return const Text('CUSTOM_DAY_13');
                }
                return null;
              },
            ),
          ),
        ),
      );

      expect(find.text('CUSTOM_DAY_13'), findsOneWidget);
    });

    testWidgets('Dual BS + AD display shows AD dates underneath',
        (tester) async {
      final initialDate =
          NepaliDate(2081, 6, 13); // corresponds to 2024-09-29 AD

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NepaliCalendarView(
              initialDate: initialDate,
              showDualDate: true,
            ),
          ),
        ),
      );

      // Should display BS day "१३"
      expect(find.text('१३'), findsOneWidget);
      // And AD day number "29"
      expect(find.text('29'), findsOneWidget);
    });
  });

  group('ADCalendarView Widget Tests', () {
    testWidgets('Renders AD calendar with English headers and responds to taps',
        (tester) async {
      DateTime? selected;
      final initial = DateTime(2024, 9, 29);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ADCalendarView(
              initialDate: initial,
              onDateSelected: (date) => selected = date,
            ),
          ),
        ),
      );

      expect(find.text('September 2024'), findsOneWidget);
      expect(find.text('29'), findsOneWidget);

      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();

      expect(selected, isNotNull);
      expect(selected!.year, equals(2024));
      expect(selected!.month, equals(9));
      expect(selected!.day, equals(15));
    });

    testWidgets('ADCalendarView shows dual Nepali BS date numbers',
        (tester) async {
      final initial = DateTime(2024, 9, 29); // BS day is 13

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ADCalendarView(
              initialDate: initial,
              showDualNepaliDate: true,
              language: Language.nepali,
            ),
          ),
        ),
      );

      expect(find.text('29'), findsOneWidget);
      expect(find.text('१३'), findsOneWidget);
    });
  });

  group('showNepaliDatePicker Dialog Test', () {
    testWidgets('Opens dialog, selects date, and returns result',
        (tester) async {
      NepaliDate? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () async {
                  result = await showNepaliDatePicker(
                    context: ctx,
                    initialDate: NepaliDate(2081, 6, 1),
                  );
                },
                child: const Text('OPEN_PICKER'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('OPEN_PICKER'));
      await tester.pumpAndSettle();

      // Dialog is open
      expect(find.text('रद्द गर्नुहोस्'), findsOneWidget);

      // Tap on day 20 ("२०")
      await tester.tap(find.text('२०'));
      await tester.pumpAndSettle();

      // Tap confirm button "ठीक छ"
      await tester.tap(find.text('ठीक छ'));
      await tester.pumpAndSettle();

      // Dialog should close and return NepaliDate(2081, 6, 20)
      expect(result, equals(NepaliDate(2081, 6, 20)));
    });
  });
}
