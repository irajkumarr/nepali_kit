// web/nepali_kit_js.dart
import 'dart:js_interop';
import 'package:nepali_kit/nepali_kit_core.dart';

@JS('NepaliKitResult')
extension type NepaliKitResult._(JSObject _) implements JSObject {
  external factory NepaliKitResult({
    int year,
    int month,
    int day,
    String? formatted,
    String? nepaliDigits,
    String? iso,
  });
}

@JSExport()
class NepaliKitApi {
  // AD to BS conversion
  NepaliKitResult adToBs(int year, int month, int day) {
    final adDate = DateTime(year, month, day);
    final bsDate = NepaliDateTime.fromDateTime(adDate);

    return NepaliKitResult(
      year: bsDate.year,
      month: bsDate.month,
      day: bsDate.day,
      formatted: const NepaliDateFormat('yyyy-MM-dd').format(bsDate),
      nepaliDigits: NepaliDigits.toNepali(bsDate.year.toString()),
    );
  }

  // BS to AD conversion
  NepaliKitResult bsToAd(int year, int month, int day) {
    final bsDate = NepaliDateTime(year, month, day);
    final adDate = bsDate.toDateTime();

    return NepaliKitResult(
      year: adDate.year,
      month: adDate.month,
      day: adDate.day,
      iso: adDate.toIso8601String(),
    );
  }

  // Convert English numerals/text to Nepali digits
  String toNepaliDigits(String input) {
    return NepaliDigits.toNepali(input);
  }

  // Convert Nepali numerals/text to English digits
  String toEnglishDigits(String input) {
    return NepaliDigits.toEnglish(input);
  }

  // Unicode Roman to Nepali transliteration
  String romanToNepali(String text) {
    return NepaliUnicode.convert(text);
  }

  // Format Nepali date
  String formatDate(int year, int month, int day,
      [String pattern = 'yyyy-MM-dd']) {
    final bsDate = NepaliDateTime(year, month, day);
    return NepaliDateFormat(pattern).format(bsDate);
  }
}

@JS('NepaliKit')
external set _nepaliKit(JSObject value);

void main() {
  final api = NepaliKitApi();
  _nepaliKit = createJSInteropWrapper(api);
}
