import 'package:flutter/material.dart';

/// Theme configuration for Nepali calendar widgets and date pickers.
///
/// Fully compatible with Material 3, light mode, and dark mode.
@immutable
class NepaliCalendarThemeData {
  /// The primary color used for selection headers and active selection states.
  final Color? primaryColor;

  /// The color used to highlight Saturday dates (standard weekend in Nepal).
  final Color? saturdayColor;

  /// The color used for holiday indicators and badges.
  final Color? holidayColor;

  /// The color used for dates outside selectable bounds or disabled dates.
  final Color? disabledColor;

  /// The color used for dot event indicators under day numbers.
  final Color? eventIndicatorColor;

  /// Text style for calendar month/year headers.
  final TextStyle? headerTextStyle;

  /// Text style for regular day cells.
  final TextStyle? dayTextStyle;

  /// Text style for selected day cells.
  final TextStyle? selectedDayTextStyle;

  /// Text style for disabled day cells.
  final TextStyle? disabledDayTextStyle;

  /// Text style for Saturday day cells.
  final TextStyle? saturdayTextStyle;

  /// Decoration applied to the selected day.
  final BoxDecoration? selectedDayDecoration;

  /// Decoration applied to today's date.
  final BoxDecoration? todayDecoration;

  const NepaliCalendarThemeData({
    this.primaryColor,
    this.saturdayColor,
    this.holidayColor,
    this.disabledColor,
    this.eventIndicatorColor,
    this.headerTextStyle,
    this.dayTextStyle,
    this.selectedDayTextStyle,
    this.disabledDayTextStyle,
    this.saturdayTextStyle,
    this.selectedDayDecoration,
    this.todayDecoration,
  });

  /// Resolves an effective theme taking fallback values from the ambient [BuildContext].
  factory NepaliCalendarThemeData.of(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final primary = colorScheme.primary;
    final saturday = isDark ? Colors.redAccent.shade100 : Colors.red.shade700;
    final holiday =
        isDark ? Colors.deepOrangeAccent.shade100 : Colors.deepOrange.shade600;
    final disabled = colorScheme.onSurface.withValues(alpha: 0.38);

    return NepaliCalendarThemeData(
      primaryColor: primary,
      saturdayColor: saturday,
      holidayColor: holiday,
      disabledColor: disabled,
      eventIndicatorColor: isDark ? colorScheme.tertiary : colorScheme.primary,
      headerTextStyle: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      dayTextStyle: theme.textTheme.bodyMedium,
      selectedDayTextStyle: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
      ),
      disabledDayTextStyle: theme.textTheme.bodyMedium?.copyWith(
        color: disabled,
      ),
      saturdayTextStyle: theme.textTheme.bodyMedium?.copyWith(
        color: saturday,
        fontWeight: FontWeight.w600,
      ),
      selectedDayDecoration: BoxDecoration(
        color: primary,
        shape: BoxShape.circle,
      ),
      todayDecoration: BoxDecoration(
        border: Border.all(color: primary, width: 1.5),
        shape: BoxShape.circle,
      ),
    );
  }

  NepaliCalendarThemeData copyWith({
    Color? primaryColor,
    Color? saturdayColor,
    Color? holidayColor,
    Color? disabledColor,
    Color? eventIndicatorColor,
    TextStyle? headerTextStyle,
    TextStyle? dayTextStyle,
    TextStyle? selectedDayTextStyle,
    TextStyle? disabledDayTextStyle,
    TextStyle? saturdayTextStyle,
    BoxDecoration? selectedDayDecoration,
    BoxDecoration? todayDecoration,
  }) {
    return NepaliCalendarThemeData(
      primaryColor: primaryColor ?? this.primaryColor,
      saturdayColor: saturdayColor ?? this.saturdayColor,
      holidayColor: holidayColor ?? this.holidayColor,
      disabledColor: disabledColor ?? this.disabledColor,
      eventIndicatorColor: eventIndicatorColor ?? this.eventIndicatorColor,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      dayTextStyle: dayTextStyle ?? this.dayTextStyle,
      selectedDayTextStyle: selectedDayTextStyle ?? this.selectedDayTextStyle,
      disabledDayTextStyle: disabledDayTextStyle ?? this.disabledDayTextStyle,
      saturdayTextStyle: saturdayTextStyle ?? this.saturdayTextStyle,
      selectedDayDecoration:
          selectedDayDecoration ?? this.selectedDayDecoration,
      todayDecoration: todayDecoration ?? this.todayDecoration,
    );
  }
}
