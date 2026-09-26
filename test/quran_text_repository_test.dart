import 'package:flutter_test/flutter_test.dart';
import 'package:wird/core/quran_text/quran_text_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late QuranTextRepository repo;

  setUpAll(() async {
    repo = await QuranTextRepository.load();
  });

  test('Al-Fatiha 1:1 is the Basmala in all three forms', () {
    final ayah = repo.surah(1).ayahs.first;
    expect(ayah.arabic, contains('بِسْمِ'));
    expect(ayah.french, contains('Allah'));
    expect(ayah.transliteration, contains('Bismillaa'));
  });

  test('every sourate has as many ayahs as its declared numberOfAyahs (via metadata)', () {
    // Al-Baqara (2) has 286 ayahs, An-Nas (114) has 6.
    expect(repo.surah(2).ayahs.length, 286);
    expect(repo.surah(114).ayahs.length, 6);
  });

  test('global ayah numbering is 1 for 1:1 and 6236 for 114:6', () {
    expect(repo.globalAyahNumber(1, 1), 1);
    expect(repo.globalAyahNumber(114, 6), 6236);
    // 2:1 comes right after Al-Fatiha's 7 ayahs.
    expect(repo.globalAyahNumber(2, 1), 8);
  });

  test('the basmalah is split out of ayah 1, not left merged into it', () {
    final baqara = repo.surah(2);
    expect(baqara.hasBasmalah, isTrue);
    expect(baqara.ayahs.first.arabic, isNot(contains('بِسْمِ')));
    expect(baqara.ayahs.first.arabic, isNotEmpty);
    // 2:1 is just "Alif Lam Meem" — much shorter than the basmalah alone.
    expect(baqara.ayahs.first.arabic.length, lessThan(10));

    // Al-Fatiha: the basmalah genuinely IS ayah 1, so it must stay.
    final fatiha = repo.surah(1);
    expect(fatiha.hasBasmalah, isFalse);
    expect(fatiha.ayahs.first.arabic, contains('بِسْمِ'));

    // At-Tawbah (9) is the one sourate with no basmalah at all.
    final tawbah = repo.surah(9);
    expect(tawbah.hasBasmalah, isFalse);
    expect(tawbah.ayahs.first.arabic, isNot(contains('بِسْمِ')));
  });
}
