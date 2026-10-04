import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The story unlocked when a sourate is completed (circonstances de
/// révélation, histoire liée à la sourate — cahier des charges §4.6).
///
/// This is religious content: it must be reviewed by someone qualified
/// before it ships (§6.3), and is never written by the app's developers.
/// The shipped file `assets/data/surah_stories.json` is therefore empty
/// until validated stories are supplied; every story must name its source.
class SurahStory {
  const SurahStory({
    required this.title,
    required this.body,
    required this.source,
  });

  final String title;
  final String body;

  /// Where the text comes from (Coran, tafsir, sîra, hadith sahih...).
  final String source;
}

/// Parses `{"stories": {"<sourate number>": {"title", "body", "source"}}}`.
/// An entry without a title, a body AND a source is ignored: an unsourced
/// story is not shown.
Map<int, SurahStory> parseSurahStories(String json) {
  final decoded = jsonDecode(json);
  final raw = decoded is Map<String, dynamic> ? decoded['stories'] : null;
  if (raw is! Map<String, dynamic>) return const {};

  final stories = <int, SurahStory>{};
  raw.forEach((key, value) {
    final number = int.tryParse(key);
    if (number == null || number < 1 || number > 114) return;
    if (value is! Map<String, dynamic>) return;

    String text(String field) => (value[field] as String? ?? '').trim();
    final title = text('title');
    final body = text('body');
    final source = text('source');
    if (title.isEmpty || body.isEmpty || source.isEmpty) return;

    stories[number] = SurahStory(title: title, body: body, source: source);
  });
  return stories;
}

final surahStoriesProvider = FutureProvider<Map<int, SurahStory>>((ref) async {
  final raw = await rootBundle.loadString('assets/data/surah_stories.json');
  return parseSurahStories(raw);
});

/// Whether a validated story exists for [surah]. While none does, the app
/// shows no "story" section at all rather than an empty promise on every
/// sourate.
final hasStoryProvider = Provider.family<bool, int>(
  (ref, surah) =>
      ref.watch(surahStoriesProvider).value?.containsKey(surah) ?? false,
);
