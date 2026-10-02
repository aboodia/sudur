import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/mushaf/mushaf_repository.dart';

void main() {
  late MushafRepository mushaf;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    mushaf = await MushafRepository.load();
  });

  test('every one of the 6,236 ayahs has a first page', () {
    final index = mushaf.firstPageByAyah();
    expect(index, hasLength(6236));
    expect(index.values.every((p) => p >= 1 && p <= mushaf.pageCount), isTrue);
  });

  test('the Quran starts on page 1 and ends on the last page', () {
    final index = mushaf.firstPageByAyah();
    expect(index[(surah: 1, ayah: 1)], 1);
    expect(index[(surah: 114, ayah: 6)], mushaf.pageCount);
  });

  test('agrees with the per-ayah lookup it replaces', () {
    final index = mushaf.firstPageByAyah();
    for (final (s, a) in [
      (1, 1),
      (2, 1),
      (2, 255),
      (2, 282),
      (36, 1),
      (67, 1),
      (112, 1),
      (114, 6),
    ]) {
      expect(
        index[(surah: s, ayah: a)],
        mushaf.pageForAyah(s, a),
        reason: '$s:$a',
      );
    }
  });

  test('the index is built once and reused', () {
    expect(
      identical(mushaf.firstPageByAyah(), mushaf.firstPageByAyah()),
      isTrue,
    );
  });
}
