import 'package:nepali_kit/nepali_kit.dart';

void main() {
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
    print('$word => ${NepaliUnicode.convert(word)}');
  }
}
