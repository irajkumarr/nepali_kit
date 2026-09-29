import 'package:flutter/material.dart';

import '../../calendar/nepali_date.dart';
import '../../calendar/nepali_weekday.dart';
import '../../core/language.dart';
import '../../numbers/nepali_digits.dart';
import '../theme/nepali_calendar_theme.dart';

/// Callback signature for custom day rendering in [ADCalendarView].
typedef ADDayBuilder = Widget? Function(
  BuildContext context,
  DateTime date, {
  required bool isSelected,
  required bool isToday,
  required bool isDisabled,
  required bool hasEvents,
});

/// A clean, accessible Gregorian AD calendar widget built with dual Nepali BS awareness.
///
/// Shares the same aesthetic design language and theming system as [NepaliCalendarView],
/// providing seamless parity when users switch calendar modes.
class ADCalendarView extends StatefulWidget {
  /// The initial date displayed.
  final DateTime? initialDate;

  /// The earliest selectable date.
  final DateTime? firstDate;

  /// The latest selectable date.
  final DateTime? lastDate;

  /// Currently selected date.
  final DateTime? selectedDate;

  /// Callback when a date is tapped.
  final ValueChanged<DateTime>? onDateSelected;

  /// Optional predicate determining if a specific date should be disabled.
  final bool Function(DateTime date)? selectableDayPredicate;

  /// Map of events keyed by date.
  final Map<DateTime, List<dynamic>>? events;

  /// Whether to display dual BS day numbers underneath AD dates.
  final bool showDualNepaliDate;

  /// First weekday of the week (defaults to Sunday / 7 in DateTime.sunday).
  final NepaliWeekday firstWeekday;

  /// Language for labels.
  final Language language;

  /// Optional theme styling.
  final NepaliCalendarThemeData? theme;

  /// Custom day builder.
  final ADDayBuilder? dayBuilder;

  ADCalendarView({
    super.key,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    this.selectedDate,
    this.onDateSelected,
    this.selectableDayPredicate,
    this.events,
    this.showDualNepaliDate = false,
    this.firstWeekday = NepaliWeekday.sunday,
    this.language = Language.english,
    this.theme,
    this.dayBuilder,
  })  : initialDate = initialDate ?? selectedDate ?? DateTime.now(),
        firstDate = firstDate ?? DateTime(1918, 4, 13),
        lastDate = lastDate ?? DateTime(2043, 4, 13);

  @override
  State<ADCalendarView> createState() => _ADCalendarViewState();
}

class _ADCalendarViewState extends State<ADCalendarView> {
  late DateTime _currentMonth;
  late DateTime _today;

  static const List<String> _englishMonthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static const List<String> _nepaliMonthNamesForAd = [
    'जनवरी',
    'फेब्रुअरी',
    'मार्च',
    'अप्रिल',
    'मे',
    'जुन',
    'जुलाई',
    'अगस्ट',
    'सेप्टेम्बर',
    'अक्टोबर',
    'नोभेम्बर',
    'डिसेम्बर',
  ];

  @override
  void initState() {
    super.initState();
    final init = widget.initialDate ?? DateTime.now();
    _currentMonth = DateTime(init.year, init.month, 1);
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
  }

