import 'package:flutter/material.dart';

import '../../calendar/nepali_month.dart';
import '../../core/language.dart';

/// A standalone, reusable Bikram Sambat month selector widget (12 months from Baisakh to Chaitra).
class NepaliMonthPicker extends StatelessWidget {
  /// The currently selected month number (1 to 12).
  final int selectedMonth;

  /// Callback when a month is selected.
  final ValueChanged<int> onMonthSelected;

  /// Language for month names (Devanagari or English).
  final Language language;

  const NepaliMonthPicker({
    super.key,
    required this.selectedMonth,
    required this.onMonthSelected,
    this.language = Language.nepali,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: language.isNepali ? 'महिना चयन' : 'Month Picker',
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final monthNum = index + 1;
          final month = NepaliMonth.fromIndex(monthNum);
          final isSelected = monthNum == selectedMonth;

          return InkWell(
            onTap: () => onMonthSelected(monthNum),
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
                month.getName(language),
                style: TextStyle(
                  fontSize: 13,
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
