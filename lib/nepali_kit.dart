/// Unified library entry point for nepali_kit.
///
/// Re-exports the complete pure Dart core utilities plus Flutter widgets,
/// Material 3 pickers, and calendar UI components.
library nepali_kit;

// Re-export all pure Dart functionality
export 'nepali_kit_core.dart';

// Flutter UI components & widgets
export 'src/flutter/calendar/ad_calendar_view.dart';
export 'src/flutter/calendar/nepali_calendar_view.dart';
export 'src/flutter/dual_date/dual_date_display.dart';
export 'src/flutter/pickers/nepali_date_picker_dialog.dart';
export 'src/flutter/pickers/nepali_date_range_picker.dart';
export 'src/flutter/pickers/nepali_month_picker.dart';
export 'src/flutter/pickers/nepali_year_picker.dart';
export 'src/flutter/theme/nepali_calendar_theme.dart';
