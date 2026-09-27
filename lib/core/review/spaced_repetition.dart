/// Auto-évaluation d'un passage révisé — le cahier des charges (§4.4)
/// demande un marquage à 3 niveaux, pas un simple succès/échec.
enum ReviewRating { weak, medium, solid }

/// "Les Trois Cercles" : 1 = quotidien, 2 = hebdomadaire, 3 = mensuel (et
/// au-delà — un passage solide au Cercle 3 y reste, révisé tous les mois
/// indéfiniment).
int reviewIntervalDays(int circle) {
  switch (circle) {
    case 1:
      return 1;
    case 2:
      return 7;
    default:
      return 30;
  }
}

DateTime nextReviewDate(DateTime from, int circle) {
  return from.add(Duration(days: reviewIntervalDays(circle)));
}

/// Le résultat d'une auto-évaluation : Faible réintègre immédiatement le
/// Cercle 1 (échec), Moyen maintient le cercle actuel (révisé au même
/// rythme), Solide fait avancer le cercle (quotidien → hebdo → mensuel).
({int circle, String masteryLevel, bool success}) applyReviewOutcome({
  required int? circleBefore,
  required ReviewRating rating,
}) {
  switch (rating) {
    case ReviewRating.weak:
      return (circle: 1, masteryLevel: 'weak', success: false);
    case ReviewRating.medium:
      return (circle: circleBefore ?? 1, masteryLevel: 'medium', success: true);
    case ReviewRating.solid:
      final advanced = (circleBefore ?? 0) + 1;
      return (circle: advanced > 3 ? 3 : advanced, masteryLevel: 'solid', success: true);
  }
}
