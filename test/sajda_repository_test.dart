import 'package:flutter_test/flutter_test.dart';
import 'package:wird/core/quran_text/sajda_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SajdaRepository repo;

  setUpAll(() async {
    repo = await SajdaRepository.load();
  });

  test('As-Sajda 32:15 is a required sajda', () {
    expect(repo.sajdaTypeFor(32, 15), 'required');
  });

  test('Al-Araf 7:206 is an optional sajda', () {
    expect(repo.sajdaTypeFor(7, 206), 'optional');
  });

  test('a non-sajda ayah returns null', () {
    expect(repo.sajdaTypeFor(1, 1), isNull);
  });
}
