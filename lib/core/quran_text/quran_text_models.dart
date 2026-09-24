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
        arabic: json['ar'] as String,
        french: json['fr'] as String,
        transliteration: json['tl'] as String,
      );

  final int numberInSurah;
  final String arabic;
  final String french;
  final String transliteration;
}

class SurahText {
  const SurahText({required this.number, required this.ayahs});

  factory SurahText.fromJson(Map<String, dynamic> json) => SurahText(
        number: json['number'] as int,
        ayahs: (json['ayahs'] as List)
            .cast<Map<String, dynamic>>()
            .map(AyahText.fromJson)
            .toList(growable: false),
      );

  final int number;
  final List<AyahText> ayahs;
}
