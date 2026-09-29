import 'package:flutter/material.dart';

import '../../calendar/nepali_date.dart';
import '../../calendar/nepali_date_range.dart';
import '../../calendar/nepali_month.dart';
import '../../calendar/nepali_weekday.dart';
import '../../conversion/bs_calendar_data.dart';
import '../../core/constants.dart';
import '../../core/language.dart';
import '../../numbers/nepali_digits.dart';
import '../theme/nepali_calendar_theme.dart';

/// Production-quality date range picker dialog for the Bikram Sambat calendar.
///
/// Follows Material 3 design paradigms while presenting a genuine Bikram Sambat experience.
Future<NepaliDateRange?> showNepaliDateRangePicker({
  required BuildContext context,
  NepaliDateRange? initialDateRange,
  NepaliDate? firstDate,
  NepaliDate? lastDate,
  Language language = Language.nepali,
  NepaliCalendarThemeData? theme,
  bool Function(NepaliDate date)? selectableDayPredicate,
}) {
  final initFirst =
      firstDate ?? NepaliDate(NepaliCalendarConstants.minBsYear, 1, 1);
  final initLast = lastDate ??
      NepaliDate(
        NepaliCalendarConstants.maxBsYear,
        12,
        BsCalendarData.getDaysInMonth(NepaliCalendarConstants.maxBsYear, 12),
      );

  return showDialog<NepaliDateRange>(
    context: context,
    builder: (BuildContext dialogContext) {
      return _NepaliDateRangePickerDialog(
        initialDateRange: initialDateRange,
        firstDate: initFirst,
        lastDate: initLast,
        language: language,
        theme: theme,
        selectableDayPredicate: selectableDayPredicate,
      );
    },
  );
}

class _NepaliDateRangePickerDialog extends StatefulWidget {
  final NepaliDateRange? initialDateRange;
  final NepaliDate firstDate;
  final NepaliDate lastDate;
  final Language language;
  final NepaliCalendarThemeData? theme;
  final bool Function(NepaliDate date)? selectableDayPredicate;

  const _NepaliDateRangePickerDialog({
    required this.initialDateRange,
    required this.firstDate,
    required this.lastDate,
    required this.language,
    this.theme,
    this.selectableDayPredicate,
  });

  @override
  State<_NepaliDateRangePickerDialog> createState() =>
      _NepaliDateRangePickerDialogState();
}

