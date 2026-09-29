import 'package:flutter/material.dart';

import '../../calendar/nepali_date_time.dart';
import '../../core/language.dart';
import '../../formatting/nepali_date_format.dart';

/// Style variants for displaying dual BS and AD dates.
enum DualDateDisplayStyle {
  /// Simple inline text: "१३ आश्विन २०८१ (29 Sep 2024)"
  inline,

  /// Stacked vertical text with primary and secondary styling
  stacked,

  /// Card container with subtle border/background
  card,
}

/// A widget that displays synchronized Bikram Sambat and Gregorian AD dates.
class DualDateDisplay extends StatelessWidget {
  /// The Bikram Sambat date.
  final NepaliDateTime nepaliDate;

  /// The Gregorian date. If omitted, it is automatically derived from [nepaliDate].
  final DateTime? gregorianDate;

  /// The display presentation style.
  final DualDateDisplayStyle style;

  /// The primary language for the Nepali date presentation.
  final Language language;

  const DualDateDisplay({
    super.key,
    required this.nepaliDate,
    this.gregorianDate,
    this.style = DualDateDisplayStyle.inline,
    this.language = Language.nepali,
  });

  @override
  Widget build(BuildContext context) {
    final ad = gregorianDate ?? nepaliDate.toDateTime();
    final bsFormatted = NepaliDateFormat.yMMMMd(language).format(nepaliDate);
    final adFormatted = '${ad.day} ${_monthNameAd(ad.month)} ${ad.year}';

    switch (style) {
      case DualDateDisplayStyle.inline:
        return Text('$bsFormatted ($adFormatted)');
      case DualDateDisplayStyle.stacked:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              bsFormatted,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              adFormatted,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        );
      case DualDateDisplayStyle.card:
        return Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_month_outlined, size: 20),
                const SizedBox(width: 8),
                Text(
                  bsFormatted,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 6),
                Text(
                  '• $adFormatted',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  String _monthNameAd(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
