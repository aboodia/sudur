import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/quran_reference/quran_reference_models.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';
import 'package:sudur/core/quran_reference/surah_search.dart';

void main() {
  late QuranReferenceRepository reference;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    reference = await QuranReferenceRepository.load();
  });

  List<int> find(String query) => [
    for (final s in reference.surahs)
      if (surahMatches(s, query)) s.number,
  ];

  test('normalizing drops accents, case, hyphens and spaces', () {
    expect(normalizeSearch('Al-Baqara'), 'albaqara');
    expect(normalizeSearch('  al baqara '), 'albaqara');
    expect(normalizeSearch('ÉLÈVE'), 'eleve');
    expect(normalizeSearch("Aal-i-Imraan"), 'aaliimraan');
  });

  test('an empty search shows every sourate', () {
    expect(find(''), hasLength(114));
    expect(find('   '), hasLength(114));
  });

  test('a name is found however it is typed', () {
    final baqara = reference.surahs
        .firstWhere((s) => s.englishName == 'Al-Baqara')
        .number;
    expect(find('baqara'), contains(baqara));
    expect(find('al baqara'), contains(baqara));
    expect(find('AL-BAQARA'), contains(baqara));
  });

  test('a number finds that sourate', () {
    expect(find('1'), contains(1));
    expect(find('114'), contains(114));
    expect(find('2'), contains(2));
    // A number is the sourate itself, not every name that contains a digit.
    expect(find('114'), [114]);
  });

  test('the French name is searched too', () {
    final one = reference.surahs.firstWhere((s) => s.number == 2);
    final word = one.frenchNameTranslation.split(' ').last;
    expect(find(word), contains(2));
  });

  test('nothing matches nonsense', () {
    expect(find('zzzzqq'), isEmpty);
  });

  test('surahMatches works on a single sourate', () {
    const s = Surah(
      number: 7,
      nameArabic: 'x',
      englishName: "Al-A'raaf",
      englishNameTranslation: 'The Heights',
      frenchNameTranslation: 'Les Murailles',
      numberOfAyahs: 206,
      revelationType: RevelationType.meccan,
    );
    expect(surahMatches(s, 'araaf'), isTrue);
    expect(surahMatches(s, 'murailles'), isTrue);
    expect(surahMatches(s, 'heights'), isTrue);
    expect(surahMatches(s, '7'), isTrue);
    expect(surahMatches(s, '8'), isFalse);
  });
}
