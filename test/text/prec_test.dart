import 'package:nepali_kit/nepali_kit.dart';
import 'package:test/test.dart';

void main() {
  test('Check outputs', () {
    final testCases = [
      'nepaal',
      'nepaali',
      'namaste',
      'dhanyabaad',
      'swagatam',
      'kasto chha?',
      'mero naam Bikash ho.',
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
    ];

    for (final word in testCases) {
      print('PRECISION: $word => ${NepaliUnicode.convert(word)}');
    }
  });
}
