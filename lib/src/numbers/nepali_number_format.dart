import '../core/language.dart';
import 'nepali_digits.dart';

/// Formatter for Nepali numbers supporting South Asian comma grouping (`12,34,567.89`)
/// and currency formatting with symbol (`रु` / `Rs.`).
class NepaliNumberFormat {
  NepaliNumberFormat._();

  /// Formats a number with South Asian grouping (last 3 digits, then every 2 digits).
  ///
  /// Examples:
  /// ```dart
  /// NepaliNumberFormat.format(1234567.89); // "12,34,567.89"
  /// NepaliNumberFormat.format(1234567.89, language: Language.nepali); // "१२,३४,५६७.८९"
  /// ```
  static String format(
    num number, {
    Language language = Language.english,
    int? decimalDigits,
  }) {
    final isNegative = number < 0;
    final absNum = number.abs();

    final String numStr;
    if (decimalDigits != null) {
      numStr = absNum.toStringAsFixed(decimalDigits);
    } else {
      numStr = absNum.toString();
    }

    final parts = numStr.split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? parts[1] : null;

    final formattedInt = _groupSouthAsian(intPart);
    final combined =
        decPart != null && (decimalDigits == null || decimalDigits > 0)
            ? '$formattedInt.$decPart'
            : formattedInt;

    final withSign = isNegative ? '-$combined' : combined;
    return language.isNepali ? NepaliDigits.toNepali(withSign) : withSign;
  }

  /// Formats [amount] as currency with prefix symbol (`रु` for Nepali, `Rs.` for English).
  static String currency(
    num amount, {
    Language language = Language.nepali,
    String? customSymbol,
    int decimalDigits = 2,
  }) {
    final formattedNumber = format(
      amount,
      language: language,
      decimalDigits: decimalDigits,
    );
    final symbol = customSymbol ?? (language.isNepali ? 'रु' : 'Rs.');
    return '$symbol $formattedNumber';
  }

  static String _groupSouthAsian(String intStr) {
    if (intStr.length <= 3) return intStr;
    final last3 = intStr.substring(intStr.length - 3);
    final remaining = intStr.substring(0, intStr.length - 3);

    final buffer = StringBuffer();
    for (int i = 0; i < remaining.length; i++) {
      if (i > 0 && (remaining.length - i) % 2 == 0) {
        buffer.write(',');
      }
      buffer.write(remaining[i]);
    }
    buffer.write(',');
    buffer.write(last3);
    return buffer.toString();
  }
}

/// Converts numbers to Nepali words (e.g. `१२३४` -> `एक हजार दुई सय चौंतीस`).
class NepaliNumberToWords {
  NepaliNumberToWords._();

  static const List<String> _nepaliUnits = [
    'शून्य',
    'एक',
    'दुई',
    'तीन',
    'चार',
    'पाँच',
    'छ',
    'सात',
    'आठ',
    'नौ',
    'दश',
    'एघार',
    'बाह्र',
    'तेह्र',
    'चौध',
    'पन्ध्र',
    'सोह्र',
    'सत्र',
    'अठार',
    'उन्नाइस',
    'बीस',
    'एक्काइस',
    'बाइस',
    'तेइस',
    'चौबीस',
    'पच्चीस',
    'छब्बीस',
    'सत्ताइस',
    'अठ्ठाइस',
    'उनन्तीस',
    'तीस',
    'एकत्तिस',
    'बत्तीस',
    'तेत्तीस',
    'चौंतीस',
    'पैंतीस',
    'छत्तिस',
    'सरसर्तीस',
    'अठतीस',
    'उनन्चालीस',
    'चालीस',
    'एकचालीस',
    'बयालीस',
    'त्रिचालीस',
    'चवालीस',
    'पैंतालीस',
    'छयालीस',
    'सत्चालीस',
    'अठचालीस',
    'उनपचास',
    'पचास',
    'एकाउन्न',
    'बाउन्न',
    'त्रिपन्न',
    'चौवन्न',
    'पचपन्न',
    'छपन्न',
    'सन्ताउन्न',
    'अन्ठाउन्न',
    'उनन्साठी',
    'साठी',
    'एकसट्ठी',
    'बाइसट्ठी',
    'त्रिसट्ठी',
    'चौंसट्ठी',
    'पैंसट्ठी',
    'छैसट्ठी',
    'सत्सट्ठी',
    'अठसट्ठी',
    'उनन्सत्तरी',
    'सत्तरी',
    'एकहत्तर',
    'बहत्तर',
    'त्रिहत्तर',
    'चौहत्तर',
    'पचहत्तर',
    'छयहत्तर',
    'सतहत्तर',
    'अठहत्तर',
    'उनासी',
    'असी',
    'एकासी',
    'बयासी',
    'त्रियासी',
    'चौरासी',
    'पचासी',
    'छयासी',
    'सतासी',
    'अठासी',
    'उनान्नब्बे',
    'नब्बे',
    'एकान्नब्बे',
    'बयानब्बे',
    'त्रियान्नब्बे',
    'चौरान्नब्बे',
    'पन्चानब्बे',
    'छयान्नब्बे',
    'सन्तान्नब्बे',
    'अन्ठान्नब्बे',
    'उनान्सय',
  ];