class _NepaliDateRangePickerDialogState
    extends State<_NepaliDateRangePickerDialog> {
  NepaliDate? _rangeStart;
  NepaliDate? _rangeEnd;
  late NepaliDate _currentMonth;

  @override
  void initState() {
    super.initState();
    if (widget.initialDateRange != null) {
      _rangeStart = widget.initialDateRange!.startDate;
      _rangeEnd = widget.initialDateRange!.endDate;
      _currentMonth = NepaliDate(_rangeStart!.year, _rangeStart!.month, 1);
    } else {
      final now = NepaliDate.now();
      _currentMonth = NepaliDate(now.year, now.month, 1);
    }
  }

  void _onDateTapped(NepaliDate date) {
    if (widget.selectableDayPredicate != null &&
        !widget.selectableDayPredicate!(date)) {
      return;
    }

    setState(() {
      if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
        _rangeStart = date;
        _rangeEnd = null;
      } else if (_rangeStart != null && _rangeEnd == null) {
        if (date.isBefore(_rangeStart!)) {
          _rangeStart = date;
        } else {
          _rangeEnd = date;
        }
      }
    });
  }

  void _previousMonth() {
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
    setState(() {
      if (_currentMonth.month == 12) {
        _currentMonth = NepaliDate(_currentMonth.year + 1, 1, 1);
      } else {
        _currentMonth =
            NepaliDate(_currentMonth.year, _currentMonth.month + 1, 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = widget.theme ?? NepaliCalendarThemeData.of(context);
    final theme = Theme.of(context);

    final rangeText = _formatRangeHeader();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Dialog Title and Range Display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.language.isNepali
                            ? 'मिति दायरा छान्नुहोस्'
                            : 'Select Date Range',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    rangeText,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Divider(),
                // Month Navigation Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _previousMonth,
                    ),
                    Text(
                      '${NepaliMonth.fromIndex(_currentMonth.month).getName(widget.language)} '
                      '${widget.language.isNepali ? NepaliDigits.toNepali(_currentMonth.year) : _currentMonth.year}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: _nextMonth,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Weekday Labels
                Row(
                  children: List.generate(7, (i) {
                    final weekday = NepaliWeekday.fromIndex(i + 1);
                    return Expanded(
                      child: Center(
                        child: Text(
                          weekday.getShortName(widget.language),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: weekday.isWeekend
                                ? effectiveTheme.saturdayColor
                                : null,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 6),
                // Days Grid with Range Highlighting
                _buildRangeGrid(effectiveTheme),
                const SizedBox(height: 12),
                // Actions: Cancel / Confirm
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(widget.language.isNepali ? 'रद्द' : 'Cancel'),
                    ),
                    FilledButton(
                      onPressed: _rangeStart != null && _rangeEnd != null
                          ? () {
                              final range = NepaliDateRange(
                                start: _rangeStart!,
                                end: _rangeEnd!,
                              );
                              Navigator.of(context).pop(range);
                            }
                          : null,
                      child: Text(widget.language.isNepali
                          ? 'निश्चित गर्नुहोस्'
                          : 'Confirm'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatRangeHeader() {
    if (_rangeStart == null) {
      return widget.language.isNepali
          ? 'सुरु मिति चयन गर्नुहोस्'
          : 'Select start date';
    }
    final startStr =
        '${_rangeStart!.day} ${NepaliMonth.fromIndex(_rangeStart!.month).getShortName(widget.language)} ${_rangeStart!.year}';

    if (_rangeEnd == null) {
      return widget.language.isNepali
          ? '$startStr - अन्त्य मिति छान्नुहोस्'
          : '$startStr - Select end date';
    }
    final endStr =
        '${_rangeEnd!.day} ${NepaliMonth.fromIndex(_rangeEnd!.month).getShortName(widget.language)} ${_rangeEnd!.year}';

    final totalDays = _rangeEnd!.difference(_rangeStart!).inDays + 1;
    final daysStr = widget.language.isNepali
        ? '${NepaliDigits.toNepali(totalDays)} दिन'
        : '$totalDays days';

    return '$startStr – $endStr ($daysStr)';
  }

  Widget _buildRangeGrid(NepaliCalendarThemeData theme) {
    final firstDayWeekday = _currentMonth.weekday; // 1 to 7
    final daysInMonth = _currentMonth.totalDaysInMonth;
    final leadingCells = (firstDayWeekday - 1) % 7;
    final totalCells = ((leadingCells + daysInMonth + 6) ~/ 7) * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalCells,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (context, index) {
        final dayOffset = index - leadingCells;
        if (dayOffset < 0 || dayOffset >= daysInMonth) {
          return const SizedBox.shrink();
        }

        final cellDate =
            NepaliDate(_currentMonth.year, _currentMonth.month, dayOffset + 1);

        final isStart = _rangeStart != null && cellDate == _rangeStart;
        final isEnd = _rangeEnd != null && cellDate == _rangeEnd;
        final isInRange = _rangeStart != null &&
            _rangeEnd != null &&
            cellDate.isAfter(_rangeStart!) &&
            cellDate.isBefore(_rangeEnd!);

        final isDisabled = (widget.selectableDayPredicate != null &&
                !widget.selectableDayPredicate!(cellDate)) ||
            cellDate.isBefore(widget.firstDate) ||
            cellDate.isAfter(widget.lastDate);

        final dayStr = widget.language.isNepali
            ? NepaliDigits.toNepali(cellDate.day)
            : cellDate.day.toString();

        final colorScheme = Theme.of(context).colorScheme;

        Color? bgColor;
        BorderRadius? borderRadius;

        if (isStart && isEnd) {
          bgColor = colorScheme.primary;
          borderRadius = BorderRadius.circular(16);
        } else if (isStart) {
          bgColor = colorScheme.primary;
          borderRadius =
              const BorderRadius.horizontal(left: Radius.circular(16));
        } else if (isEnd) {
          bgColor = colorScheme.primary;
          borderRadius =
              const BorderRadius.horizontal(right: Radius.circular(16));
        } else if (isInRange) {
          bgColor = colorScheme.primaryContainer.withValues(alpha: 0.5);
        }

        Color? textColor;
        if (isDisabled) {
          textColor = theme.disabledColor;
        } else if (isStart || isEnd) {
          textColor = colorScheme.onPrimary;
        } else if (cellDate.isSaturday) {
          textColor = theme.saturdayColor;
        } else {
          textColor = theme.dayTextStyle?.color;
        }

        return InkWell(
          onTap: isDisabled ? null : () => _onDateTapped(cellDate),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: borderRadius,
            ),
            child: Text(
              dayStr,
              style: TextStyle(
                color: textColor,
                fontWeight:
                    isStart || isEnd ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}
