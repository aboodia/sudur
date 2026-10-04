import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudur/core/settings/last_read.dart';

Future<ProviderContainer> _open([Map<String, Object> prefs = const {}]) async {
  SharedPreferences.setMockInitialValues(prefs);
  final c = ProviderContainer();
  c.read(lastReadProvider);
  // Give the saved page time to be read, however busy the machine is.
  await Future<void>.delayed(const Duration(milliseconds: 150));
  return c;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('nothing read yet, nothing to resume', () async {
    final c = await _open();
    addTearDown(c.dispose);
    expect(c.read(lastReadProvider), isNull);
  });

  test('the page read is remembered across a restart', () async {
    final first = await _open();
    await first.read(lastReadProvider.notifier).record(77);
    first.dispose();

    final second = await _open({'reading.lastPage': 77});
    addTearDown(second.dispose);
    expect(second.read(lastReadProvider), 77);
  });

  test('a page outside the Mushaf is ignored', () async {
    final c = await _open();
    addTearDown(c.dispose);
    final notifier = c.read(lastReadProvider.notifier);

    await notifier.record(0);
    await notifier.record(605);
    await notifier.record(-3);

    expect(c.read(lastReadProvider), isNull);
  });

  test('a saved page that makes no sense is not trusted', () async {
    final c = await _open({'reading.lastPage': 9999});
    addTearDown(c.dispose);
    expect(c.read(lastReadProvider), isNull);
  });

  test('reading on moves the bookmark', () async {
    final c = await _open();
    addTearDown(c.dispose);
    final notifier = c.read(lastReadProvider.notifier);

    await notifier.record(10);
    await notifier.record(11);

    expect(c.read(lastReadProvider), 11);
  });
}
