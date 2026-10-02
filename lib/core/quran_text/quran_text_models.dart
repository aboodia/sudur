/// One ayah's text in the three display forms Brique 1 needs: Arabe seul,
/// Translittération and Bilingue reuse the same underlying ayah data.
class AyahText {
  const AyahText({
    required this.numberInSurah,
    required this.arabic,
    required this.french,
    required this.transliteration,
  });

  factory AyahText.fromJson(Map<String, dynamic> json) => AyahText(
    numberInSurah: json['n'] as int,
    // The source marks Al-Fatiha's ayah 1 with a leading U+FEFF (an
    // invisible byte-order mark, not part of the text): it made the
    // "first word" of that verse an empty string.
    arabic: (json['ar'] as String).replaceAll('﻿', ''),
    french: json['fr'] as String,
    transliteration: json['tl'] as String,
  );

  final int numberInSurah;
  final String arabic;
  final String french;
  final String transliteration;

  AyahText copyWith({String? arabic}) => AyahText(
    numberInSurah: numberInSurah,
    arabic: arabic ?? this.arabic,
    french: french,
    transliteration: transliteration,
  );
}

class SurahText {
  const SurahText({required this.number, required this.ayahs, this.basmalah});

  factory SurahText.fromJson(Map<String, dynamic> json) => SurahText(
    number: json['number'] as int,
    ayahs: (json['ayahs'] as List)
        .cast<Map<String, dynamic>>()
        .map(AyahText.fromJson)
        .toList(growable: false),
  );

  final int number;
  final List<AyahText> ayahs;

  /// The basmalah that was prefixed to ayah 1's raw text — already
  /// stripped out of [ayahs] — for every sourate except Al-Fatiha (where
  /// it genuinely IS ayah 1) and At-Tawbah (which has none). Populated by
  /// [QuranTextRepository] using the exact string Al-Fatiha's own ayah 1
  /// carries, rather than a hand-typed copy that could drift from it
  /// (Arabic combining diacritics can be stored in more than one order
  /// for the same rendered glyph, breaking a naive string comparison).
  final String? basmalah;

  bool get hasBasmalah => basmalah != null;

  SurahText withBasmalahStripped(String basmalahText) {
    if (ayahs.isEmpty || !ayahs[0].arabic.startsWith(basmalahText)) return this;
    final firstAyah = ayahs[0];
    return SurahText(
      number: number,
      basmalah: basmalahText,
      ayahs: [
        firstAyah.copyWith(
          arabic: firstAyah.arabic.substring(basmalahText.length).trim(),
        ),
        ...ayahs.skip(1),
      ],
    );
  }
}
