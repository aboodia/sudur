import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudur/core/audio/reciter.dart';
import 'package:sudur/core/settings/audio_settings.dart';

Future<ProviderContainer> _open() async {
  final c = ProviderContainer();
  c.read(audioSettingsProvider);
  await Future<void>.delayed(const Duration(milliseconds: 30));
  return c;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'defaults to the default reciter at normal speed, once loaded',
    () async {
      SharedPreferences.setMockInitialValues({});
      final c = await _open();
      addTearDown(c.dispose);

      final s = c.read(audioSettingsProvider);

      expect(s.loaded, isTrue);
      expect(s.reciterId, kDefaultReciterId);
      expect(s.speed, 1.0);
    },
  );

  test('not loaded until the saved values have been read', () {
    SharedPreferences.setMockInitialValues({'audio.speed': 1.5});
    final c = ProviderContainer();
    addTearDown(c.dispose);

    expect(c.read(audioSettingsProvider).loaded, isFalse);
  });

  test('the chosen reciter and speed survive a restart', () async {
    SharedPreferences.setMockInitialValues({});
    final first = await _open();
    final controller = first.read(audioSettingsProvider.notifier);
    await controller.setReciter('husary');
    await controller.setSpeed(0.75);
    first.dispose();

    final second = await _open();
    addTearDown(second.dispose);
    final s = second.read(audioSettingsProvider);
    expect(s.reciterId, 'husary');
    expect(s.speed, 0.75);
  });

  test('a reciter no longer offered falls back to the default', () async {
    SharedPreferences.setMockInitialValues({'audio.reciterId': 'gone'});
    final c = await _open();
    addTearDown(c.dispose);

    expect(c.read(audioSettingsProvider).reciterId, kDefaultReciterId);
  });

  test('a speed that is not offered falls back to normal speed', () async {
    SharedPreferences.setMockInitialValues({'audio.speed': 3.7});
    final c = await _open();
    addTearDown(c.dispose);

    expect(c.read(audioSettingsProvider).speed, 1.0);
  });

  test('every speed offered is a valid choice', () {
    expect(kPlaybackSpeeds, contains(1.0));
    expect(kPlaybackSpeeds.toSet(), hasLength(kPlaybackSpeeds.length));
  });
}
