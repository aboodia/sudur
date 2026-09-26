import 'package:flutter_test/flutter_test.dart';
import 'package:wird/core/memorization/ayah_display_repository.dart';

void main() {
  group('parseAyahDisplayText', () {
    test('splits off a trailing Eastern-Arabic ayah-number marker', () {
      final result = parseAyahDisplayText('بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ ١');
      expect(result.words, ['بِسۡمِ', 'ٱللَّهِ', 'ٱلرَّحۡمَٰنِ', 'ٱلرَّحِيمِ']);
      expect(result.marker, '١');
    });

    test('handles a multi-digit trailing marker', () {
      final result = parseAyahDisplayText('مِنَ ٱلۡجِنَّةِ وَٱلنَّاسِ ٦٢');
      expect(result.words, ['مِنَ', 'ٱلۡجِنَّةِ', 'وَٱلنَّاسِ']);
      expect(result.marker, '٦٢');
    });

    test('returns no marker when there is no trailing numeral', () {
      final result = parseAyahDisplayText('كلمة أخرى');
      expect(result.words, ['كلمة', 'أخرى']);
      expect(result.marker, isNull);
    });

    test('tolerates surrounding whitespace', () {
      final result = parseAyahDisplayText('  وَٱلنَّاسِ ٦  ');
      expect(result.words, ['وَٱلنَّاسِ']);
      expect(result.marker, '٦');
    });
  });
}
