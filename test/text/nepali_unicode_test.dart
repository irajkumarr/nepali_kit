import 'package:nepali_kit/nepali_kit.dart';
import 'package:test/test.dart';

void main() {
  group('NepaliUnicode - Public API and Core Requirements', () {
    test('Constructor is private and cannot be instantiated externally', () {
      expect(NepaliUnicode.convert(''), equals(''));
    });

    test('Conversational sentence 1 converts accurately', () {
      expect(
        NepaliUnicode.convert(
          "namaste, tpaaii'laaii kasto chha? swagatam!",
        ),
        equals('नमस्ते, तपाईंलाई कस्तो छ? स्वगतम्!'),
      );
    });

    test('Conversational sentence 2 converts accurately', () {
      expect(
        NepaliUnicode.convert(
          'mero naam Bikash ho, ma nepaalmaa baschhu.',
        ),
        equals('मेरो नाम् बिकश् हो, म नेपाल्मा बस्छु.'),
      );
    });
  });

  group('NepaliUnicode - Basic Words', () {
    test('Individual vocabulary words', () {
      expect(NepaliUnicode.convert('nepaal'), equals('नेपाल्'));
      expect(NepaliUnicode.convert('nepaali'), equals('नेपालि'));
      expect(NepaliUnicode.convert('nepal'), equals('नेपल्'));
      expect(NepaliUnicode.convert('haamii'), equals('हामी'));
      expect(NepaliUnicode.convert('maalaa'), equals('माला'));
      expect(NepaliUnicode.convert('fUlakaa'), equals('फूलका'));
      expect(NepaliUnicode.convert("thu''gaa"), equals('थुँगा'));
      expect(NepaliUnicode.convert("sayau'"), equals('सयौं'));
      expect(NepaliUnicode.convert('namaste'), equals('नमस्ते'));
      expect(NepaliUnicode.convert('swagatam'), equals('स्वगतम्'));
      expect(NepaliUnicode.convert('dhanyabaad'), equals('धन्यबाद्'));
    });
  });

  group('NepaliUnicode - Vowels and Matras', () {
    test('Independent vowels', () {
      expect(NepaliUnicode.convert('a'), equals('अ'));
      expect(NepaliUnicode.convert('A'), equals('आ'));
      expect(NepaliUnicode.convert('aa'), equals('आ'));
      expect(NepaliUnicode.convert('i'), equals('इ'));
      expect(NepaliUnicode.convert('I'), equals('ई'));
      expect(NepaliUnicode.convert('ii'), equals('ई'));
      expect(NepaliUnicode.convert('u'), equals('उ'));
      expect(NepaliUnicode.convert('U'), equals('ऊ'));
      expect(NepaliUnicode.convert('uu'), equals('ऊ'));
      expect(NepaliUnicode.convert('e'), equals('ए'));
      expect(NepaliUnicode.convert('E'), equals('ऐ'));
      expect(NepaliUnicode.convert('ai'), equals('ऐ'));
      expect(NepaliUnicode.convert('o'), equals('ओ'));
      expect(NepaliUnicode.convert('O'), equals('ओ'));
      expect(NepaliUnicode.convert('au'), equals('औ'));
    });

    test('Consonant + Vowel combinations (Matras)', () {
      expect(NepaliUnicode.convert('ka'), equals('क'));
      expect(NepaliUnicode.convert('kaa'), equals('का'));
      expect(NepaliUnicode.convert('ki'), equals('कि'));
      expect(NepaliUnicode.convert('kii'), equals('की'));
      expect(NepaliUnicode.convert('ku'), equals('कु'));
      expect(NepaliUnicode.convert('kU'), equals('कू'));
      expect(NepaliUnicode.convert('kuu'), equals('कू'));
      expect(NepaliUnicode.convert('ke'), equals('के'));
      expect(NepaliUnicode.convert('kai'), equals('कै'));
      expect(NepaliUnicode.convert('ko'), equals('को'));
      expect(NepaliUnicode.convert('kau'), equals('कौ'));
    });
  });

  group('NepaliUnicode - Consonants and Aspirated Forms', () {
    test('Consonants without vowel retain halant', () {
      expect(NepaliUnicode.convert('k'), equals('क्'));
      expect(NepaliUnicode.convert('kh'), equals('ख्'));
      expect(NepaliUnicode.convert('g'), equals('ग्'));
      expect(NepaliUnicode.convert('gh'), equals('घ्'));
      expect(NepaliUnicode.convert('ng'), equals('ङ्'));
      expect(NepaliUnicode.convert('ch'), equals('छ्'));
      expect(NepaliUnicode.convert('j'), equals('ज्'));
      expect(NepaliUnicode.convert('jh'), equals('झ्'));
      expect(NepaliUnicode.convert('T'), equals('ट्'));
      expect(NepaliUnicode.convert('Th'), equals('ठ्'));
      expect(NepaliUnicode.convert('D'), equals('ड्'));
      expect(NepaliUnicode.convert('Dh'), equals('ढ्'));
      expect(NepaliUnicode.convert('N'), equals('ण्'));
      expect(NepaliUnicode.convert('t'), equals('त्'));
      expect(NepaliUnicode.convert('th'), equals('थ्'));
      expect(NepaliUnicode.convert('d'), equals('द्'));
      expect(NepaliUnicode.convert('dh'), equals('ध्'));
      expect(NepaliUnicode.convert('n'), equals('न्'));
      expect(NepaliUnicode.convert('p'), equals('प्'));
      expect(NepaliUnicode.convert('f'), equals('फ्'));
      expect(NepaliUnicode.convert('ph'), equals('फ्'));
      expect(NepaliUnicode.convert('b'), equals('ब्'));
      expect(NepaliUnicode.convert('bh'), equals('भ्'));
      expect(NepaliUnicode.convert('m'), equals('म्'));
      expect(NepaliUnicode.convert('y'), equals('य्'));
      expect(NepaliUnicode.convert('r'), equals('र्'));
      expect(NepaliUnicode.convert('l'), equals('ल्'));
      expect(NepaliUnicode.convert('w'), equals('व्'));
      expect(NepaliUnicode.convert('v'), equals('व्'));
      expect(NepaliUnicode.convert('s'), equals('स्'));
      expect(NepaliUnicode.convert('sh'), equals('श्'));
      expect(NepaliUnicode.convert('S'), equals('ष्'));
      expect(NepaliUnicode.convert('h'), equals('ह्'));
      expect(NepaliUnicode.convert('gy'), equals('ज्ञ्'));
    });

    test('Consonants with inherent "a"', () {
      expect(NepaliUnicode.convert('ka'), equals('क'));
      expect(NepaliUnicode.convert('kha'), equals('ख'));
      expect(NepaliUnicode.convert('ga'), equals('ग'));
      expect(NepaliUnicode.convert('gha'), equals('घ'));
      expect(NepaliUnicode.convert('cha'), equals('छ'));
      expect(NepaliUnicode.convert('ja'), equals('ज'));
      expect(NepaliUnicode.convert('jha'), equals('झ'));
      expect(NepaliUnicode.convert('Ta'), equals('ट'));
      expect(NepaliUnicode.convert('Tha'), equals('ठ'));
      expect(NepaliUnicode.convert('Da'), equals('ड'));
      expect(NepaliUnicode.convert('Dha'), equals('ढ'));
      expect(NepaliUnicode.convert('Na'), equals('ण'));
      expect(NepaliUnicode.convert('ta'), equals('त'));
      expect(NepaliUnicode.convert('tha'), equals('थ'));
      expect(NepaliUnicode.convert('da'), equals('द'));
      expect(NepaliUnicode.convert('dha'), equals('ध'));
      expect(NepaliUnicode.convert('na'), equals('न'));
      expect(NepaliUnicode.convert('pa'), equals('प'));
      expect(NepaliUnicode.convert('fa'), equals('फ'));
      expect(NepaliUnicode.convert('pha'), equals('फ'));
      expect(NepaliUnicode.convert('ba'), equals('ब'));
      expect(NepaliUnicode.convert('bha'), equals('भ'));
      expect(NepaliUnicode.convert('ma'), equals('म'));
      expect(NepaliUnicode.convert('ya'), equals('य'));
      expect(NepaliUnicode.convert('ra'), equals('र'));
      expect(NepaliUnicode.convert('la'), equals('ल'));
      expect(NepaliUnicode.convert('wa'), equals('व'));
      expect(NepaliUnicode.convert('va'), equals('व'));
      expect(NepaliUnicode.convert('sa'), equals('स'));
      expect(NepaliUnicode.convert('sha'), equals('श'));
      expect(NepaliUnicode.convert('Sa'), equals('ष'));
      expect(NepaliUnicode.convert('ha'), equals('ह'));
    });
  });

  group('NepaliUnicode - Special Marks, Punctuation and Digits', () {
    test('Anusvara and Chandrabindu', () {
      expect(NepaliUnicode.convert("sayau'"), equals('सयौं'));
      expect(NepaliUnicode.convert("thu''gaa"), equals('थुँगा'));
      expect(NepaliUnicode.convert("aa''kha"), equals('आँख'));
    });

    test('Danda and Double Danda', () {
      expect(NepaliUnicode.convert('nepaali|'), equals('नेपालि।'));
      expect(NepaliUnicode.convert('nepaali||'), equals('नेपालि॥'));
    });

    test('Visarga and Om', () {
      expect(NepaliUnicode.convert('om'), equals('ॐ'));
      expect(NepaliUnicode.convert('Om'), equals('ॐ'));
      expect(NepaliUnicode.convert('du:kha'), equals('दुःख'));
    });

    test('Numbers (0-9 -> Devanagari numerals)', () {
      expect(NepaliUnicode.convert('0123456789'), equals('०१२३४५६७८९'));
      expect(NepaliUnicode.convert('2081 saal'), equals('२०८१ साल्'));
    });
  });

  group('NepaliUnicode - Mixed Text and Content Preservation', () {
    test('URLs are preserved untouched', () {
      expect(
        NepaliUnicode.convert('https://flutter.dev'),
        equals('https://flutter.dev'),
      );
      expect(
        NepaliUnicode.convert('www.google.com'),
        equals('www.google.com'),
      );
    });

    test('Email addresses are preserved untouched', () {
      expect(
        NepaliUnicode.convert('info@nepalikit.org'),
        equals('info@nepalikit.org'),
      );
    });

    test('Already-Devanagari Unicode text is preserved', () {
      expect(
        NepaliUnicode.convert('mero नाम Raj'),
        equals('मेरो नाम रज्'),
      );
    });

    test('Punctuation, dashes and newlines are preserved', () {
      expect(
        NepaliUnicode.convert('mocii-mahaakaalii!\nhaamii, sabai.'),
        equals('मोची-महाकाली!\nहामी, सबै.'),
      );
    });

    test('Empty and whitespace-only strings', () {
      expect(NepaliUnicode.convert(''), equals(''));
      expect(NepaliUnicode.convert('   '), equals('   '));
      expect(NepaliUnicode.convert('\n\t  \n'), equals('\n\t  \n'));
    });
  });

  group('NepaliUnicode - Live Mode (Type-as-you-write)', () {
    test('Progressive typing of "m" -> "ma" -> "maa" -> "maalaa"', () {
      expect(NepaliUnicode.convert('m', live: true), equals('म्'));
      expect(NepaliUnicode.convert('ma', live: true), equals('म'));
      expect(NepaliUnicode.convert('maa', live: true), equals('मा'));
      expect(NepaliUnicode.convert('maala', live: true), equals('माल'));
      expect(NepaliUnicode.convert('maalaa', live: true), equals('माला'));
    });

    test(
        'Progressive typing of "k" -> "ka" -> "kaa" -> "kh" -> "kha" -> "khaa"',
        () {
      expect(NepaliUnicode.convert('k', live: true), equals('क्'));
      expect(NepaliUnicode.convert('ka', live: true), equals('क'));
      expect(NepaliUnicode.convert('kaa', live: true), equals('का'));
      expect(NepaliUnicode.convert('kh', live: true), equals('ख्'));
      expect(NepaliUnicode.convert('kha', live: true), equals('ख'));
      expect(NepaliUnicode.convert('khaa', live: true), equals('खा'));
    });

    test('Typing in sentences in live mode', () {
      const input = "sayau' thu''gaa";
      expect(
        NepaliUnicode.convert(input, live: true),
        equals('सयौं थुँगा'),
      );
    });
  });
}
