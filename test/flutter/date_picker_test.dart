import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nepali_kit/nepali_kit.dart';

void main() {
  group('NepaliDatePicker Tests', () {
    testWidgets('Opening picker and confirming date selection', (tester) async {
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

      // Dialog is open with Material 3 buttons
      expect(find.text('रद्द गर्नुहोस्'), findsOneWidget);
      expect(find.text('ठीक छ'), findsOneWidget);

      // Tap on day 15 ("१५")
      await tester.tap(find.text('१५'));
      await tester.pumpAndSettle();

      // Tap "ठीक छ" (Confirm)
      await tester.tap(find.text('ठीक छ'));
      await tester.pumpAndSettle();

      expect(result, equals(NepaliDate(2081, 6, 15)));
    });

    testWidgets('Cancelling picker returns null', (tester) async {
      NepaliDate? result = NepaliDate(2081, 1, 1);

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

      // Tap Cancel
      await tester.tap(find.text('रद्द गर्नुहोस्'));
      await tester.pumpAndSettle();

      expect(result, isNull);
    });

    testWidgets('English localization in showNepaliDatePicker', (tester) async {
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
                    language: Language.english,
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

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
      expect(find.text('Select Date'), findsOneWidget);

      // Tap day 10
      await tester.tap(find.text('10'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(result, equals(NepaliDate(2081, 6, 10)));
    });

    testWidgets('showNepaliDateTimePicker returns NepaliDateTime',
        (tester) async {
      NepaliDateTime? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () async {
                  result = await showNepaliDateTimePicker(
                    context: ctx,
                    initialDate: NepaliDateTime(2081, 6, 1, 10, 0),
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

      await tester.tap(find.text('१२'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('ठीक छ'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.year, equals(2081));
      expect(result!.month, equals(6));
      expect(result!.day, equals(12));
    });
  });

  group('NepaliDateRangePicker Tests', () {
    testWidgets('Select range and confirm returns NepaliDateRange',
        (tester) async {
      NepaliDateRange? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () async {
                  result = await showNepaliDateRangePicker(
                    context: ctx,
                    initialDateRange: NepaliDateRange(
                      start: NepaliDate(2081, 6, 5),
                      end: NepaliDate(2081, 6, 10),
                    ),
                  );
                },
                child: const Text('OPEN_RANGE_PICKER'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('OPEN_RANGE_PICKER'));
      await tester.pumpAndSettle();

      expect(find.text('मिति दायरा छान्नुहोस्'), findsOneWidget);
      expect(find.text('निश्चित गर्नुहोस्'), findsOneWidget);

      // Select start date day 10 ("१०")
      await tester.tap(find.text('१०'));
      await tester.pumpAndSettle();

      // Select end date day 20 ("२०")
      await tester.tap(find.text('२०'));
      await tester.pumpAndSettle();

      // Tap confirm
      await tester.tap(find.text('निश्चित गर्नुहोस्'));
      await tester.pumpAndSettle();

      expect(result, isNotNull);
      expect(result!.startDate, equals(NepaliDate(2081, 6, 10)));
      expect(result!.endDate, equals(NepaliDate(2081, 6, 20)));
      expect(result!.inDays, equals(11));
    });

    testWidgets('Cancelling date range picker returns null', (tester) async {
      NepaliDateRange? result = NepaliDateRange(
        start: NepaliDate(2081, 1, 1),
        end: NepaliDate(2081, 1, 5),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () async {
                  result = await showNepaliDateRangePicker(
                    context: ctx,
                  );
                },
                child: const Text('OPEN_RANGE_PICKER'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('OPEN_RANGE_PICKER'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('रद्द'));
      await tester.pumpAndSettle();

      expect(result, isNull);
    });
  });

  group('NepaliMonthPicker & NepaliYearPicker Widgets', () {
    testWidgets('NepaliMonthPicker renders 12 months and responds to taps',
        (tester) async {
      int selected = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NepaliMonthPicker(
              selectedMonth: selected,
              onMonthSelected: (month) => selected = month,
            ),
          ),
        ),
      );

      expect(find.text('बैशाख'), findsOneWidget);
      expect(find.text('चैत'), findsOneWidget);

      // Tap Shrawan ("श्रावण")
      await tester.tap(find.text('श्रावण'));
      await tester.pumpAndSettle();

      expect(selected, equals(4));
    });

    testWidgets('NepaliMonthPicker in English', (tester) async {
      int selected = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NepaliMonthPicker(
              selectedMonth: selected,
              language: Language.english,
              onMonthSelected: (month) => selected = month,
            ),
          ),
        ),
      );

      expect(find.text('Baisakh'), findsOneWidget);
      expect(find.text('Chaitra'), findsOneWidget);

      await tester.tap(find.text('Ashwin'));
      await tester.pumpAndSettle();

      expect(selected, equals(6));
    });

    testWidgets('NepaliYearPicker renders years and triggers callback',
        (tester) async {
      int selected = 2081;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NepaliYearPicker(
              selectedYear: selected,
              firstYear: 2075,
              lastYear: 2085,
              onYearSelected: (year) => selected = year,
            ),
          ),
        ),
      );

      expect(find.text('२०८१'), findsOneWidget);

      await tester.tap(find.text('२०८०'));
      await tester.pumpAndSettle();

      expect(selected, equals(2080));
    });
  });
}
