import '../database/app_database.dart';

/// Regroupe des unités par date d'échéance (jour, sans l'heure) pour la vue
/// calendaire — réutilise la liste déjà chargée par `memorizationUnitsProvider`
/// plutôt que d'ajouter une requête DB par plage de dates.
Map<DateTime, List<MemorizationUnit>> groupByDueDate(List<MemorizationUnit> units) {
  final result = <DateTime, List<MemorizationUnit>>{};
  for (final unit in units) {
    final due = unit.nextReviewDueAt;
    if (due == null) continue;
    final day = DateTime(due.year, due.month, due.day);
    (result[day] ??= []).add(unit);
  }
  return result;
}
