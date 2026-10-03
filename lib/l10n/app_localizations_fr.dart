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

  @override
  String get pathTabTrace => 'Tracé';

  @override
  String get pathTabFollowUp => 'Suivi';

  @override
  String get curveTitle => 'Courbe de progression';

  @override
  String get curvePeriod30 => '30 j';

  @override
  String get curvePeriod90 => '90 j';

  @override
  String get curvePeriodAll => 'Tout';

  @override
  String curveGain(int n) {
    return '+$n verset(s) sur la période';
  }

  @override
  String get curveNoGain => 'Pas de nouveau verset sur la période.';

  @override
  String get curveEmpty =>
      'Ta courbe commencera avec ton premier passage mémorisé.';

  @override
  String curveSemantics(int from, int to) {
    return 'Versets mémorisés : $from au début de la période, $to aujourd\'hui';
  }

  @override
  String get mapTitle => 'Carte du Mushaf';

  @override
  String get mapSubtitle => 'Chaque case est une page des 604 du Mushaf.';

  @override
  String mapSummary(int full, int partial, int total) {
    return '$full page(s) complète(s) · $partial entamée(s) sur $total';
  }

  @override
  String get mapLegendNone => 'Pas commencée';

  @override
  String get mapLegendPartial => 'En cours';

  @override
  String get mapLegendFull => 'Complète';

  @override
  String get historyTitle => 'Historique';

  @override
  String get historyEmpty =>
      'Ton historique apparaîtra ici dès ta première session.';

  @override
  String get historyKindMemorization => 'Mémorisation';

  @override
  String get historyKindRevision => 'Révision';

  @override
  String historyLine(String kind, int n) {
    return '$kind · $n verset(s)';
  }

  @override
  String historyDetail(String when, int min) {
    return '$when · $min min';
  }

  @override
  String get goalsTitle => 'Objectifs';

  @override
  String get goalsEdit => 'Modifier';

  @override
  String get goalWeekTitle => 'Cette semaine';

  @override
  String get goalMonthTitle => 'Ce mois-ci';

  @override
  String goalCount(int done, int goal) {
    return '$done / $goal versets';
  }

  @override
  String goalRemaining(int n, int perDay) {
    return 'Encore $n verset(s) : environ $perDay par jour.';
  }

  @override
  String get goalReached => 'Objectif atteint, mabrouk !';

  @override
  String get goalAhead => 'Tu es en avance sur ton rythme.';

  @override
  String get goalSuggested => 'Proposé d\'après ton temps quotidien.';

  @override
  String goalSemantics(String title, int done, int goal) {
    return '$title : $done versets sur $goal';
  }

  @override
  String get goalEditTitle => 'Tes objectifs';

  @override
  String get goalEditHint =>
      'Un objectif doux et tenable vaut mieux qu\'un objectif ambitieux abandonné.';

  @override
  String get goalEditWeekly => 'Par semaine';

  @override
  String get goalEditMonthly => 'Par mois';

  @override
  String get goalEditReset => 'Revenir aux valeurs proposées';

  @override
  String get goalEditSave => 'Enregistrer';

  @override
  String get goalEditDecrease => 'Diminuer';

  @override
  String get goalEditIncrease => 'Augmenter';

  @override
  String get successTitle => 'Régularité et succès';

  @override
  String get streakTitle => 'Ta régularité';

  @override
  String streakCurrent(int n) {
    return '$n jour(s) de suite';
  }

  @override
  String streakBest(int n) {
    return 'Meilleure série : $n j';
  }

  @override
  String get streakNone => 'Ta série commence avec ta prochaine session.';

  @override
  String get streakDoneToday => 'C\'est fait pour aujourd\'hui, bravo.';

  @override
  String get streakAtRisk =>
      'Ta série est en jeu aujourd\'hui : même 5 minutes suffisent.';

  @override
  String get streakJokersTitle => 'Jokers';

  @override
  String streakJokersLeft(int n) {
    return '$n joker(s) en réserve';
  }

  @override
  String get streakJokerExplain =>
      'Un joker garde ta série en vie quand tu manques un jour. Tu en gagnes un tous les 7 jours de régularité, et tu peux en garder 2.';

  @override
  String streakNextJoker(int n) {
    return 'Prochain joker dans $n jour(s) d\'étude.';
  }

  @override
  String get streakJokerFull => 'Ta réserve de jokers est pleine.';

  @override
  String streakCovered(String date) {
    return 'Un joker a protégé ta série le $date.';
  }

  @override
  String get streakRestDays =>
      'Les jours où tu n\'es pas disponible ne cassent jamais ta série.';

  @override
  String get badgesTitle => 'Succès';

  @override
  String badgesCount(int earned, int total) {
    return '$earned sur $total';
  }

  @override
  String get badgeNew => 'Nouveau';

  @override
  String badgeEarnedOn(String date) {
    return 'Obtenu le $date';
  }

  @override
  String badgeProgress(String done, String target) {
    return '$done / $target';
  }

  @override
  String get achTitleFirstVerse => 'Premier verset';

  @override
  String achTitleVerses(int n) {
    return '$n versets';
  }

  @override
  String get achTitleFirstJuz => 'Premier Juz';

  @override
  String achTitleJuz(int n) {
    return '$n Juz';
  }

  @override
  String get achTitleKhatm => 'Coran complet';

  @override
  String achTitleStreak(int n) {
    return '$n jours de régularité';
  }

  @override
  String get achDescFirstVerse => 'Mémoriser ton premier verset.';

  @override
  String achDescVerses(int n) {
    return 'Mémoriser $n versets.';
  }

  @override
  String get achDescFirstJuz => 'Mémoriser un Juz entier.';

  @override
  String achDescJuz(int n) {
    return 'Mémoriser $n Juz.';
  }

  @override
  String get achDescKhatm => 'Mémoriser les 30 Juz du Coran.';

  @override
  String achDescStreak(int n) {
    return 'Étudier $n jours de suite.';
  }

  @override
  String homeNewBadges(int n) {
    return '$n nouveau(x) succès à découvrir';
  }

  @override
  String get reminderTitle => 'Sudur';

  @override
  String get reminderBody => 'C\'est l\'heure de ta session de mémorisation.';

  @override
  String get reminderBodyComeBack =>
      'Ravi de te retrouver quand tu veux : 5 minutes suffisent pour reprendre.';

  @override
  String get reminderSectionTitle => 'Rappel quotidien';

  @override
  String get reminderSwitch => 'Me rappeler chaque jour';

  @override
  String get reminderTime => 'Heure du rappel';

  @override
  String get reminderExplain =>
      'Seulement les jours où tu es disponible, et jamais si tu as déjà étudié.';

  @override
  String get reminderPermissionDenied =>
      'Les notifications sont désactivées pour Sudur. Autorise-les dans les réglages du téléphone pour recevoir le rappel.';

  @override
  String get offlineTitle => 'Contenus hors-ligne';

  @override
  String get offlineIntro =>
      'Le texte arabe, la traduction et la translittération sont déjà dans l\'application. Télécharge ici ce qui demande internet : les pages du Mushaf et l\'audio.';

  @override
  String offlineStorage(String size) {
    return 'Espace utilisé : $size';
  }

  @override
  String get offlineMushafTitle => 'Pages du Mushaf';

  @override
  String offlineMushafCount(int n) {
    return '$n pages sur 604 téléchargées';
  }

  @override
  String get offlineMushafDownload => 'Tout télécharger';

  @override
  String get offlineMushafStop => 'Arrêter';

  @override
  String get offlineMushafDelete => 'Supprimer les pages';

  @override
  String offlineProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String offlineFailed(int n) {
    return '$n échec(s) : vérifie ta connexion puis réessaie.';
  }

  @override
  String offlineAudioTitle(String reciter) {
    return 'Audio de $reciter';
  }

  @override
  String get offlineAudioHint =>
      'Télécharge les sourates que tu veux écouter sans connexion. Le récitant se change dans les réglages audio.';

  @override
  String offlineSurahVerses(int n, int total) {
    return '$n / $total versets';
  }

  @override
  String get offlineSurahDownload => 'Télécharger';

  @override
  String get offlineSurahDelete => 'Supprimer';

  @override
  String get offlineAudioDeleteAll => 'Supprimer tout l\'audio';

  @override
  String get offlineConfirmTitle => 'Supprimer ces contenus ?';

  @override
  String get offlineConfirmBody =>
      'Tu pourras les télécharger de nouveau. Ils seront aussi récupérés à la demande, quand tu auras internet.';

  @override
  String get offlineConfirmYes => 'Supprimer';

  @override
  String get offlineConfirmNo => 'Annuler';

  @override
  String get profileTitle => 'Profil et réglages';

  @override
  String get profileNameLabel => 'Prénom';

  @override
  String get profileNameHint => 'Comment veux-tu qu\'on t\'appelle ?';

  @override
  String get profileNameEmpty => 'Non renseigné';

  @override
  String get profileNameSave => 'Enregistrer';

  @override
  String get profileLevel => 'Niveau';

  @override
  String get levelBeginner => 'Débutant';

  @override
  String get levelOngoing => 'En cours de mémorisation';

  @override
  String get levelHafiz => 'Hafiz';

  @override
  String get planTitle => 'Plan d\'étude';

  @override
  String get planMinutes => 'Temps par jour';

  @override
  String planMinutesValue(int n) {
    return '$n min';
  }

  @override
  String get planDays => 'Jours disponibles';

  @override
  String get planDaysNeedOne => 'Garde au moins un jour disponible.';

  @override
  String get planExplain =>
      'Ton plan règle tes objectifs, ton rappel et ta série : un jour où tu n\'es pas disponible ne la casse jamais.';

  @override
  String get readingTitle => 'Lecture';

  @override
  String get readingMode => 'Affichage du texte';

  @override
  String get readingModeArabic => 'Arabe';

  @override
  String get readingModeTranslit => 'Translit.';

  @override
  String get readingModeBilingual => 'Bilingue';

  @override
  String get readingScale => 'Taille du texte';

  @override
  String get audioSectionTitle => 'Audio';

  @override
  String get audioReciter => 'Récitant';

  @override
  String get audioSpeed => 'Vitesse par défaut';

  @override
  String get offlineTileSubtitle => 'Mushaf et audio sans connexion';

  @override
  String offlineMushafEstimate(String size) {
    return 'Environ $size restent à télécharger. Préfère le Wi-Fi.';
  }

  @override
  String get offlineMushafWifi =>
      'Cela peut représenter plusieurs centaines de Mo : préfère le Wi-Fi.';
}
