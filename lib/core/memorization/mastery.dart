import 'review_scheduler.dart';

/// Number of successful reviews after which a verse is on the monthly
/// (J+30) interval — [ReviewScheduler]'s last cycle step.
const solidCycleStep = 2;

/// Faible / moyen / solide, dérivé de l'état de révision d'un verset plutôt
/// que saisi à la main : l'auto-évaluation faite à chaque révision *est* le
/// marquage de maîtrise, et c'est elle qui règle déjà la fréquence.
enum MasteryLevel { weak, medium, solid }

/// [lastOutcome] est le nom stocké d'un [ReciteOutcome] ('clean' |
/// 'hesitant' | 'redo'), [cycleStep] le nombre de révisions réussies
/// ([ReviewScheduler]'s `cycleStep`).
///
/// - à reprendre → faible, quel que soit l'historique ;
/// - hésitant → faible tant que le verset n'est pas installé dans le cycle
///   mensuel, moyen ensuite ;
/// - sans erreur → solide une fois dans le cycle mensuel, moyen avant.
MasteryLevel masteryFor({
  required String? lastOutcome,
  required int cycleStep,
}) {
  final installed = cycleStep >= solidCycleStep;
  switch (ReciteOutcome.values.asNameMap()[lastOutcome]) {
    case ReciteOutcome.redo:
      return MasteryLevel.weak;
    case ReciteOutcome.hesitant:
      return installed ? MasteryLevel.medium : MasteryLevel.weak;
    case ReciteOutcome.clean:
      return installed ? MasteryLevel.solid : MasteryLevel.medium;
    case null:
      return MasteryLevel.medium;
  }
}

/// How many verses sit at each [MasteryLevel].
class MasteryCounts {
  const MasteryCounts({this.weak = 0, this.medium = 0, this.solid = 0});

  factory MasteryCounts.of(Iterable<MasteryLevel> levels) {
    var weak = 0, medium = 0, solid = 0;
    for (final level in levels) {
      switch (level) {
        case MasteryLevel.weak:
          weak++;
        case MasteryLevel.medium:
          medium++;
        case MasteryLevel.solid:
          solid++;
      }
    }
    return MasteryCounts(weak: weak, medium: medium, solid: solid);
  }

  final int weak;
  final int medium;
  final int solid;

  int get total => weak + medium + solid;
}
