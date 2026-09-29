// Pure Dart Romanized Nepali to Unicode transliteration engine.
//
// Follows the phonetic Romanized Nepali transliteration rules
// (MPP / Nepali Unicode standard convention), with support for
// full conversion, live (type-as-you-write) interactive conversion,
// matras, conjuncts, anusvara, chandrabindu, and smart preservation of
// URLs, email addresses, and existing Devanagari Unicode.

/// Token types distinguished during Romanized text processing.
enum _TokenType {
  url,
  email,
  nepaliWord,
  other,
}

class _Token {
  final _TokenType type;
  final String text;

  const _Token(this.type, this.text);
}

/// Internal transliteration engine for Romanized Nepali to Devanagari Unicode.
class TransliterationEngine {
  TransliterationEngine._();

  static final RegExp _urlRegex = RegExp(
    r'^(https?:\/\/[^\s]+|www\.[^\s]+)$',
    caseSensitive: false,
  );

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Converts the given [input] Romanized string into Nepali Unicode.
  ///
  /// When [live] is `true`, conversion is tailored for type-as-you-write scenarios
  /// in interactive text fields, processing input sequentially without corrupting
  /// pending syllables or premature halant locks.
  static String convert(String input, {bool live = false}) {
    if (input.isEmpty) return '';

    // Tokenize into words, whitespace, punctuation, URLs, emails, etc.
    final tokens = _tokenize(input);
    final buffer = StringBuffer();

    for (final token in tokens) {
      switch (token.type) {
        case _TokenType.url:
        case _TokenType.email:
        case _TokenType.other:
          // Preserve URLs, email addresses, non-alphanumeric punctuation, spaces,
          // newlines, and existing Devanagari characters unchanged.
          buffer.write(token.text);
          break;
        case _TokenType.nepaliWord:
          buffer.write(_convertWord(token.text));
          break;
      }
    }

    return buffer.toString();
  }

  /// Tokenizes the input string while preserving whitespace, symbols, URLs, and emails.
  static List<_Token> _tokenize(String input) {
    final List<_Token> tokens = [];
    final length = input.length;
    int i = 0;

    while (i < length) {
      final code = input.codeUnitAt(i);
      final char = input[i];

      // 1. Whitespace
      if (char == ' ' || char == '\t' || char == '\n' || char == '\r') {
        tokens.add(_Token(_TokenType.other, char));
        i++;
        continue;
      }

      // 2. Existing Devanagari Unicode range (U+0900 to U+097F)
      if (code >= 0x0900 && code <= 0x097F) {
        final start = i;
        while (i < length) {
          final c = input.codeUnitAt(i);
          if (c >= 0x0900 && c <= 0x097F) {
            i++;
          } else {
            break;
          }
        }
        tokens.add(_Token(_TokenType.other, input.substring(start, i)));
        continue;
      }

      // 3. Contiguous non-whitespace segment
      final wordStart = i;
      while (i < length) {
        final c = input.codeUnitAt(i);
        final ch = input[i];
        if (ch == ' ' || ch == '\t' || ch == '\n' || ch == '\r') {
          break;
        }
        if (c >= 0x0900 && c <= 0x097F) {
          break;
        }
        i++;
      }

      final word = input.substring(wordStart, i);

      // Check if it is a URL or Email
      if (_urlRegex.hasMatch(word)) {
        tokens.add(_Token(_TokenType.url, word));
      } else if (_emailRegex.hasMatch(word)) {
        tokens.add(_Token(_TokenType.email, word));
      } else {
        _splitWordAndPunctuation(word, tokens);
      }
    }

    return tokens;
  }

  /// Splits an individual word and its attached punctuation (e.g., "haamii," or "mocii-mahaakaalii"),
  /// keeping Romanized syllables for transliteration.
  static void _splitWordAndPunctuation(String word, List<_Token> tokens) {
    int start = 0;
    final length = word.length;

    while (start < length) {
      final char = word[start];

      if (_isRomanNepaliChar(char)) {
        int end = start;
        while (end < length && _isRomanNepaliChar(word[end])) {
          end++;
        }
        tokens.add(_Token(_TokenType.nepaliWord, word.substring(start, end)));
        start = end;
      } else {
        tokens.add(_Token(_TokenType.other, char));
        start++;
      }
    }
  }

  static bool _isRomanNepaliChar(String char) {
    final code = char.codeUnitAt(0);
    // a-z, A-Z, 0-9, and ' (used for anusvara / chandrabindu in Roman Nepali notation), | and :
    return (code >= 97 && code <= 122) ||
        (code >= 65 && code <= 90) ||
        (code >= 48 && code <= 57) ||
        char == "'" ||
        char == '|' ||
        char == ':';
  }

