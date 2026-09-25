// Verifies the ligature key strings match the QUL "surah-name-v4" font's
// GSUB substitution rules (inspected directly from the font's ligature
// table: "surah001".."surah114" -> uniE001..uniE072).

import 'package:flutter_test/flutter_test.dart';
import 'package:wird/core/mushaf/surah_name_glyph.dart';

void main() {
  test('pads surah numbers to 3 digits', () {
    expect(surahNameLigature(1), 'surah001');
    expect(surahNameLigature(9), 'surah009');
    expect(surahNameLigature(12), 'surah012');
    expect(surahNameLigature(114), 'surah114');
  });
}
