import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/path/milestones.dart';
import 'package:sudur/core/path/surah_stories.dart';

void main() {
  // Three fake sourates of 7, 286 and 200 verses.
  const counts = [7, 286, 200];

  group('buildMilestones', () {
    test('a new user starts on the first sourate, the rest still ahead', () {
      final m = buildMilestones(ayahCounts: counts, progressBySurah: const {});
      expect(m.map((x) => x.state), [
        MilestoneState.current,
        MilestoneState.locked,
        MilestoneState.locked,
      ]);
      expect(currentMilestone(m)!.surahNumber, 1);
      expect(completedMilestones(m), 0);
    });

    test(
      'a finished sourate is completed and the next one becomes current',
      () {
        final done = DateTime(2026, 9, 20);
        final m = buildMilestones(
          ayahCounts: counts,
          progressBySurah: {1: (memorized: 7, completedAt: done)},
        );
        expect(m[0].state, MilestoneState.completed);
        expect(m[0].completedAt, done);
        expect(m[1].state, MilestoneState.current);
        expect(m[2].state, MilestoneState.locked);
      },
    );

    test('partial progress keeps the sourate current, with its fraction', () {
      final m = buildMilestones(
        ayahCounts: counts,
        progressBySurah: {
          1: (memorized: 7, completedAt: DateTime(2026, 9, 20)),
          2: (memorized: 5, completedAt: null),
        },
      );
      expect(m[1].state, MilestoneState.current);
      expect(m[1].memorizedAyahs, 5);
      expect(m[1].progress, closeTo(5 / 286, 1e-9));
    });

    test('completed sourates after the current one stay completed', () {
      // Declared in the onboarding: sourates 1 and 3 known, 2 is not.
      final m = buildMilestones(
        ayahCounts: counts,
        progressBySurah: {
          1: (memorized: 7, completedAt: DateTime(2026, 9, 1)),
          3: (memorized: 200, completedAt: DateTime(2026, 9, 1)),
        },
      );
      expect(m.map((x) => x.state), [
        MilestoneState.completed,
        MilestoneState.current,
        MilestoneState.completed,
      ]);
      expect(completedMilestones(m), 2);
    });

    test('with everything memorized there is no current milestone', () {
      final m = buildMilestones(
        ayahCounts: counts,
        progressBySurah: {
          for (var i = 0; i < counts.length; i++)
            i + 1: (memorized: counts[i], completedAt: DateTime(2026, 9, 1)),
        },
      );
      expect(currentMilestone(m), isNull);
      expect(completedMilestones(m), 3);
    });

    test('memorized beyond the total is clamped, not over 100 %', () {
      final m = buildMilestones(
        ayahCounts: counts,
        progressBySurah: {1: (memorized: 99, completedAt: null)},
      );
      expect(m[0].memorizedAyahs, 7);
      expect(m[0].progress, 1);
      expect(m[0].state, MilestoneState.completed);
    });

    test('a sourate with no recorded date still completes', () {
      final m = buildMilestones(
        ayahCounts: counts,
        progressBySurah: {1: (memorized: 7, completedAt: null)},
      );
      expect(m[0].state, MilestoneState.completed);
      expect(m[0].completedAt, isNull);
    });
  });

  group('parseSurahStories', () {
    test('keeps a complete, sourced story', () {
      final stories = parseSurahStories(
        '{"stories": {"67": {"title": "titre", "body": "texte", "source": "ma source"}}}',
      );
      expect(stories.keys, [67]);
      expect(stories[67]!.title, 'titre');
      expect(stories[67]!.source, 'ma source');
    });

    test('drops a story with no source — unsourced content is not shown', () {
      final stories = parseSurahStories(
        '{"stories": {"67": {"title": "t", "body": "b", "source": "  "}}}',
      );
      expect(stories, isEmpty);
    });

    test('drops entries that are incomplete or out of range', () {
      final stories = parseSurahStories('''
        {"stories": {
          "0": {"title": "t", "body": "b", "source": "s"},
          "115": {"title": "t", "body": "b", "source": "s"},
          "x": {"title": "t", "body": "b", "source": "s"},
          "10": {"title": "", "body": "b", "source": "s"},
          "11": "not a map"
        }}''');
      expect(stories, isEmpty);
    });

    test('an empty or malformed file gives no stories instead of crashing', () {
      expect(parseSurahStories('{"stories": {}}'), isEmpty);
      expect(parseSurahStories('{}'), isEmpty);
      expect(parseSurahStories('[]'), isEmpty);
    });
  });
}