  /// Converts [number] into Nepali words.
  ///
  /// Supports integers up to Arab / Kharba (`10^11+`), negative numbers, and decimals.
  static String convert(
    num number, {
    Language language = Language.nepali,
  }) {
    if (number == 0) return language.isNepali ? 'शून्य' : 'Zero';
    final isNegative = number < 0;
    final absNum = number.abs();

    final parts = absNum.toString().split('.');
    final intPart = int.parse(parts[0]);
    final decPart = parts.length > 1 ? parts[1] : null;

    final wordsBuffer = StringBuffer();
    if (isNegative) {
      wordsBuffer.write(language.isNepali ? 'ऋण ' : 'Minus ');
    }

    if (language.isNepali) {
      wordsBuffer.write(_convertNepaliInteger(intPart));
      if (decPart != null && int.parse(decPart) > 0) {
        wordsBuffer.write(' दशमलव ');
        for (int i = 0; i < decPart.length; i++) {
          final digit = int.parse(decPart[i]);
          wordsBuffer.write('${_nepaliUnits[digit]} ');
        }
      }
    } else {
      wordsBuffer.write(_convertEnglishInteger(intPart));
      if (decPart != null && int.parse(decPart) > 0) {
        wordsBuffer.write(' Point ');
        for (int i = 0; i < decPart.length; i++) {
          final digit = int.parse(decPart[i]);
          wordsBuffer.write('${_englishDigit(digit)} ');
        }
      }
    }

    return wordsBuffer.toString().trim();
  }

  static String _convertNepaliInteger(int n) {
    if (n == 0) return 'शून्य';
    final chunks = <String>[];

    final kharba = n ~/ 100000000000;
    n %= 100000000000;
    if (kharba > 0) chunks.add('${_nepaliUnits[kharba]} खर्ब');

    final arab = n ~/ 1000000000;
    n %= 1000000000;
    if (arab > 0) chunks.add('${_nepaliUnits[arab]} अरब');

    final crore = n ~/ 10000000;
    n %= 10000000;
    if (crore > 0) chunks.add('${_nepaliUnits[crore]} करोड');

    final lakh = n ~/ 100000;
    n %= 100000;
    if (lakh > 0) chunks.add('${_nepaliUnits[lakh]} लाख');

    final thousand = n ~/ 1000;
    n %= 1000;
    if (thousand > 0) chunks.add('${_nepaliUnits[thousand]} हजार');

    final hundred = n ~/ 100;
    n %= 100;
    if (hundred > 0) chunks.add('${_nepaliUnits[hundred]} सय');

    if (n > 0) {
      chunks.add(_nepaliUnits[n]);
    }

    return chunks.join(' ');
  }

  static String _convertEnglishInteger(int n) {
    if (n == 0) return 'Zero';
    final chunks = <String>[];

    final arab = n ~/ 1000000000;
    n %= 1000000000;
    if (arab > 0) chunks.add('${_englishUnder100(arab)} Billion');

    final crore = n ~/ 10000000;
    n %= 10000000;
    if (crore > 0) chunks.add('${_englishUnder100(crore)} Crore');

    final lakh = n ~/ 100000;
    n %= 100000;
    if (lakh > 0) chunks.add('${_englishUnder100(lakh)} Lakh');

    final thousand = n ~/ 1000;
    n %= 1000;
    if (thousand > 0) chunks.add('${_englishUnder100(thousand)} Thousand');

    final hundred = n ~/ 100;
    n %= 100;
    if (hundred > 0) chunks.add('${_englishUnder100(hundred)} Hundred');

    if (n > 0) {
      chunks.add(_englishUnder100(n));
    }

    return chunks.join(' ');
  }

  static String _englishUnder100(int n) {
    const ones = [
      '',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen'
    ];
    const tens = [
      '',
      '',
      'Twenty',
      'Thirty',
      'Forty',
      'Fifty',
      'Sixty',
      'Seventy',
      'Eighty',
      'Ninety'
    ];
    if (n < 20) return ones[n];
    final t = n ~/ 10;
    final o = n % 10;
    return o > 0 ? '${tens[t]} ${ones[o]}' : tens[t];
  }

  static String _englishDigit(int d) {
    const names = [
      'Zero',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine'
    ];
    return names[d];
  }
}