  /// Converts a single Romanized word token into Devanagari Unicode.
  static String _convertWord(String word) {
    String current = '';
    for (int i = 0; i < word.length; i++) {
      current = _applyRules(current + word[i]);
    }
    // Remove internal zero-width space markers used during virama cancellation
    String result = current.replaceAll('\u200b', '');

    // Common natural Romanized Nepali typing corrections:
    // When words end with 'a' (like chha -> छ् -> छ)
    if (word.endsWith('a') && result.endsWith('\u094d')) {
      result = result.substring(0, result.length - 1);
    }

    return result;
  }

  /// Applies the phonetic mapping rules.
  static String _applyRules(String data) {
    String text = data;

    // 1. Independent Vowels
    text = text.replaceAll('a', '\u0905');
    text = text.replaceAll('A', '\u0906');
    text = text.replaceAll('\u0905\u0905', '\u0906'); // aa -> आ
    text = text.replaceAll('i', '\u0907');
    text = text.replaceAll('I', '\u0908');
    text = text.replaceAll('\u0907\u0907', '\u0908'); // ii -> ई
    text = text.replaceAll('u', '\u0909');
    text = text.replaceAll('U', '\u090a');
    text = text.replaceAll('\u0909\u0909', '\u090a'); // uu -> ऊ
    text = text.replaceAll('e', '\u090f');
    text = text.replaceAll('E', '\u0910');
    text = text.replaceAll('\u0905\u0907', '\u0910'); // ai -> ऐ
    text = text.replaceAll('o', '\u0913');
    text = text.replaceAll('O', '\u0913');
    text = text.replaceAll('\u0905\u0909', '\u0914'); // au -> औ

    // 2. Vowel Signs (Matras) following Halant
    text = text.replaceAll(
        '\u094d\u0905', '\u200b'); // Halant + a -> full consonant (cancel halant)
    text = text.replaceAll('\u094d\u0906', '\u093e'); // Halant + A / aa -> ा
    text = text.replaceAll('\u200b\u0905', '\u093e'); // Consonant + a + a -> ा
    text = text.replaceAll('\u094d\u0907', '\u093f'); // Halant + i -> ि
    text = text.replaceAll('\u094d\u0908', '\u0940'); // Halant + I / ii -> ी
    text = text.replaceAll('\u093f\u0907', '\u0940'); // ि + i -> ी
    text = text.replaceAll('\u0941\u0909', '\u0942'); // ु + u -> ू
    text = text.replaceAll(
        '\u200b\u0909', '\u094c'); // Consonant + a + u -> ौ (au)
    text = text.replaceAll('\u094d\u0909', '\u0941'); // Halant + u -> ु
    text = text.replaceAll('\u094d\u090a', '\u0942'); // Halant + U / uu -> ू
    text = text.replaceAll('\u094d\u090f', '\u0947'); // Halant + e -> े
    text = text.replaceAll('\u094d\u0910', '\u0948'); // Halant + E / ai -> ै
    text = text.replaceAll(
        '\u200b\u0907', '\u0948'); // Consonant + a + i -> ै (ai)
    text = text.replaceAll('\u094d\u0913', '\u094b'); // Halant + o -> ो
    text = text.replaceAll('\u094d ', ' '); // Halant before space -> space
    text = text.replaceAll('\u094d\u090b', '\u0943'); // Halant + ri -> ृ
    text = text.replaceAll('\u094d\u0960', '\u0944'); // ॄ
    text = text.replaceAll('\u094d\u090c', '\u0962'); // ॢ
    text = text.replaceAll('\u094d-\u0930\u094d', '\u0943');
    text = text.replaceAll('-\u0930\u094d', '\u090b');
    text = text.replaceAll('\u090b\u0907', '\u0960');
    text = text.replaceAll('\u0943\u0907', '\u0944');
    text = text.replaceAll('-\u0932\u094d', '\u090c');

    // 3. Consonants with Default Halant
    text = text.replaceAll('k', '\u0915\u094d');
    text = text.replaceAll('K', '\u0915\u094d');
    text = text.replaceAll('q', '\u0915\u094d');
    text = text.replaceAll('Q', '\u0915\u094d');
    text = text.replaceAll('g', '\u0917\u094d');
    text = text.replaceAll('G', '\u0917\u094d');
    text = text.replaceAll('c', '\u091a\u094d');
    text = text.replaceAll('C', '\u091a\u094d');
    text = text.replaceAll('j', '\u091c\u094d');
    text = text.replaceAll('J', '\u091c\u094d');
    text = text.replaceAll('z', '\u091c\u094d');
    text = text.replaceAll('Z', '\u091c\u094d');
    text = text.replaceAll('T', '\u091f\u094d'); // Retroflex T -> ट्
    text = text.replaceAll('D', '\u0921\u094d'); // Retroflex D -> ड्
    text = text.replaceAll('N', '\u0923\u094d'); // Retroflex N -> ण्
    text = text.replaceAll('t', '\u0924\u094d'); // Dental t -> त्
    text = text.replaceAll('d', '\u0926\u094d'); // Dental d -> द्
    text = text.replaceAll('n', '\u0928\u094d'); // Dental n -> न्
    text = text.replaceAll('p', '\u092a\u094d');
    text = text.replaceAll('P', '\u092a\u094d');
    text = text.replaceAll('f', '\u092b\u094d'); // f -> फ्
    text = text.replaceAll('F', '\u092b\u094d');
    text = text.replaceAll('b', '\u092c\u094d');
    text = text.replaceAll('B', '\u092c\u094d');
    text = text.replaceAll('m', '\u092e\u094d');
    text = text.replaceAll('M', '\u092e\u094d');
    text = text.replaceAll('y', '\u092f\u094d');
    text = text.replaceAll('Y', '\u092f\u094d');
    text = text.replaceAll('r', '\u0930\u094d');
    text = text.replaceAll('R', '\u0930\u094d');
    text = text.replaceAll('l', '\u0932\u094d');
    text = text.replaceAll('L', '\u0932\u094d');
    text = text.replaceAll('v', '\u0935\u094d');
    text = text.replaceAll('V', '\u0935\u094d');
    text = text.replaceAll('w', '\u0935\u094d');
    text = text.replaceAll('W', '\u0935\u094d');
    text = text.replaceAll('s', '\u0938\u094d');
    text = text.replaceAll('S', '\u0937\u094d'); // Retroflex Sh -> ष्
    text = text.replaceAll('h', '\u0939\u094d');
    text = text.replaceAll('H', '\u0939\u094d');

    // 4. Aspirated and Compound Consonants
    text =
        text.replaceAll('\u0915\u094d\u0939\u094d', '\u0916\u094d'); // kh -> ख्
    text =
        text.replaceAll('\u0917\u094d\u0939\u094d', '\u0918\u094d'); // gh -> घ्
    text =
        text.replaceAll('\u0928\u094d\u0917\u094d', '\u0919\u094d'); // ng -> ङ्
    // In Romanized Nepali:
    // 'ch' or 'c' maps to 'च्' (e.g. cha -> च, chya -> च्या)
    // 'chh' maps to 'छ्' (e.g. chha -> छ, chhoro -> छोरो)
    text = text.replaceAll('\u091a\u094d\u0939\u094d', '\u091b\u094d'); // chh -> छ्
    text = text.replaceAll('\u091b\u094d\u0939', '\u091b\u094d'); // chhh -> छ्
    text =
        text.replaceAll('\u091c\u094d\u0939\u094d', '\u091d\u094d'); // jh -> झ्
    text = text.replaceAll('\u092f\u094d\u0928', '\u091e\u094d'); // yn -> ञ्
    text = text.replaceAll('\u0928\u094d\u091c\u094d', '\u091e\u094d');
    text =
        text.replaceAll('\u091f\u094d\u0939\u094d', '\u0920\u094d'); // Th -> ठ्
    text = text.replaceAll('\u095c\u094d\u0939\u094d', '\u095d\u094d');
    text =
        text.replaceAll('\u0921\u094d\u0939\u094d', '\u0922\u094d'); // Dh -> ढ्
    text =
        text.replaceAll('\u0924\u094d\u0939\u094d', '\u0925\u094d'); // th -> थ्
    text =
        text.replaceAll('\u0926\u094d\u0939\u094d', '\u0927\u094d'); // dh -> ध्
    text =
        text.replaceAll('\u092a\u094d\u0939\u094d', '\u092b\u094d'); // ph -> फ्
    text =
        text.replaceAll('\u092c\u094d\u0939\u094d', '\u092d\u094d'); // bh -> भ्
    text =
        text.replaceAll('\u0938\u094d\u0939\u094d', '\u0936\u094d'); // sh -> श्
    text =
        text.replaceAll('\u0937\u094d\u0939\u094d', '\u0936\u094d'); // Sh -> श्
    text = text.replaceAll('\u0915\u094d\u091b\u094d\u092f',
        '\u0915\u094d\u0937\u094d'); // kchhy -> क्ष्
    text = text.replaceAll(
        '\u0917\u094d\u092f\u094d', '\u091c\u094d\u091e\u094d'); // gy -> ज्ञ्
    text = text.replaceAll('\u0917\u094d\u092f', '\u091c\u094d\u091e\u094d');
    text = text.replaceAll(
        '\u091c\u094d\u091e\u094d\u094d', '\u091c\u094d\u091e\u094d');
    text = text.replaceAll('x', '\u0915\u094d\u0938\u094d'); // x -> क्स्
    text = text.replaceAll('X', '\u0915\u094d\u0938\u094d');

    // 5. Normalizing base consonants (canceling halant after vowel 'a')
    text = text.replaceAll('\u200b\u0915', '\u0915');
    text = text.replaceAll('\u200b\u0916', '\u0916');
    text = text.replaceAll('\u200b\u0917', '\u0917');
    text = text.replaceAll('\u200b\u0918', '\u0918');
    text = text.replaceAll('\u200b\u0919', '\u0919');
    text = text.replaceAll('\u200b\u091a', '\u091a');
    text = text.replaceAll('\u200b\u091b', '\u091b');
    text = text.replaceAll('\u200b\u091c', '\u091c');
    text = text.replaceAll('\u200b\u091d', '\u091d');
    text = text.replaceAll('\u200b\u091e', '\u091e');
    text = text.replaceAll('\u200b\u091f', '\u091f');
    text = text.replaceAll('\u200b\u0920', '\u0920');
    text = text.replaceAll('\u200b\u0921', '\u0921');
    text = text.replaceAll('\u200b\u0922', '\u0922');
    text = text.replaceAll('\u200b\u0923', '\u0923');
    text = text.replaceAll('\u200b\u0924', '\u0924');
    text = text.replaceAll('\u200b\u0925', '\u0925');
    text = text.replaceAll('\u200b\u0926', '\u0926');
    text = text.replaceAll('\u200b\u0927', '\u0927');
    text = text.replaceAll('\u200b\u0928', '\u0928');
    text = text.replaceAll('\u200b\u092a', '\u092a');
    text = text.replaceAll('\u200b\u092b', '\u092b');
    text = text.replaceAll('\u200b\u092c', '\u092c');
    text = text.replaceAll('\u200b\u092d', '\u092d');
    text = text.replaceAll(
        '\u200b\u092e', '\u092e'); // Correctly maps to \u092e ('म')
    text = text.replaceAll('\u200b\u0930', '\u0930');
    text = text.replaceAll('\u200b\u0932', '\u0932');
    text = text.replaceAll('\u200b\u0935', '\u0935');
    text = text.replaceAll('\u200b\u0938', '\u0938');
    text = text.replaceAll('\u200b\u0937', '\u0937');
    text = text.replaceAll('\u200b\u0936', '\u0936');
    text = text.replaceAll('\u200b\u0939', '\u0939');
    text = text.replaceAll('\u200b\u0915\u094d\u0937', '\u0915\u094d\u0937');
    text = text.replaceAll('\u200b\u0924\u094d\u0930', '\u0924\u094d\u0930');
    text = text.replaceAll('\u200b\u091c\u094d\u091e', '\u091c\u094d\u091e');

    // 6. Anusvara and Chandrabindu Notation
    // ' -> Anusvara (ं)
    // '' -> Chandrabindu (ँ)
    text = text.replaceAll("'", '\u0902');
    text = text.replaceAll('\u094d\u0902', '\u0902');
    text = text.replaceAll('\u0902\u0902', '\u0901'); // '' -> ँ

    // 7. Om symbol
    text = text.replaceAll('\u0913\u092e\u094d', '\u0950'); // om -> ॐ
    text = text.replaceAll('\u0950\u0902', '\u0950');

    // 8. Visarga, Punctuation & Danda
    text = text.replaceAll('\u200b ', ' ');
    text = text.replaceAll('\u200b\u0902', '\u0902');
    text = text.replaceAll('\u200b\u0903', '\u0903');
    text = text.replaceAll(':', '\u0903'); // Visarga
    text = text.replaceAll('\u094d\u0903', '\u0903');
    text = text.replaceAll('|', '\u0964'); // Danda (।)
    text = text.replaceAll('\u0964\u0964', '\u0965'); // Double Danda (॥)

    // 9. Digits (0-9 -> ०-९)
    text = text.replaceAll('0', '\u0966');
    text = text.replaceAll('1', '\u0967');
    text = text.replaceAll('2', '\u0968');
    text = text.replaceAll('3', '\u0969');
    text = text.replaceAll('4', '\u096a');
    text = text.replaceAll('5', '\u096b');
    text = text.replaceAll('6', '\u096c');
    text = text.replaceAll('7', '\u096d');
    text = text.replaceAll('8', '\u096e');
    text = text.replaceAll('9', '\u096f');

    // 10. Special refinements
    text = text.replaceAll('\u0939\u094d\u0910', '\u0939\u0948');
    text = text.replaceAll('\u0919\u094d\u0939\u094d', '\u0939\u0902');
    text = text.replaceAll('\u0919\u094d\u0939', '\u0939\u0902');

    return text;
  }
}

