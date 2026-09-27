import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/audio/reciter.dart';

void main() {
  test('builds a valid cdn.islamic.network URL for a given reciter and ayah', () {
    final url = ayahAudioUrl(reciterById('alafasy'), 1);
    expect(url, 'https://cdn.islamic.network/quran/audio/128/ar.alafasy/1.mp3');
  });

  test('falls back to the first reciter for an unknown id', () {
    expect(reciterById('unknown'), kReciters.first);
  });

  test('kReciters has no duplicate ids', () {
    final ids = kReciters.map((r) => r.id).toSet();
    expect(ids.length, kReciters.length);
  });
}
