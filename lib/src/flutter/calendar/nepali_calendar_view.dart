import 'package:flutter/material.dart';

import '../../calendar/nepali_date.dart';
import '../../calendar/nepali_month.dart';
import '../../calendar/nepali_weekday.dart';
import '../../conversion/bs_calendar_data.dart';
import '../../core/constants.dart';
import '../../core/language.dart';
import '../../events/calendar_event.dart';
import '../../holidays/holiday_service.dart';
import '../../holidays/nepali_holiday.dart';
import '../../numbers/nepali_digits.dart';
import '../theme/nepali_calendar_theme.dart';

/// Callback signature for custom day rendering in [NepaliCalendarView].
typedef NepaliDayBuilder = Widget? Function(
  BuildContext context,
  NepaliDate date, {
  required bool isSelected,
  required bool isToday,
  required bool isDisabled,
  required bool isHoliday,
  required bool hasEvents,
  List<dynamic> events,
});

/// Callback signature for rendering custom event indicator widgets.
typedef NepaliEventIndicatorBuilder = Widget? Function(
  BuildContext context,
  NepaliDate date,
  List<dynamic> events, {
  required bool isSelected,
});

/// Callback signature for custom header rendering in [NepaliCalendarView].
typedef NepaliHeaderBuilder = Widget Function(
  BuildContext context,
  NepaliDate currentMonth,
  VoidCallback onPreviousMonth,
  VoidCallback onNextMonth,
);

/// A production-quality, responsive inline Bikram Sambat calendar widget for Flutter.
///
/// Built on top of the tested pure Dart calendar engine without redundant conversions.
/// Fully supports month & year navigation, min/max bounds, selectable date predicates,
/// dual BS + AD display, event indicators, custom day builders, and Material 3 dark mode.
class NepaliCalendarView extends StatefulWidget {
  /// The initial month displayed.
  final NepaliDate? initialDate;

  /// The earliest selectable date (defaults to min supported calendar date).
  final NepaliDate? firstDate;

  /// The latest selectable date (defaults to max supported calendar date).
  final NepaliDate? lastDate;

  /// Currently selected date.
  final NepaliDate? selectedDate;

  /// Callback fired when a date cell is tapped.
  final ValueChanged<NepaliDate>? onDateSelected;

  /// Optional predicate determining if a specific date should be disabled.
  final bool Function(NepaliDate date)? selectableDayPredicate;

  /// Map of events keyed by date (e.g. appointment dots, reminders).
  final Map<NepaliDate, List<dynamic>>? events;

  /// Whether to display dual dates (Gregorian AD day number beneath BS day number).
  final bool showDualDate;

  /// Whether to display gazetted Nepali public holidays automatically.
  final bool showHolidays;

  /// First weekday of the week (defaults to Sunday / 1).
  final NepaliWeekday firstWeekday;

  /// The language/script to render (Nepali Devanagari or English).
  final Language language;

  /// Optional theme styling. Falls back to ambient [NepaliCalendarThemeData.of(context)].
  final NepaliCalendarThemeData? theme;

  /// Custom builder for calendar day cells.
  final NepaliDayBuilder? dayBuilder;

  /// Custom builder for calendar day event indicators.
  final NepaliEventIndicatorBuilder? eventIndicatorBuilder;

  /// Custom builder for the month/year header.
  final NepaliHeaderBuilder? headerBuilder;

  NepaliCalendarView({
    super.key,
    NepaliDate? initialDate,
    NepaliDate? firstDate,
    NepaliDate? lastDate,
    this.selectedDate,
    this.onDateSelected,
    this.selectableDayPredicate,
    this.events,
    this.showDualDate = false,
    this.showHolidays = true,
    this.firstWeekday = NepaliWeekday.sunday,
    this.language = Language.nepali,
    this.theme,
    this.dayBuilder,
    this.eventIndicatorBuilder,
    this.headerBuilder,
  })  : initialDate = initialDate ?? selectedDate ?? NepaliDate.now(),
        firstDate =
            firstDate ?? NepaliDate(NepaliCalendarConstants.minBsYear, 1, 1),
        lastDate = lastDate ??
            NepaliDate(
              NepaliCalendarConstants.maxBsYear,
              12,
              BsCalendarData.getDaysInMonth(
                  NepaliCalendarConstants.maxBsYear, 12),
            );

