// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get sessionQuitTooltip => 'Quitter (la progression est sauvegardée)';

  @override
  String get sessionBackTooltip => 'Retour à l\'étape précédente';

  @override
  String stepOfTotal(int step, int total, String name) {
    return 'Étape $step sur $total · $name';
  }

  @override
  String get discoverTitle => 'Écoute le passage en entier';

  @override
  String get discoverSubtitle =>
      'Suis le texte des yeux, sans chercher à retenir. Tu prends simplement contact avec les versets.';

  @override
  String listeningToAyah(int ayah) {
    return 'Verset $ayah en lecture';
  }

  @override
  String get finishedListening => 'J\'ai écouté le passage';

  @override
  String get listenAgain => 'Écouter une seconde fois';

  @override
  String verseOfTotal(int n, int total) {
    return 'Verset $n sur $total';
  }

  @override
  String get repeatAloudBadge => 'Répète à voix haute';

  @override
  String listenXOfY(int x, int y) {
    return 'Écoute $x sur $y · puis répète';
  }

  @override
  String get noHesitation => 'Je le répète sans hésiter';

  @override
  String get maskInstructions =>
      'Récite en complétant les mots masqués. Touche un mot pour le révéler.';

  @override
  String get levelLight => 'Léger';

  @override
  String get levelMedium => 'Moyen';

  @override
  String get levelFull => 'Complet';

  @override
  String get noWordRevealedYet =>
      'Aucun mot révélé pour l\'instant. Prends ton temps.';

  @override
  String someWordsRevealed(int n) {
    return '$n mot(s) révélé(s) — ils seront à surveiller à la révision.';
  }

  @override
  String get restartStep => 'Recommencer';

  @override
  String get iKnowIt => 'Je le connais';

  @override
  String reciteVerseNoHelp(int n) {
    return 'Récite le verset $n sans aide';
  }

  @override
  String get reciteInstructions =>
      'Seul le premier mot reste visible. Récite, puis vérifie.';

  @override
  String get showVerse => 'Afficher le verset';

  @override
  String get hideVerse => 'Masquer le verset';

  @override
  String get howWasRecitation => 'Comment s\'est passée ta récitation ?';

  @override
  String get outcomeClean => 'Sans erreur';

  @override
  String get outcomeCleanSub => 'Verset validé';

  @override
  String get outcomeHesitant => 'Quelques hésitations';

  @override
  String get outcomeHesitantSub => 'Validé, revu plus tôt';

  @override
  String get outcomeRedo => 'À reprendre';

  @override
  String get outcomeRedoSub => 'On le repasse au masquage';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get chainTitle => 'Récite le passage d\'un seul tenant';

  @override
  String get chainSubtitle =>
      'Relie les versets entre eux : c\'est ce qui fixe le passage dans la mémoire.';

  @override
  String chainVerseLabel(int n) {
    return 'Verset $n';
  }

  @override
  String get chainStatusValidated => 'Sans erreur';

  @override
  String get chainStatusHesitant => '1 hésitation';

  @override
  String get chainStatusCurrent => 'En cours';

  @override
  String get finishPassageButton => 'Terminer le passage';

  @override
  String get passageMemorizedBadge => 'PASSAGE MÉMORISÉ';

  @override
  String passageMemorizedTitle(String surah, int start, int end) {
    return '$surah, versets $start à $end';
  }

  @override
  String passageMemorizedTitleSingle(String surah, int start) {
    return '$surah, verset $start';
  }

  @override
  String get barakAllahuFik => 'بارك الله فيك';

  @override
  String get passageMemorizedSubtitle =>
      'Ces versets sont maintenant dans ton cœur. La révision va les y ancrer durablement.';

  @override
  String statVerses(int n) {
    return '$n verset(s)';
  }

  @override
  String statDuration(int min) {
    return '$min min de pratique';
  }

  @override
  String statToWatch(int n) {
    return '$n verset(s) à surveiller';
  }

  @override
  String get reviewCycleTitle => 'Ton cycle de révision';

  @override
  String get reviewCycleTomorrow => 'Demain';

  @override
  String surahProgressLabel(String name) {
    return 'Sourate $name';
  }

  @override
  String surahProgressCount(int n, int total) {
    return '$n / $total versets';
  }

  @override
  String surahProgressRemaining(int n) {
    return 'Encore $n verset(s) pour compléter la sourate : elle comptera pour ton prochain badge.';
  }

  @override
  String get surahAlreadyComplete => 'Sourate complète, mabrouk !';

  @override
  String get backToHome => 'Retour à l\'accueil';

  @override
  String get replayPassage => 'Réécouter le passage';

  @override
  String get greeting => 'Assalamu alaykum';

  @override
  String get todaysSessionLabel => 'SESSION DU JOUR · MÉMORISATION';

  @override
  String estimatedDuration(int min) {
    return '≈ $min min';
  }

  @override
  String surahVersesLabel(int surah, int start, int end) {
    return 'Sourate $surah · versets $start à $end';
  }

  @override
  String surahVerseLabelSingle(int surah, int start) {
    return 'Sourate $surah · verset $start';
  }

  @override
  String get startSession => 'Commencer la session';

  @override
  String get alsoToday => 'AUSSI AUJOURD\'HUI';

  @override
  String reviewDueToday(int n) {
    return '$n verset(s) à réviser aujourd\'hui';
  }

  @override
  String get allMemorizedCongrats => 'Tout le Coran est mémorisé, mabrouk !';

  @override
  String profileRemaining(int n, String nextName) {
    return '$n sourate(s) restante(s) pour $nextName';
  }

  @override
  String get profileMaxed => 'Le sommet est atteint, mabrouk !';

  @override
  String get revisionHubTitle => 'Révision';

  @override
  String get revisionTodayLabel => 'RÉVISION DU JOUR';

  @override
  String get revisionStart => 'Commencer la révision';

  @override
  String get revisionUpToDateTitle => 'Tu es à jour';

  @override
  String get revisionUpToDateSubtitle => 'Rien à réviser aujourd\'hui.';

  @override
  String revisionNextDue(String date) {
    return 'Prochaine révision : $date';
  }

  @override
  String get revisionNothingYet =>
      'Tes révisions apparaîtront ici dès que tu auras mémorisé ton premier passage.';

  @override
  String get revisionCalendarTitle => 'Calendrier';

  @override
  String get revisionViewDay => 'Jour';

  @override
  String get revisionViewWeek => 'Semaine';

  @override
  String get revisionViewMonth => 'Mois';

  @override
  String get revisionNothingThatDay => 'Rien de prévu ce jour-là.';

  @override
  String revisionPassageRange(String surah, int start, int end) {
    return '$surah · versets $start à $end';
  }

  @override
  String revisionPassageSingle(String surah, int start) {
    return '$surah · verset $start';
  }

  @override
  String get revisionPreviousMonth => 'Mois précédent';

  @override
  String get revisionNextMonth => 'Mois suivant';

  @override
  String get revisionMasteryTitle => 'Ta maîtrise';

  @override
  String get revisionMasteryHint =>
      'Calculée d\'après tes auto-évaluations : plus un verset est récité sans erreur, plus il devient solide.';

  @override
  String get masteryWeak => 'Faible';

  @override
  String get masteryMedium => 'Moyen';

  @override
  String get masterySolid => 'Solide';

  @override
  String get revisionQuitTooltip =>
      'Quitter (ce que tu as déjà révisé est enregistré)';

  @override
  String get revisionDoneTitle => 'Révision terminée';

  @override
  String get revisionDoneAllClean =>
      'Belle récitation, mabrouk ! Tout est bien en place.';

  @override
  String get revisionDoneEncourage =>
      'Chaque révision ancre un peu plus : les versets hésitants reviendront bientôt pour mieux se fixer.';

  @override
  String revisionResultLine(String label, int n) {
    return '$label · $n';
  }

  @override
  String revisionRemaining(int n) {
    return 'Il t\'en reste $n verset(s) à réviser aujourd\'hui.';
  }

  @override
  String get revisionReviseMore => 'Réviser encore';

  @override
  String get revisionBack => 'Retour';

  @override
  String get statsTitle => 'Statistiques de progression';

  @override
  String get statsSubtitle => 'Ton évolution dans la mémorisation';

  @override
  String get statsTileVerses => 'Versets';

  @override
  String get statsTileSurahs => 'Sourates';

  @override
  String get statsTileJuz => 'Juz';

  @override
  String get statsTileRetention => 'Rétention';

  @override
  String get statsTileStreak => 'Série';

  @override
  String get statsTileTime => 'Temps total';

  @override
  String get statsCaptionMemorized => 'mémorisés';

  @override
  String get statsCaptionCompleted => 'achevées';

  @override
  String get statsCaptionOutOf30 => 'sur 30';

  @override
  String get statsCaptionRetention => 'sur 30 jours';

  @override
  String get statsCaptionRetentionNone => 'pas encore de révision';

  @override
  String get statsCaptionStreak => 'assiduité';

  @override
  String get statsCaptionTime => 'dédié au Coran';

  @override
  String statsDays(int n) {
    return '$n j';
  }

  @override
  String statsPercent(int n) {
    return '$n %';
  }

  @override
  String get pathTitle => 'Le Chemin';

  @override
  String pathSummaryTitle(int done, int total) {
    return '$done sourate(s) sur $total';
  }

  @override
  String pathNextStep(String surah) {
    return 'Prochaine étape : $surah';
  }

  @override
  String get pathContinue => 'Continuer';

  @override
  String get pathAllDone => 'Tout le chemin est parcouru, mabrouk !';

  @override
  String get milestoneCompleted => 'Achevée';

  @override
  String get milestoneCurrent => 'En cours';

  @override
  String get milestoneLocked => 'À venir';

  @override
  String milestoneVersesAndType(int n, String type) {
    return '$n verset(s) · $type';
  }

  @override
  String get revelationMeccan => 'Mecquoise';

  @override
  String get revelationMedinan => 'Médinoise';

  @override
  String milestoneCompletedOn(String date) {
    return 'Achevée le $date';
  }

  @override
  String get milestoneAlreadyKnown =>
      'Déjà mémorisée avant ton arrivée dans l\'application.';

  @override
  String get milestoneLocksHint =>
      'Elle s\'ouvrira sur ton chemin après les sourates qui la précèdent.';

  @override
  String get milestoneRead => 'Lire la sourate';

  @override
  String get milestoneContinue => 'Continuer la mémorisation';

  @override
  String milestoneSemantics(int number, String name, String state) {
    return 'Sourate $number, $name, $state';
  }

  @override
  String get storyUnlockedTitle => 'Histoire débloquée';

  @override
  String get storyComingSoon =>
      'Le récit de cette sourate sera ajouté une fois son contenu validé.';

  @override
  String storySource(String source) {
    return 'Source : $source';
  }

  @override
  String get storyOpen => 'Voir l\'histoire';
}
