import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/language.dart';
import '../../numbers/nepali_digits.dart';

/// A standalone, reusable Bikram Sambat year selector widget.
class NepaliYearPicker extends StatelessWidget {
  /// The currently selected year.
  final int selectedYear;

  /// Earliest selectable year.
  final int firstYear;

  /// Latest selectable year.
  final int lastYear;

  /// Callback when a year is selected.
  final ValueChanged<int> onYearSelected;

  /// Language for digits (Devanagari or English).
  final Language language;

  const NepaliYearPicker({
    super.key,
    required this.selectedYear,
    this.firstYear = NepaliCalendarConstants.minBsYear,
    this.lastYear = NepaliCalendarConstants.maxBsYear,
    required this.onYearSelected,
    this.language = Language.nepali,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final yearsCount = lastYear - firstYear + 1;

    return Semantics(
      label: language.isNepali ? 'वर्ष चयन' : 'Year Picker',
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: yearsCount,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.0,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final year = firstYear + index;
          final isSelected = year == selectedYear;
          final yearLabel =
              language.isNepali ? NepaliDigits.toNepali(year) : year.toString();

          return InkWell(
            onTap: () => onYearSelected(year),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? theme.colorScheme.primary : null,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? null
                    : Border.all(
                        color: theme.colorScheme.outlineVariant,
                        width: 1,
                      ),
              ),
              child: Text(
                yearLabel,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