  @override
  State<NepaliCalendarView> createState() => _NepaliCalendarViewState();
}

class _NepaliCalendarViewState extends State<NepaliCalendarView> {
  late NepaliDate _currentMonth;
  late NepaliDate _today;

  @override
  void initState() {
    super.initState();
    final init = widget.initialDate ?? NepaliDate.now();
    _currentMonth = NepaliDate(init.year, init.month, 1);
    _today = NepaliDate.now();
  }

  @override
  void didUpdateWidget(covariant NepaliCalendarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != null &&
        widget.selectedDate != oldWidget.selectedDate) {
      if (widget.selectedDate!.year != _currentMonth.year ||
          widget.selectedDate!.month != _currentMonth.month) {
        _currentMonth = NepaliDate(
            widget.selectedDate!.year, widget.selectedDate!.month, 1);
      }
    }
  }

  bool get _canGoPrevious {
    final prevYear =
        _currentMonth.month == 1 ? _currentMonth.year - 1 : _currentMonth.year;
    final prevMonth = _currentMonth.month == 1 ? 12 : _currentMonth.month - 1;
    final prevMonthEnd = NepaliDate(
      prevYear,
      prevMonth,
      BsCalendarData.getDaysInMonth(prevYear, prevMonth),
    );
    return !prevMonthEnd.isBefore(widget.firstDate!);
  }

  bool get _canGoNext {
    final nextYear =
        _currentMonth.month == 12 ? _currentMonth.year + 1 : _currentMonth.year;
    final nextMonth = _currentMonth.month == 12 ? 1 : _currentMonth.month + 1;
    final nextMonthStart = NepaliDate(nextYear, nextMonth, 1);
    return !nextMonthStart.isAfter(widget.lastDate!);
  }

  void _previousMonth() {
    if (!_canGoPrevious) return;
    setState(() {
      if (_currentMonth.month == 1) {
        _currentMonth = NepaliDate(_currentMonth.year - 1, 12, 1);
      } else {
        _currentMonth =
            NepaliDate(_currentMonth.year, _currentMonth.month - 1, 1);
      }
    });
  }

  void _nextMonth() {
    if (!_canGoNext) return;
    setState(() {
      if (_currentMonth.month == 12) {
        _currentMonth = NepaliDate(_currentMonth.year + 1, 1, 1);
      } else {
        _currentMonth =
            NepaliDate(_currentMonth.year, _currentMonth.month + 1, 1);
      }
    });
  }

  void _showYearMonthPicker(BuildContext context) async {
    final selected = await showDialog<NepaliDate>(
      context: context,
      builder: (ctx) => _YearMonthSelectionDialog(
        currentMonth: _currentMonth,
        firstDate: widget.firstDate!,
        lastDate: widget.lastDate!,
        language: widget.language,
      ),
    );
    if (selected != null && mounted) {
      setState(() {
        _currentMonth = selected;
      });
    }
  }

  bool _isDayDisabled(NepaliDate date) {
    if (date.isBefore(widget.firstDate!) || date.isAfter(widget.lastDate!)) {
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
      label: 'Bikram Sambat Calendar',
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
    if (widget.headerBuilder != null) {
      return widget.headerBuilder!(
        context,
        _currentMonth,
        _previousMonth,
        _nextMonth,
      );
    }

    final monthName =
        NepaliMonth.fromIndex(_currentMonth.month).getName(widget.language);
    final yearStr = widget.language.isNepali
        ? NepaliDigits.toNepali(_currentMonth.year)
        : _currentMonth.year.toString();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          tooltip:
              widget.language.isNepali ? 'अघिल्लो महिना' : 'Previous month',
          icon: const Icon(Icons.chevron_left),
          onPressed: _canGoPrevious ? _previousMonth : null,
        ),
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _showYearMonthPicker(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$monthName $yearStr',
                  style: theme.headerTextStyle ??
                      Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 20),
              ],
            ),
          ),
        ),
        IconButton(
          tooltip: widget.language.isNepali ? 'पछिल्लो महिना' : 'Next month',
          icon: const Icon(Icons.chevron_right),
          onPressed: _canGoNext ? _nextMonth : null,
        ),
      ],
    );
  }

  Widget _buildWeekdaysHeader(NepaliCalendarThemeData theme) {
    final startIndex = widget.firstWeekday.index; // 1 to 7

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
    final firstDayWeekday = _currentMonth.weekday; // 1 (Sun) to 7 (Sat)
    final daysInMonth = _currentMonth.totalDaysInMonth;

    // Shift based on widget.firstWeekday
    final firstWeekdayNum = widget.firstWeekday.index;
    final leadingEmptyCells = (firstDayWeekday - firstWeekdayNum + 7) % 7;
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
            NepaliDate(_currentMonth.year, _currentMonth.month, dayNumber);

        final isSelected = widget.selectedDate != null &&
            widget.selectedDate!.year == cellDate.year &&
            widget.selectedDate!.month == cellDate.month &&
            widget.selectedDate!.day == cellDate.day;

        final isToday = cellDate.year == _today.year &&
            cellDate.month == _today.month &&
            cellDate.day == _today.day;

        final isDisabled = _isDayDisabled(cellDate);
        final isSaturday = cellDate.isSaturday;
        final holiday = widget.showHolidays
            ? NepaliHolidayService.holidayOn(cellDate)
            : null;
        final isHoliday = holiday != null;

        final eventsList = widget.events?[cellDate] ?? const [];
        final hasEvents = eventsList.isNotEmpty;

        // Use custom day builder if provided
        if (widget.dayBuilder != null) {
          final custom = widget.dayBuilder!(
            context,
            cellDate,
            isSelected: isSelected,
            isToday: isToday,
            isDisabled: isDisabled,
            isHoliday: isHoliday,
            hasEvents: hasEvents,
            events: eventsList,
          );
          if (custom != null) {
            return custom;
          }
        }

        return _buildDefaultDayCell(
          context,
          cellDate,
          theme: theme,
          isSelected: isSelected,
          isToday: isToday,
          isDisabled: isDisabled,
          isSaturday: isSaturday,
          holiday: holiday,
          hasEvents: hasEvents,
          events: eventsList,
        );
      },
    );
  }

  Widget _buildDefaultDayCell(
    BuildContext context,
    NepaliDate cellDate, {
    required NepaliCalendarThemeData theme,
    required bool isSelected,
    required bool isToday,
    required bool isDisabled,
    required bool isSaturday,
    required NepaliHoliday? holiday,
    required bool hasEvents,
    required List<dynamic> events,
  }) {
    final dayText = widget.language.isNepali
        ? NepaliDigits.toNepali(cellDate.day)
        : cellDate.day.toString();

    // Determine cell text color
    Color? textColor;
    if (isDisabled) {
      textColor = theme.disabledColor;
    } else if (isSelected) {
      textColor = theme.selectedDayTextStyle?.color ??
          Theme.of(context).colorScheme.onPrimary;
    } else if (isSaturday) {
      textColor = theme.saturdayColor;
    } else if (holiday != null) {
      textColor = theme.holidayColor;
    } else {
      textColor = theme.dayTextStyle?.color;
    }

    // Determine cell container decoration
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

    // Dual AD date support
    final int? adDay = widget.showDualDate ? cellDate.toDateTime().day : null;

    // Build event indicator (custom builder if provided, otherwise multi-event dots)
    Widget? eventIndicatorWidget;
    if (hasEvents) {
      if (widget.eventIndicatorBuilder != null) {
        eventIndicatorWidget = widget.eventIndicatorBuilder!(
          context,
          cellDate,
          events,
          isSelected: isSelected,
        );
      } else if (!widget.showDualDate) {
        // Default indicator dots: up to 3 dots with their own colors if available
        final displayDots = events.take(3).toList();
        eventIndicatorWidget = Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: displayDots.map((e) {
            Color dotColor;
            if (isSelected) {
              dotColor = Theme.of(context).colorScheme.onPrimary;
            } else if (e is CalendarEvent && e.colorValue != null) {
              dotColor = Color(e.colorValue!);
            } else {
              dotColor = theme.eventIndicatorColor ??
                  theme.primaryColor ??
                  Theme.of(context).colorScheme.primary;
            }
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor,
              ),
            );
          }).toList(),
        );
      }
    }

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
            fontSize: widget.showDualDate ? 13 : 15,
          ),
        ),
        if (adDay != null)
          Text(
            '$adDay',
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
        if (eventIndicatorWidget != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: eventIndicatorWidget,
          ),
      ],
    );

    final semanticLabel =
        '${cellDate.year} ${NepaliMonth.fromIndex(cellDate.month).getName(widget.language)} ${cellDate.day}'
        '${holiday != null ? ', ${holiday.getName(widget.language)}' : ''}';

    return Semantics(
      label: semanticLabel,
      selected: isSelected,
      enabled: !isDisabled,
      button: !isDisabled,
      child: Tooltip(
        message: holiday != null ? holiday.getName(widget.language) : '',
        child: InkWell(
          onTap:
              isDisabled ? null : () => widget.onDateSelected?.call(cellDate),
          customBorder: const CircleBorder(),
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: decoration,
            alignment: Alignment.center,
            child: cellContent,
          ),
        ),
      ),
    );
  }
}

