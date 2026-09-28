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
}
