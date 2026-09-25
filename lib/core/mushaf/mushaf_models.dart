/// Constant line grid of the "QPC v4 tajweed, 15 lines" Madina Mushaf
/// layout — pages with fewer content lines (e.g. page 1) leave the rest of
/// the grid blank rather than stretching their lines apart.
const kMushafLinesPerPage = 15;

/// One line of one Mushaf page, from the QUL "QPC v4 tajweed, 15 lines"
/// layout (604 pages — the standard Madina Mushaf pagination). Word-bearing
/// lines reference a contiguous range of [MushafWord] ids; decorative lines
/// (sourate banner, basmallah) don't.
class MushafLine {
  const MushafLine({
    required this.page,
    required this.line,
    required this.type,
    required this.isCentered,
    this.firstWordId,
    this.lastWordId,
    this.surahNumber,
  });

  factory MushafLine.fromJson(Map<String, dynamic> json) => MushafLine(
        page: json['p'] as int,
        line: json['l'] as int,
        type: json['t'] as String,
        isCentered: json['c'] as bool,
        firstWordId: json['f'] as int?,
        lastWordId: json['e'] as int?,
        surahNumber: json['s'] as int?,
      );

  final int page;
  final int line;

  /// 'ayah' | 'surah_name' | 'basmallah'
  final String type;
  final bool isCentered;
  final int? firstWordId;
  final int? lastWordId;

  /// Only set when [type] is 'surah_name'.
  final int? surahNumber;

  bool get hasWords => firstWordId != null && lastWordId != null;
}

/// One word's pre-shaped glyph, to be rendered with that word's page-specific
/// QCF font (see MushafFontCache) — [text] is meaningless in any other font.
class MushafWord {
  const MushafWord({
    required this.id,
    required this.surah,
    required this.ayah,
    required this.wordIndex,
    required this.text,
  });

  factory MushafWord.fromJson(int id, Map<String, dynamic> json) => MushafWord(
        id: id,
        surah: json['s'] as int,
        ayah: json['a'] as int,
        wordIndex: json['w'] as int,
        text: json['t'] as String,
      );

  final int id;
  final int surah;
  final int ayah;
  final int wordIndex;
  final String text;
}