  @override
  void didUpdateWidget(covariant ADCalendarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != null &&
        widget.selectedDate != oldWidget.selectedDate) {
      if (widget.selectedDate!.year != _currentMonth.year ||
          widget.selectedDate!.month != _currentMonth.month) {
        _currentMonth =
            DateTime(widget.selectedDate!.year, widget.selectedDate!.month, 1);
      }
    }
  }

  bool get _canGoPrevious {
    final prevMonthEnd = DateTime(_currentMonth.year, _currentMonth.month, 0);
    return !prevMonthEnd.isBefore(widget.firstDate!);
  }

  bool get _canGoNext {
    final nextMonthStart =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    return !nextMonthStart.isAfter(widget.lastDate!);
  }

  void _previousMonth() {
    if (!_canGoPrevious) return;
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    if (!_canGoNext) return;
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  bool _isDayDisabled(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final firstOnly = DateTime(
        widget.firstDate!.year, widget.firstDate!.month, widget.firstDate!.day);
    final lastOnly = DateTime(
        widget.lastDate!.year, widget.lastDate!.month, widget.lastDate!.day);

    if (dateOnly.isBefore(firstOnly) || dateOnly.isAfter(lastOnly)) {
      return true;
    }
    if (widget.selectableDayPredicate != null &&
        !widget.selectableDayPredicate!(date)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = widget.theme ?? NepaliCalendarThemeData.of(context);

    return Semantics(
      container: true,
      label: 'Gregorian AD Calendar',
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context, effectiveTheme),
              const SizedBox(height: 8),
              _buildWeekdaysHeader(effectiveTheme),
              const SizedBox(height: 4),
              _buildDaysGrid(context, effectiveTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, NepaliCalendarThemeData theme) {
    final monthName = widget.language.isNepali
        ? _nepaliMonthNamesForAd[_currentMonth.month - 1]
        : _englishMonthNames[_currentMonth.month - 1];
    final yearStr = widget.language.isNepali
        ? NepaliDigits.toNepali(_currentMonth.year)
        : _currentMonth.year.toString();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip: 'Previous month',
          icon: const Icon(Icons.chevron_left),
          onPressed: _canGoPrevious ? _previousMonth : null,
        ),
        Text(
          '$monthName $yearStr',
          style: theme.headerTextStyle ??
              Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
        ),
        IconButton(
          tooltip: 'Next month',
          icon: const Icon(Icons.chevron_right),
          onPressed: _canGoNext ? _nextMonth : null,
        ),
      ],
    );
  }

  Widget _buildWeekdaysHeader(NepaliCalendarThemeData theme) {
    final startIndex = widget.firstWeekday.index; // 1 (Sun) to 7 (Sat)

    return Row(
      children: List.generate(7, (i) {
        final weekdayIndex = (startIndex - 1 + i) % 7 + 1;
        final weekday = NepaliWeekday.fromIndex(weekdayIndex);
        final isSaturday = weekday.isWeekend;

        final textStyle = isSaturday
            ? (theme.saturdayTextStyle ??
                TextStyle(
                  color: theme.saturdayColor,
                  fontWeight: FontWeight.bold,
                ))
            : const TextStyle(fontWeight: FontWeight.bold);

        return Expanded(
          child: Center(
            child: Text(
              weekday.getShortName(widget.language),
              style: textStyle,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDaysGrid(BuildContext context, NepaliCalendarThemeData theme) {
    // DateTime weekday: 1 = Monday, 7 = Sunday.
    // Convert to Sunday-based index: Sunday = 1, Monday = 2, ..., Saturday = 7.
    final firstDayAdWeekday = _currentMonth.weekday; // 1 (Mon) .. 7 (Sun)
    final firstDaySundayBased =
        firstDayAdWeekday == DateTime.sunday ? 1 : firstDayAdWeekday + 1;

    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;

    final firstWeekdayNum = widget.firstWeekday.index;
    final leadingEmptyCells = (firstDaySundayBased - firstWeekdayNum + 7) % 7;
    final totalCells = ((leadingEmptyCells + daysInMonth + 6) ~/ 7) * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalCells,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final dayOffset = index - leadingEmptyCells;
        if (dayOffset < 0 || dayOffset >= daysInMonth) {
          return const SizedBox.shrink();
        }

        final dayNumber = dayOffset + 1;
        final cellDate =
            DateTime(_currentMonth.year, _currentMonth.month, dayNumber);

        final isSelected = widget.selectedDate != null &&
            widget.selectedDate!.year == cellDate.year &&
            widget.selectedDate!.month == cellDate.month &&
            widget.selectedDate!.day == cellDate.day;

        final isToday = cellDate.year == _today.year &&
            cellDate.month == _today.month &&
            cellDate.day == _today.day;

        final isDisabled = _isDayDisabled(cellDate);
        final isSaturday = cellDate.weekday == DateTime.saturday;

        final hasEvents = widget.events != null &&
            widget.events!.containsKey(cellDate) &&
            widget.events![cellDate]!.isNotEmpty;

        if (widget.dayBuilder != null) {
          final custom = widget.dayBuilder!(
            context,
            cellDate,
            isSelected: isSelected,
            isToday: isToday,
            isDisabled: isDisabled,
            hasEvents: hasEvents,
          );
          if (custom != null) return custom;
        }

        return _buildDefaultDayCell(
          context,
          cellDate,
          theme: theme,
          isSelected: isSelected,
          isToday: isToday,
          isDisabled: isDisabled,
          isSaturday: isSaturday,
          hasEvents: hasEvents,
        );
      },
    );
  }

  Widget _buildDefaultDayCell(
    BuildContext context,
    DateTime cellDate, {
    required NepaliCalendarThemeData theme,
    required bool isSelected,
    required bool isToday,
    required bool isDisabled,
    required bool isSaturday,
    required bool hasEvents,
  }) {
    final dayText = cellDate.day.toString();

    Color? textColor;
    if (isDisabled) {
      textColor = theme.disabledColor;
    } else if (isSelected) {
      textColor = theme.selectedDayTextStyle?.color ??
          Theme.of(context).colorScheme.onPrimary;
    } else if (isSaturday) {
      textColor = theme.saturdayColor;
    } else {
      textColor = theme.dayTextStyle?.color;
    }

    BoxDecoration? decoration;
    if (isSelected) {
      decoration = theme.selectedDayDecoration ??
          BoxDecoration(
            color: theme.primaryColor ?? Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          );
    } else if (isToday) {
      decoration = theme.todayDecoration ??
          BoxDecoration(
            border: Border.all(
              color:
                  theme.primaryColor ?? Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
            shape: BoxShape.circle,
          );
    }

    final int? bsDay = widget.showDualNepaliDate
        ? NepaliDate.fromDateTime(cellDate).day
        : null;

    final cellContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          dayText,
          style: TextStyle(
            color: textColor,
            fontWeight: isSelected || isToday || isSaturday
                ? FontWeight.bold
                : FontWeight.normal,
            fontSize: widget.showDualNepaliDate ? 13 : 15,
          ),
        ),
        if (bsDay != null)
          Text(
            widget.language.isNepali ? NepaliDigits.toNepali(bsDay) : '$bsDay',
            style: TextStyle(
              fontSize: 9,
              color: isDisabled
                  ? theme.disabledColor
                  : isSelected
                      ? theme.selectedDayTextStyle?.color
                          ?.withValues(alpha: 0.8)
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.6),
            ),
          ),
        if (hasEvents && !widget.showDualNepaliDate)
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : theme.eventIndicatorColor ??
                      theme.primaryColor ??
                      Theme.of(context).colorScheme.primary,
            ),
          ),
      ],
    );

    return Semantics(
      label: '${cellDate.year}-${cellDate.month}-${cellDate.day}',
      selected: isSelected,
      enabled: !isDisabled,
      button: !isDisabled,
      child: InkWell(
        onTap: isDisabled ? null : () => widget.onDateSelected?.call(cellDate),
        customBorder: const CircleBorder(),
        child: Container(
          margin: const EdgeInsets.all(3),
          decoration: decoration,
          alignment: Alignment.center,
          child: cellContent,
        ),
      ),
    );
  }
}
