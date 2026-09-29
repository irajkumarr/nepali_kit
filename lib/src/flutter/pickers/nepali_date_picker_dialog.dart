import 'package:flutter/material.dart';

import '../../calendar/nepali_date.dart';
import '../../calendar/nepali_date_time.dart';
import '../../calendar/nepali_month.dart';
import '../../conversion/bs_calendar_data.dart';
import '../../core/constants.dart';
import '../../core/language.dart';
import '../../numbers/nepali_digits.dart';
import '../calendar/nepali_calendar_view.dart';
import '../theme/nepali_calendar_theme.dart';

/// Shows a dialog containing a Material 3 Nepali Bikram Sambat date picker.
///
/// Returns the selected [NepaliDate].
Future<NepaliDate?> showNepaliDatePicker({
  required BuildContext context,
  NepaliDate? initialDate,
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
  final init = initialDate ?? NepaliDate.now();

  return showDialog<NepaliDate>(
    context: context,
    builder: (BuildContext dialogContext) {
      return _NepaliDatePickerDialog(
        initialDate: init,
        firstDate: initFirst,
        lastDate: initLast,
        language: language,
        theme: theme,
        selectableDayPredicate: selectableDayPredicate,
      );
    },
  );
}

/// Variant of [showNepaliDatePicker] returning a [NepaliDateTime].
Future<NepaliDateTime?> showNepaliDateTimePicker({
  required BuildContext context,
  NepaliDateTime? initialDate,
  NepaliDate? firstDate,
  NepaliDate? lastDate,
  Language language = Language.nepali,
  NepaliCalendarThemeData? theme,
  bool Function(NepaliDate date)? selectableDayPredicate,
}) async {
  final init = initialDate?.toNepaliDate() ?? NepaliDate.now();
  final picked = await showNepaliDatePicker(
    context: context,
    initialDate: init,
    firstDate: firstDate,
    lastDate: lastDate,
    language: language,
    theme: theme,
    selectableDayPredicate: selectableDayPredicate,
  );
  if (picked == null) return null;
  return picked.toNepaliDateTime();
}

class _NepaliDatePickerDialog extends StatefulWidget {
  final NepaliDate initialDate;
  final NepaliDate firstDate;
  final NepaliDate lastDate;
  final Language language;
  final NepaliCalendarThemeData? theme;
  final bool Function(NepaliDate date)? selectableDayPredicate;

  const _NepaliDatePickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.language,
    this.theme,
    this.selectableDayPredicate,
  });

  @override
  State<_NepaliDatePickerDialog> createState() =>
      _NepaliDatePickerDialogState();
}

class _NepaliDatePickerDialogState extends State<_NepaliDatePickerDialog> {
  late NepaliDate _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthName =
        NepaliMonth.fromIndex(_selectedDate.month).getName(widget.language);
    final dayStr = widget.language.isNepali
        ? NepaliDigits.toNepali(_selectedDate.day)
        : _selectedDate.day.toString();
    final yearStr = widget.language.isNepali
        ? NepaliDigits.toNepali(_selectedDate.year)
        : _selectedDate.year.toString();

    final headerText = '$monthName $dayStr, $yearStr';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Material 3 Date Picker Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.language.isNepali ? 'मिति चयन' : 'Select Date',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  headerText,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Divider(),
                // Calendar View
                NepaliCalendarView(
                  initialDate: _selectedDate,
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate,
                  selectedDate: _selectedDate,
                  language: widget.language,
                  theme: widget.theme,
                  selectableDayPredicate: widget.selectableDayPredicate,
                  onDateSelected: (date) {
                    setState(() => _selectedDate = date);
                  },
                ),
                const SizedBox(height: 12),
                // Action Buttons: Cancel / OK
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        widget.language.isNepali ? 'रद्द गर्नुहोस्' : 'Cancel',
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(_selectedDate),
                      child: Text(
                        widget.language.isNepali ? 'ठीक छ' : 'OK',
                      ),
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
}
