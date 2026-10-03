// Badges tied to real milestones — pure logic, no Flutter and no database.
// Every badge is earned from something the user actually did: verses
// memorized, Juz memorized, days of regularity. Once earned it stays earned.

enum AchievementKind { verses, juz, streak }

/// A badge to earn: reach [target] on the measure of its [kind].
class AchievementDef {
  const AchievementDef(this.kind, this.target);

  final AchievementKind kind;
  final int target;

  /// Stable identifier, stored once the badge is earned.
  String get key => '${kind.name}_$target';

  /// The full Quran: 30 Juz.
  bool get isKhatm => kind == AchievementKind.juz && target == 30;
}

/// The badges, in the order they are shown.
const achievementDefs = [
  AchievementDef(AchievementKind.verses, 1),
  AchievementDef(AchievementKind.verses, 100),
  AchievementDef(AchievementKind.verses, 1000),
  AchievementDef(AchievementKind.juz, 1),
  AchievementDef(AchievementKind.juz, 5),
  AchievementDef(AchievementKind.juz, 10),
  AchievementDef(AchievementKind.juz, 20),
  AchievementDef(AchievementKind.juz, 30),
  AchievementDef(AchievementKind.streak, 3),
  AchievementDef(AchievementKind.streak, 7),
  AchievementDef(AchievementKind.streak, 30),
  AchievementDef(AchievementKind.streak, 100),
  AchievementDef(AchievementKind.streak, 365),
];

/// Where one badge stands against what the user has done so far.
class AchievementStatus {
  const AchievementStatus(this.def, this.value);

  final AchievementDef def;

  /// The user's figure on the badge's measure (verses, Juz, best streak).
  final double value;

  /// Juz come from a sum of fractions: a whole Juz can land a hair below 1.
  bool get reached => value >= def.target - 1e-6;

  /// 0 to 1.
  double get progress => (value / def.target).clamp(0.0, 1.0);
}

/// Every badge against the user's figures: [verses] memorized, [juz]
/// memorized (0 to 30) and the [bestStreak] of regularity ever reached — the
/// best, not the current one, since a badge earned is not taken back when a
/// streak ends.
List<AchievementStatus> evaluateAchievements({
  required int verses,
  required double juz,
  required int bestStreak,
}) => [
  for (final def in achievementDefs)
    AchievementStatus(def, switch (def.kind) {
      AchievementKind.verses => verses.toDouble(),
      AchievementKind.juz => juz,
      AchievementKind.streak => bestStreak.toDouble(),
    }),
];
