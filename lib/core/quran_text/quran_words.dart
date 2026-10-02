/// The words of an ayah's Arabic text, split on whitespace — never an empty
/// "word" from stray leading or trailing whitespace.
List<String> quranWords(String arabic) =>
    arabic.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
