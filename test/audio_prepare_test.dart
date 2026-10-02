import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/audio/audio_playback_controller.dart';

import 'helpers/revision_seed.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('opening a sourate lines the player up on its first ayah', () {
    final c = freshContainer();
    addTearDown(c.dispose);
    final audio = c.read(audioPlaybackProvider.notifier);

    audio.prepare(112, 1);

    final s = c.read(audioPlaybackProvider);
    expect((s.surahNumber, s.ayahNumber), (112, 1));
    expect(s.isPlaying, isFalse);
  });

  test(
    'an ayah merely left over (not playing) is replaced by the new sourate',
    () {
      final c = freshContainer();
      addTearDown(c.dispose);
      final audio = c.read(audioPlaybackProvider.notifier);

      audio.prepare(2, 1); // e.g. left behind by a Mémorisation session
      audio.prepare(112, 1);

      final s = c.read(audioPlaybackProvider);
      expect((s.surahNumber, s.ayahNumber), (112, 1));
    },
  );
}
