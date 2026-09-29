import 'package:nepali_kit/nepali_kit.dart';
import 'package:test/test.dart';

void main() {
  test('Check words precision', () {
    final testCases = [
      'nepaal',
      'nepaali',
      'namaste',
      'dhanyabaad',
      'swagatam',
      'kasto chha?',
      'mero naam Raj ho.',
      'tapaiilai kasto chha?',
      'aarogya',
      'shanti',
      'bhabisya',
      'kripaya',
      'samvidhaan',
      'pradhaanmantrii',
      'kathmandu',
      'pokhara',
      'bhaat',
      'paani',
      'ghar',
      'sansar',
      'chya',
      'churot',
      'kura',
      'samaj',
      'swatantra',
      'krishna',
      'buddha',
      'shree',
      'nepal ma swagat chha',
    ];

    for (final word in testCases) {
      print('$word => ${NepaliUnicode.convert(word)}');
    }
  });
}