/// Dialog for quick Month & Year navigation in Bikram Sambat.
class _YearMonthSelectionDialog extends StatefulWidget {
  final NepaliDate currentMonth;
  final NepaliDate firstDate;
  final NepaliDate lastDate;
  final Language language;

  const _YearMonthSelectionDialog({
    required this.currentMonth,
    required this.firstDate,
    required this.lastDate,
    required this.language,
  });

  @override
  State<_YearMonthSelectionDialog> createState() =>
      _YearMonthSelectionDialogState();
}

class _YearMonthSelectionDialogState extends State<_YearMonthSelectionDialog> {
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.currentMonth.year;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final years = List.generate(
      widget.lastDate.year - widget.firstDate.year + 1,
      (i) => widget.firstDate.year + i,
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.language.isNepali
                      ? 'वर्ष तथा महिना छान्नुहोस्'
                      : 'Select Month & Year',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(),
            // Year dropdown selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.language.isNepali ? 'वर्ष: ' : 'Year: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<int>(
                  value: _selectedYear,
                  items: years.map((y) {
                    final label = widget.language.isNepali
                        ? NepaliDigits.toNepali(y)
                        : y.toString();
                    return DropdownMenuItem(value: y, child: Text(label));
                  }).toList(),
                  onChanged: (newYear) {
                    if (newYear != null) {
                      setState(() => _selectedYear = newYear);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Month grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 12,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, idx) {
                final monthNum = idx + 1;
                final month = NepaliMonth.fromIndex(monthNum);
                final isSelected = _selectedYear == widget.currentMonth.year &&
                    monthNum == widget.currentMonth.month;

                return OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        isSelected ? theme.colorScheme.primaryContainer : null,
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(NepaliDate(_selectedYear, monthNum, 1));
                  },
                  child: Text(
                    month.getName(widget.language),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
