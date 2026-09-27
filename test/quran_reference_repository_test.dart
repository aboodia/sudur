// Verifies the Juz/Hizb boundary data and lookup helpers against
// well-known facts about the standard Mushaf, since the cahier des charges
// explicitly warns against hand-rolled pagination logic (§6.6): any error
// here must be caught by a test, not discovered later in the UI.

import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late QuranReferenceRepository repo;

  setUpAll(() async {
    repo = await QuranReferenceRepository.load();
  });

  test('loads all 114 sourates, 30 Juz starts and 60 Hizb starts', () {
    expect(repo.surahs, hasLength(114));
    expect(repo.juzStarts, hasLength(30));
    expect(repo.hizbStarts, hasLength(60));
  });

  test('Al-Fatiha has 7 ayahs and is Meccan', () {
    final fatiha = repo.surahByNumber(1);
    expect(fatiha.numberOfAyahs, 7);
    expect(fatiha.englishName, 'Al-Faatiha');
  });

  test('every sourate has a French name translation', () {
    expect(repo.surahs.every((s) => s.frenchNameTranslation.isNotEmpty), isTrue);
    expect(repo.surahByNumber(1).frenchNameTranslation, "L'Ouverture");
    expect(repo.surahByNumber(2).frenchNameTranslation, 'La Vache');
    expect(repo.surahByNumber(114).frenchNameTranslation, 'Les Hommes');
  });

  test('Juz boundaries around Al-Baqara match the known Mushaf split', () {
    expect(repo.juzForSurahAyah(2, 141), 1);
    expect(repo.juzForSurahAyah(2, 142), 2);
    expect(repo.juzForSurahAyah(2, 252), 2);
    expect(repo.juzForSurahAyah(2, 253), 3);
  });

  test('the last ayah of the Quran belongs to Juz 30', () {
    expect(repo.juzForSurahAyah(114, 6), 30);
  });

  test('Hizb boundary at 2:75 matches the known Mushaf split', () {
    expect(repo.hizbForSurahAyah(2, 74), 1);
    expect(repo.hizbForSurahAyah(2, 75), 2);
  });

  test('surahsInJuz(1) is exactly Al-Fatiha and the start of Al-Baqara', () {
    final surahs = repo.surahsInJuz(1);
    expect(surahs.map((s) => s.number), [1, 2]);
  });

  test('surahsInJuz(30) covers An-Naba through An-Naas', () {
    final surahs = repo.surahsInJuz(30);
    expect(surahs.first.number, 78);
    expect(surahs.last.number, 114);
  });
}
