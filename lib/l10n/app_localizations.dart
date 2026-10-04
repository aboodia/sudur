import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('fr')];

  /// Tooltip for the close button on the first step of the guided memorization flow (no previous step to go back to).
  ///
  /// In fr, this message translates to:
  /// **'Quitter (la progression est sauvegardée)'**
  String get sessionQuitTooltip;

  /// Tooltip for the back button on steps 2-5 of the guided memorization flow.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'étape précédente'**
  String get sessionBackTooltip;

  /// Header subtitle of a guided memorization step, e.g. 'Étape 1 sur 5 · Découvrir'.
  ///
  /// In fr, this message translates to:
  /// **'Étape {step} sur {total} · {name}'**
  String stepOfTotal(int step, int total, String name);

  /// No description provided for @discoverTitle.
  ///
  /// In fr, this message translates to:
  /// **'Écoute le passage en entier'**
  String get discoverTitle;

  /// No description provided for @discoverSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Suis le texte des yeux, sans chercher à retenir. Tu prends simplement contact avec les versets.'**
  String get discoverSubtitle;

  /// No description provided for @listeningToAyah.
  ///
  /// In fr, this message translates to:
  /// **'Verset {ayah} en lecture'**
  String listeningToAyah(int ayah);

  /// No description provided for @readyAtAyah.
  ///
  /// In fr, this message translates to:
  /// **'Verset {ayah}'**
  String readyAtAyah(int ayah);

  /// No description provided for @finishedListening.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai écouté le passage'**
  String get finishedListening;

  /// No description provided for @listenAgain.
  ///
  /// In fr, this message translates to:
  /// **'Écouter une seconde fois'**
  String get listenAgain;

  /// No description provided for @verseOfTotal.
  ///
  /// In fr, this message translates to:
  /// **'Verset {n} sur {total}'**
  String verseOfTotal(int n, int total);

  /// No description provided for @repeatAloudBadge.
  ///
  /// In fr, this message translates to:
  /// **'Répète à voix haute'**
  String get repeatAloudBadge;

  /// No description provided for @listenXOfY.
  ///
  /// In fr, this message translates to:
  /// **'Écoute {x} sur {y} · puis répète'**
  String listenXOfY(int x, int y);

  /// No description provided for @noHesitation.
  ///
  /// In fr, this message translates to:
  /// **'Je le répète sans hésiter'**
  String get noHesitation;

  /// No description provided for @maskInstructions.
  ///
  /// In fr, this message translates to:
  /// **'Récite en complétant les mots masqués. Touche un mot pour le révéler.'**
  String get maskInstructions;

  /// No description provided for @levelLight.
  ///
  /// In fr, this message translates to:
  /// **'Léger'**
  String get levelLight;

  /// No description provided for @levelMedium.
  ///
  /// In fr, this message translates to:
  /// **'Moyen'**
  String get levelMedium;

  /// No description provided for @levelFull.
  ///
  /// In fr, this message translates to:
  /// **'Complet'**
  String get levelFull;

  /// No description provided for @noWordRevealedYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucun mot révélé pour l\'instant. Prends ton temps.'**
  String get noWordRevealedYet;

  /// No description provided for @someWordsRevealed.
  ///
  /// In fr, this message translates to:
  /// **'{n} mot(s) révélé(s) — ils seront à surveiller à la révision.'**
  String someWordsRevealed(int n);

  /// No description provided for @restartStep.
  ///
  /// In fr, this message translates to:
  /// **'Recommencer'**
  String get restartStep;

  /// No description provided for @iKnowIt.
  ///
  /// In fr, this message translates to:
  /// **'Je le connais'**
  String get iKnowIt;

  /// No description provided for @reciteVerseNoHelp.
  ///
  /// In fr, this message translates to:
  /// **'Récite le verset {n} sans aide'**
  String reciteVerseNoHelp(int n);

  /// No description provided for @reciteInstructions.
  ///
  /// In fr, this message translates to:
  /// **'Seul le premier mot reste visible. Récite, puis vérifie.'**
  String get reciteInstructions;

  /// No description provided for @showVerse.
  ///
  /// In fr, this message translates to:
  /// **'Afficher le verset'**
  String get showVerse;

  /// No description provided for @hideVerse.
  ///
  /// In fr, this message translates to:
  /// **'Masquer le verset'**
  String get hideVerse;

  /// No description provided for @howWasRecitation.
  ///
  /// In fr, this message translates to:
  /// **'Comment s\'est passée ta récitation ?'**
  String get howWasRecitation;

  /// No description provided for @outcomeClean.
  ///
  /// In fr, this message translates to:
  /// **'Sans erreur'**
  String get outcomeClean;

  /// No description provided for @outcomeCleanSub.
  ///
  /// In fr, this message translates to:
  /// **'Verset validé'**
  String get outcomeCleanSub;

  /// No description provided for @outcomeHesitant.
  ///
  /// In fr, this message translates to:
  /// **'Quelques hésitations'**
  String get outcomeHesitant;

  /// No description provided for @outcomeHesitantSub.
  ///
  /// In fr, this message translates to:
  /// **'Validé, revu plus tôt'**
  String get outcomeHesitantSub;

  /// No description provided for @outcomeRedo.
  ///
  /// In fr, this message translates to:
  /// **'À reprendre'**
  String get outcomeRedo;

  /// No description provided for @outcomeRedoSub.
  ///
  /// In fr, this message translates to:
  /// **'On le repasse au masquage'**
  String get outcomeRedoSub;

  /// No description provided for @continueLabel.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get continueLabel;

  /// No description provided for @chainTitle.
  ///
  /// In fr, this message translates to:
  /// **'Récite le passage d\'un seul tenant'**
  String get chainTitle;

  /// No description provided for @chainSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Relie les versets entre eux : c\'est ce qui fixe le passage dans la mémoire.'**
  String get chainSubtitle;

  /// No description provided for @chainVerseLabel.
  ///
  /// In fr, this message translates to:
  /// **'Verset {n}'**
  String chainVerseLabel(int n);

  /// No description provided for @chainStatusValidated.
  ///
  /// In fr, this message translates to:
  /// **'Sans erreur'**
  String get chainStatusValidated;

  /// No description provided for @chainStatusHesitant.
  ///
  /// In fr, this message translates to:
  /// **'1 hésitation'**
  String get chainStatusHesitant;

  /// No description provided for @chainStatusCurrent.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get chainStatusCurrent;

  /// No description provided for @finishPassageButton.
  ///
  /// In fr, this message translates to:
  /// **'Terminer le passage'**
  String get finishPassageButton;

  /// No description provided for @passageMemorizedBadge.
  ///
  /// In fr, this message translates to:
  /// **'PASSAGE MÉMORISÉ'**
  String get passageMemorizedBadge;

  /// No description provided for @passageMemorizedTitle.
  ///
  /// In fr, this message translates to:
  /// **'{surah}, versets {start} à {end}'**
  String passageMemorizedTitle(String surah, int start, int end);

  /// No description provided for @passageMemorizedTitleSingle.
  ///
  /// In fr, this message translates to:
  /// **'{surah}, verset {start}'**
  String passageMemorizedTitleSingle(String surah, int start);

  /// No description provided for @barakAllahuFik.
  ///
  /// In fr, this message translates to:
  /// **'بارك الله فيك'**
  String get barakAllahuFik;

  /// No description provided for @passageMemorizedSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ces versets sont maintenant dans ton cœur. La révision va les y ancrer durablement.'**
  String get passageMemorizedSubtitle;

  /// No description provided for @statVerses.
  ///
  /// In fr, this message translates to:
  /// **'{n} verset(s)'**
  String statVerses(int n);

  /// No description provided for @statDuration.
  ///
  /// In fr, this message translates to:
  /// **'{min} min de pratique'**
  String statDuration(int min);

  /// No description provided for @statToWatch.
  ///
  /// In fr, this message translates to:
  /// **'{n} verset(s) à surveiller'**
  String statToWatch(int n);

  /// No description provided for @reviewCycleTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ton cycle de révision'**
  String get reviewCycleTitle;

  /// No description provided for @reviewCycleTomorrow.
  ///
  /// In fr, this message translates to:
  /// **'Demain'**
  String get reviewCycleTomorrow;

  /// No description provided for @surahProgressLabel.
  ///
  /// In fr, this message translates to:
  /// **'Sourate {name}'**
  String surahProgressLabel(String name);

  /// No description provided for @surahProgressCount.
  ///
  /// In fr, this message translates to:
  /// **'{n} / {total} versets'**
  String surahProgressCount(int n, int total);

  /// No description provided for @surahProgressRemaining.
  ///
  /// In fr, this message translates to:
  /// **'Encore {n} verset(s) pour compléter la sourate : elle comptera pour ton prochain badge.'**
  String surahProgressRemaining(int n);

  /// No description provided for @surahAlreadyComplete.
  ///
  /// In fr, this message translates to:
  /// **'Sourate complète, mabrouk !'**
  String get surahAlreadyComplete;

  /// No description provided for @backToHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get backToHome;

  /// No description provided for @replayPassage.
  ///
  /// In fr, this message translates to:
  /// **'Réécouter le passage'**
  String get replayPassage;

  /// No description provided for @greeting.
  ///
  /// In fr, this message translates to:
  /// **'Assalamu alaykum'**
  String get greeting;

  /// No description provided for @todaysSessionLabel.
  ///
  /// In fr, this message translates to:
  /// **'SESSION DU JOUR · MÉMORISATION'**
  String get todaysSessionLabel;

  /// No description provided for @estimatedDuration.
  ///
  /// In fr, this message translates to:
  /// **'≈ {min} min'**
  String estimatedDuration(int min);

  /// No description provided for @surahVersesLabel.
  ///
  /// In fr, this message translates to:
  /// **'Sourate {surah} · versets {start} à {end}'**
  String surahVersesLabel(int surah, int start, int end);

  /// No description provided for @surahVerseLabelSingle.
  ///
  /// In fr, this message translates to:
  /// **'Sourate {surah} · verset {start}'**
  String surahVerseLabelSingle(int surah, int start);

  /// No description provided for @startSession.
  ///
  /// In fr, this message translates to:
  /// **'Commencer la session'**
  String get startSession;

  /// No description provided for @alsoToday.
  ///
  /// In fr, this message translates to:
  /// **'AUSSI AUJOURD\'HUI'**
  String get alsoToday;

  /// No description provided for @reviewDueToday.
  ///
  /// In fr, this message translates to:
  /// **'{n} verset(s) à réviser aujourd\'hui'**
  String reviewDueToday(int n);

  /// No description provided for @allMemorizedCongrats.
  ///
  /// In fr, this message translates to:
  /// **'Tout le Coran est mémorisé, mabrouk !'**
  String get allMemorizedCongrats;

  /// No description provided for @profileRemaining.
  ///
  /// In fr, this message translates to:
  /// **'{n} sourate(s) restante(s) pour {nextName}'**
  String profileRemaining(int n, String nextName);

  /// No description provided for @profileMaxed.
  ///
  /// In fr, this message translates to:
  /// **'Le sommet est atteint, mabrouk !'**
  String get profileMaxed;

  /// No description provided for @revisionHubTitle.
  ///
  /// In fr, this message translates to:
  /// **'Révision'**
  String get revisionHubTitle;

  /// No description provided for @revisionTodayLabel.
  ///
  /// In fr, this message translates to:
  /// **'RÉVISION DU JOUR'**
  String get revisionTodayLabel;

  /// No description provided for @revisionStart.
  ///
  /// In fr, this message translates to:
  /// **'Commencer la révision'**
  String get revisionStart;

  /// No description provided for @revisionUpToDateTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tu es à jour'**
  String get revisionUpToDateTitle;

  /// No description provided for @revisionUpToDateSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Rien à réviser aujourd\'hui.'**
  String get revisionUpToDateSubtitle;

  /// No description provided for @revisionNextDue.
  ///
  /// In fr, this message translates to:
  /// **'Prochaine révision : {date}'**
  String revisionNextDue(String date);

  /// No description provided for @revisionNothingYet.
  ///
  /// In fr, this message translates to:
  /// **'Tes révisions apparaîtront ici dès que tu auras mémorisé ton premier passage.'**
  String get revisionNothingYet;

  /// No description provided for @revisionCalendarTitle.
  ///
  /// In fr, this message translates to:
  /// **'Calendrier'**
  String get revisionCalendarTitle;

  /// No description provided for @revisionViewDay.
  ///
  /// In fr, this message translates to:
  /// **'Jour'**
  String get revisionViewDay;

  /// No description provided for @revisionViewWeek.
  ///
  /// In fr, this message translates to:
  /// **'Semaine'**
  String get revisionViewWeek;

  /// No description provided for @revisionViewMonth.
  ///
  /// In fr, this message translates to:
  /// **'Mois'**
  String get revisionViewMonth;

  /// No description provided for @revisionNothingThatDay.
  ///
  /// In fr, this message translates to:
  /// **'Rien de prévu ce jour-là.'**
  String get revisionNothingThatDay;

  /// No description provided for @revisionPassageRange.
  ///
  /// In fr, this message translates to:
  /// **'{surah} · versets {start} à {end}'**
  String revisionPassageRange(String surah, int start, int end);

  /// No description provided for @revisionPassageSingle.
  ///
  /// In fr, this message translates to:
  /// **'{surah} · verset {start}'**
  String revisionPassageSingle(String surah, int start);

  /// No description provided for @revisionPreviousMonth.
  ///
  /// In fr, this message translates to:
  /// **'Mois précédent'**
  String get revisionPreviousMonth;

  /// No description provided for @revisionNextMonth.
  ///
  /// In fr, this message translates to:
  /// **'Mois suivant'**
  String get revisionNextMonth;

  /// No description provided for @revisionMasteryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ta maîtrise'**
  String get revisionMasteryTitle;

  /// No description provided for @revisionMasteryHint.
  ///
  /// In fr, this message translates to:
  /// **'Calculée d\'après tes auto-évaluations : plus un verset est récité sans erreur, plus il devient solide.'**
  String get revisionMasteryHint;

  /// No description provided for @masteryWeak.
  ///
  /// In fr, this message translates to:
  /// **'Faible'**
  String get masteryWeak;

  /// No description provided for @masteryMedium.
  ///
  /// In fr, this message translates to:
  /// **'Moyen'**
  String get masteryMedium;

  /// No description provided for @masterySolid.
  ///
  /// In fr, this message translates to:
  /// **'Solide'**
  String get masterySolid;

  /// No description provided for @revisionQuitTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Quitter (ce que tu as déjà révisé est enregistré)'**
  String get revisionQuitTooltip;

  /// No description provided for @revisionDoneTitle.
  ///
  /// In fr, this message translates to:
  /// **'Révision terminée'**
  String get revisionDoneTitle;

  /// No description provided for @revisionDoneAllClean.
  ///
  /// In fr, this message translates to:
  /// **'Belle récitation, mabrouk ! Tout est bien en place.'**
  String get revisionDoneAllClean;

  /// No description provided for @revisionDoneEncourage.
  ///
  /// In fr, this message translates to:
  /// **'Chaque révision ancre un peu plus : les versets hésitants reviendront bientôt pour mieux se fixer.'**
  String get revisionDoneEncourage;

  /// No description provided for @revisionResultLine.
  ///
  /// In fr, this message translates to:
  /// **'{label} · {n}'**
  String revisionResultLine(String label, int n);

  /// No description provided for @revisionRemaining.
  ///
  /// In fr, this message translates to:
  /// **'Il t\'en reste {n} verset(s) à réviser aujourd\'hui.'**
  String revisionRemaining(int n);

  /// No description provided for @revisionReviseMore.
  ///
  /// In fr, this message translates to:
  /// **'Réviser encore'**
  String get revisionReviseMore;

  /// No description provided for @revisionBack.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get revisionBack;

  /// No description provided for @statsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques de progression'**
  String get statsTitle;

  /// No description provided for @statsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ton évolution dans la mémorisation'**
  String get statsSubtitle;

  /// No description provided for @statsTileVerses.
  ///
  /// In fr, this message translates to:
  /// **'Versets'**
  String get statsTileVerses;

  /// No description provided for @statsTileSurahs.
  ///
  /// In fr, this message translates to:
  /// **'Sourates'**
  String get statsTileSurahs;

  /// No description provided for @statsTileJuz.
  ///
  /// In fr, this message translates to:
  /// **'Juz'**
  String get statsTileJuz;

  /// No description provided for @statsTileRetention.
  ///
  /// In fr, this message translates to:
  /// **'Rétention'**
  String get statsTileRetention;

  /// No description provided for @statsTileStreak.
  ///
  /// In fr, this message translates to:
  /// **'Série'**
  String get statsTileStreak;

  /// No description provided for @statsTileTime.
  ///
  /// In fr, this message translates to:
  /// **'Temps total'**
  String get statsTileTime;

  /// No description provided for @statsCaptionMemorized.
  ///
  /// In fr, this message translates to:
  /// **'mémorisés'**
  String get statsCaptionMemorized;

  /// No description provided for @statsCaptionCompleted.
  ///
  /// In fr, this message translates to:
  /// **'achevées'**
  String get statsCaptionCompleted;

  /// No description provided for @statsCaptionOutOf30.
  ///
  /// In fr, this message translates to:
  /// **'sur 30'**
  String get statsCaptionOutOf30;

  /// No description provided for @statsCaptionRetention.
  ///
  /// In fr, this message translates to:
  /// **'sur 30 jours'**
  String get statsCaptionRetention;

  /// No description provided for @statsCaptionRetentionNone.
  ///
  /// In fr, this message translates to:
  /// **'pas encore de révision'**
  String get statsCaptionRetentionNone;

  /// No description provided for @statsCaptionStreak.
  ///
  /// In fr, this message translates to:
  /// **'assiduité'**
  String get statsCaptionStreak;

  /// No description provided for @statsCaptionTime.
  ///
  /// In fr, this message translates to:
  /// **'dédié au Coran'**
  String get statsCaptionTime;

  /// No description provided for @statsDays.
  ///
  /// In fr, this message translates to:
  /// **'{n} j'**
  String statsDays(int n);

  /// No description provided for @statsPercent.
  ///
  /// In fr, this message translates to:
  /// **'{n} %'**
  String statsPercent(int n);

  /// No description provided for @pathTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le Chemin'**
  String get pathTitle;

  /// No description provided for @pathSummaryTitle.
  ///
  /// In fr, this message translates to:
  /// **'{done} sourate(s) sur {total}'**
  String pathSummaryTitle(int done, int total);

  /// No description provided for @pathNextStep.
  ///
  /// In fr, this message translates to:
  /// **'Prochaine étape : {surah}'**
  String pathNextStep(String surah);

  /// No description provided for @pathContinue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get pathContinue;

  /// No description provided for @pathAllDone.
  ///
  /// In fr, this message translates to:
  /// **'Tout le chemin est parcouru, mabrouk !'**
  String get pathAllDone;

  /// No description provided for @milestoneCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Achevée'**
  String get milestoneCompleted;

  /// No description provided for @milestoneCurrent.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get milestoneCurrent;

  /// No description provided for @milestoneLocked.
  ///
  /// In fr, this message translates to:
  /// **'À venir'**
  String get milestoneLocked;

  /// No description provided for @milestoneVersesAndType.
  ///
  /// In fr, this message translates to:
  /// **'{n} verset(s) · {type}'**
  String milestoneVersesAndType(int n, String type);

  /// No description provided for @revelationMeccan.
  ///
  /// In fr, this message translates to:
  /// **'Mecquoise'**
  String get revelationMeccan;

  /// No description provided for @revelationMedinan.
  ///
  /// In fr, this message translates to:
  /// **'Médinoise'**
  String get revelationMedinan;

  /// No description provided for @milestoneCompletedOn.
  ///
  /// In fr, this message translates to:
  /// **'Achevée le {date}'**
  String milestoneCompletedOn(String date);

  /// No description provided for @milestoneAlreadyKnown.
  ///
  /// In fr, this message translates to:
  /// **'Déjà mémorisée avant ton arrivée dans l\'application.'**
  String get milestoneAlreadyKnown;

  /// No description provided for @milestoneLocksHint.
  ///
  /// In fr, this message translates to:
  /// **'Elle s\'ouvrira sur ton chemin après les sourates qui la précèdent.'**
  String get milestoneLocksHint;

  /// No description provided for @milestoneRead.
  ///
  /// In fr, this message translates to:
  /// **'Lire la sourate'**
  String get milestoneRead;

  /// No description provided for @milestoneContinue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer la mémorisation'**
  String get milestoneContinue;

  /// No description provided for @milestoneSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Sourate {number}, {name}, {state}'**
  String milestoneSemantics(int number, String name, String state);

  /// No description provided for @storyUnlockedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Histoire débloquée'**
  String get storyUnlockedTitle;

  /// No description provided for @storyComingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Le récit de cette sourate sera ajouté une fois son contenu validé.'**
  String get storyComingSoon;

  /// No description provided for @storySource.
  ///
  /// In fr, this message translates to:
  /// **'Source : {source}'**
  String storySource(String source);

  /// No description provided for @storyOpen.
  ///
  /// In fr, this message translates to:
  /// **'Voir l\'histoire'**
  String get storyOpen;

  /// No description provided for @pathTabTrace.
  ///
  /// In fr, this message translates to:
  /// **'Tracé'**
  String get pathTabTrace;

  /// No description provided for @pathTabFollowUp.
  ///
  /// In fr, this message translates to:
  /// **'Suivi'**
  String get pathTabFollowUp;

  /// No description provided for @curveTitle.
  ///
  /// In fr, this message translates to:
  /// **'Courbe de progression'**
  String get curveTitle;

  /// No description provided for @curvePeriod30.
  ///
  /// In fr, this message translates to:
  /// **'30 j'**
  String get curvePeriod30;

  /// No description provided for @curvePeriod90.
  ///
  /// In fr, this message translates to:
  /// **'90 j'**
  String get curvePeriod90;

  /// No description provided for @curvePeriodAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout'**
  String get curvePeriodAll;

  /// No description provided for @curveGain.
  ///
  /// In fr, this message translates to:
  /// **'+{n} verset(s) sur la période'**
  String curveGain(int n);

  /// No description provided for @curveNoGain.
  ///
  /// In fr, this message translates to:
  /// **'Pas de nouveau verset sur la période.'**
  String get curveNoGain;

  /// No description provided for @curveEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Ta courbe commencera avec ton premier passage mémorisé.'**
  String get curveEmpty;

  /// No description provided for @curveSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Versets mémorisés : {from} au début de la période, {to} aujourd\'hui'**
  String curveSemantics(int from, int to);

  /// No description provided for @mapTitle.
  ///
  /// In fr, this message translates to:
  /// **'Carte du Mushaf'**
  String get mapTitle;

  /// No description provided for @mapSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Chaque case est une page des 604 du Mushaf.'**
  String get mapSubtitle;

  /// No description provided for @mapSummary.
  ///
  /// In fr, this message translates to:
  /// **'{full} page(s) complète(s) · {partial} entamée(s) · {total} au total'**
  String mapSummary(int full, int partial, int total);

  /// No description provided for @mapLegendNone.
  ///
  /// In fr, this message translates to:
  /// **'Pas commencée'**
  String get mapLegendNone;

  /// No description provided for @mapLegendPartial.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get mapLegendPartial;

  /// No description provided for @mapLegendFull.
  ///
  /// In fr, this message translates to:
  /// **'Complète'**
  String get mapLegendFull;

  /// No description provided for @historyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Ton historique apparaîtra ici dès ta première session.'**
  String get historyEmpty;

  /// No description provided for @historyKindMemorization.
  ///
  /// In fr, this message translates to:
  /// **'Mémorisation'**
  String get historyKindMemorization;

  /// No description provided for @historyKindRevision.
  ///
  /// In fr, this message translates to:
  /// **'Révision'**
  String get historyKindRevision;

  /// No description provided for @historyLine.
  ///
  /// In fr, this message translates to:
  /// **'{kind} · {n} verset(s)'**
  String historyLine(String kind, int n);

  /// No description provided for @historyDetail.
  ///
  /// In fr, this message translates to:
  /// **'{when} · {min} min'**
  String historyDetail(String when, int min);

  /// No description provided for @goalsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Objectifs'**
  String get goalsTitle;

  /// No description provided for @goalsEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get goalsEdit;

  /// No description provided for @goalWeekTitle.
  ///
  /// In fr, this message translates to:
  /// **'Cette semaine'**
  String get goalWeekTitle;

  /// No description provided for @goalMonthTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ce mois-ci'**
  String get goalMonthTitle;

  /// No description provided for @goalCount.
  ///
  /// In fr, this message translates to:
  /// **'{done} / {goal} versets'**
  String goalCount(int done, int goal);

  /// No description provided for @goalRemaining.
  ///
  /// In fr, this message translates to:
  /// **'Encore {n} verset(s) : environ {perDay} par jour.'**
  String goalRemaining(int n, int perDay);

  /// No description provided for @goalReached.
  ///
  /// In fr, this message translates to:
  /// **'Objectif atteint, mabrouk !'**
  String get goalReached;

  /// No description provided for @goalAhead.
  ///
  /// In fr, this message translates to:
  /// **'Tu es en avance sur ton rythme.'**
  String get goalAhead;

  /// No description provided for @goalSuggested.
  ///
  /// In fr, this message translates to:
  /// **'Proposé d\'après ton temps quotidien.'**
  String get goalSuggested;

  /// No description provided for @goalSemantics.
  ///
  /// In fr, this message translates to:
  /// **'{title} : {done} versets sur {goal}'**
  String goalSemantics(String title, int done, int goal);

  /// No description provided for @goalEditTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tes objectifs'**
  String get goalEditTitle;

  /// No description provided for @goalEditHint.
  ///
  /// In fr, this message translates to:
  /// **'Un objectif doux et tenable vaut mieux qu\'un objectif ambitieux abandonné.'**
  String get goalEditHint;

  /// No description provided for @goalEditWeekly.
  ///
  /// In fr, this message translates to:
  /// **'Par semaine'**
  String get goalEditWeekly;

  /// No description provided for @goalEditMonthly.
  ///
  /// In fr, this message translates to:
  /// **'Par mois'**
  String get goalEditMonthly;

  /// No description provided for @goalEditReset.
  ///
  /// In fr, this message translates to:
  /// **'Revenir aux valeurs proposées'**
  String get goalEditReset;

  /// No description provided for @goalEditSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get goalEditSave;

  /// No description provided for @goalEditDecrease.
  ///
  /// In fr, this message translates to:
  /// **'Diminuer'**
  String get goalEditDecrease;

  /// No description provided for @goalEditIncrease.
  ///
  /// In fr, this message translates to:
  /// **'Augmenter'**
  String get goalEditIncrease;

  /// No description provided for @successTitle.
  ///
  /// In fr, this message translates to:
  /// **'Régularité et succès'**
  String get successTitle;

  /// No description provided for @streakTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ta régularité'**
  String get streakTitle;

  /// No description provided for @streakCurrent.
  ///
  /// In fr, this message translates to:
  /// **'{n} jour(s) de suite'**
  String streakCurrent(int n);

  /// No description provided for @streakBest.
  ///
  /// In fr, this message translates to:
  /// **'Meilleure série : {n} j'**
  String streakBest(int n);

  /// No description provided for @streakNone.
  ///
  /// In fr, this message translates to:
  /// **'Ta série commence avec ta prochaine session.'**
  String get streakNone;

  /// No description provided for @streakDoneToday.
  ///
  /// In fr, this message translates to:
  /// **'C\'est fait pour aujourd\'hui, bravo.'**
  String get streakDoneToday;

  /// No description provided for @streakAtRisk.
  ///
  /// In fr, this message translates to:
  /// **'Ta série est en jeu aujourd\'hui : même 5 minutes suffisent.'**
  String get streakAtRisk;

  /// No description provided for @streakJokersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Jokers'**
  String get streakJokersTitle;

  /// No description provided for @streakJokersLeft.
  ///
  /// In fr, this message translates to:
  /// **'{n} joker(s) en réserve'**
  String streakJokersLeft(int n);

  /// No description provided for @streakJokerExplain.
  ///
  /// In fr, this message translates to:
  /// **'Un joker garde ta série en vie quand tu manques un jour. Tu en gagnes un tous les 7 jours de régularité, et tu peux en garder 2.'**
  String get streakJokerExplain;

  /// No description provided for @streakNextJoker.
  ///
  /// In fr, this message translates to:
  /// **'Prochain joker dans {n} jour(s) d\'étude.'**
  String streakNextJoker(int n);

  /// No description provided for @streakJokerFull.
  ///
  /// In fr, this message translates to:
  /// **'Ta réserve de jokers est pleine.'**
  String get streakJokerFull;

  /// No description provided for @streakCovered.
  ///
  /// In fr, this message translates to:
  /// **'Un joker a protégé ta série le {date}.'**
  String streakCovered(String date);

  /// No description provided for @streakRestDays.
  ///
  /// In fr, this message translates to:
  /// **'Les jours où tu n\'es pas disponible ne cassent jamais ta série.'**
  String get streakRestDays;

  /// No description provided for @badgesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Succès'**
  String get badgesTitle;

  /// No description provided for @badgesCount.
  ///
  /// In fr, this message translates to:
  /// **'{earned} sur {total}'**
  String badgesCount(int earned, int total);

  /// No description provided for @badgeNew.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau'**
  String get badgeNew;

  /// No description provided for @badgeEarnedOn.
  ///
  /// In fr, this message translates to:
  /// **'Obtenu le {date}'**
  String badgeEarnedOn(String date);

  /// No description provided for @badgeProgress.
  ///
  /// In fr, this message translates to:
  /// **'{done} / {target}'**
  String badgeProgress(String done, String target);

  /// No description provided for @achTitleFirstVerse.
  ///
  /// In fr, this message translates to:
  /// **'Premier verset'**
  String get achTitleFirstVerse;

  /// No description provided for @achTitleVerses.
  ///
  /// In fr, this message translates to:
  /// **'{n} versets'**
  String achTitleVerses(int n);

  /// No description provided for @achTitleFirstJuz.
  ///
  /// In fr, this message translates to:
  /// **'Premier Juz'**
  String get achTitleFirstJuz;

  /// No description provided for @achTitleJuz.
  ///
  /// In fr, this message translates to:
  /// **'{n} Juz'**
  String achTitleJuz(int n);

  /// No description provided for @achTitleKhatm.
  ///
  /// In fr, this message translates to:
  /// **'Coran complet'**
  String get achTitleKhatm;

  /// No description provided for @achTitleStreak.
  ///
  /// In fr, this message translates to:
  /// **'{n} jours de régularité'**
  String achTitleStreak(int n);

  /// No description provided for @achDescFirstVerse.
  ///
  /// In fr, this message translates to:
  /// **'Mémoriser ton premier verset.'**
  String get achDescFirstVerse;

  /// No description provided for @achDescVerses.
  ///
  /// In fr, this message translates to:
  /// **'Mémoriser {n} versets.'**
  String achDescVerses(int n);

  /// No description provided for @achDescFirstJuz.
  ///
  /// In fr, this message translates to:
  /// **'Mémoriser un Juz entier.'**
  String get achDescFirstJuz;

  /// No description provided for @achDescJuz.
  ///
  /// In fr, this message translates to:
  /// **'Mémoriser {n} Juz.'**
  String achDescJuz(int n);

  /// No description provided for @achDescKhatm.
  ///
  /// In fr, this message translates to:
  /// **'Mémoriser les 30 Juz du Coran.'**
  String get achDescKhatm;

  /// No description provided for @achDescStreak.
  ///
  /// In fr, this message translates to:
  /// **'Étudier {n} jours de suite.'**
  String achDescStreak(int n);

  /// No description provided for @homeNewBadges.
  ///
  /// In fr, this message translates to:
  /// **'{n} nouveau(x) succès à découvrir'**
  String homeNewBadges(int n);

  /// No description provided for @reminderTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sudur'**
  String get reminderTitle;

  /// No description provided for @reminderBody.
  ///
  /// In fr, this message translates to:
  /// **'C\'est l\'heure de ta session de mémorisation.'**
  String get reminderBody;

  /// No description provided for @reminderBodyComeBack.
  ///
  /// In fr, this message translates to:
  /// **'Ravi de te retrouver quand tu veux : 5 minutes suffisent pour reprendre.'**
  String get reminderBodyComeBack;

  /// No description provided for @reminderSectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rappel quotidien'**
  String get reminderSectionTitle;

  /// No description provided for @reminderSwitch.
  ///
  /// In fr, this message translates to:
  /// **'Me rappeler chaque jour'**
  String get reminderSwitch;

  /// No description provided for @reminderTime.
  ///
  /// In fr, this message translates to:
  /// **'Heure du rappel'**
  String get reminderTime;

  /// No description provided for @reminderExplain.
  ///
  /// In fr, this message translates to:
  /// **'Seulement les jours où tu es disponible, et jamais si tu as déjà étudié.'**
  String get reminderExplain;

  /// No description provided for @reminderPermissionDenied.
  ///
  /// In fr, this message translates to:
  /// **'Les notifications sont désactivées pour Sudur. Autorise-les dans les réglages du téléphone pour recevoir le rappel.'**
  String get reminderPermissionDenied;

  /// No description provided for @offlineTitle.
  ///
  /// In fr, this message translates to:
  /// **'Contenus hors-ligne'**
  String get offlineTitle;

  /// No description provided for @offlineIntro.
  ///
  /// In fr, this message translates to:
  /// **'Le texte arabe, la traduction et la translittération sont déjà dans l\'application. Télécharge ici ce qui demande internet : les pages du Mushaf et l\'audio.'**
  String get offlineIntro;

  /// No description provided for @offlineStorage.
  ///
  /// In fr, this message translates to:
  /// **'Espace utilisé : {size}'**
  String offlineStorage(String size);

  /// No description provided for @offlineMushafTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pages du Mushaf'**
  String get offlineMushafTitle;

  /// No description provided for @offlineMushafCount.
  ///
  /// In fr, this message translates to:
  /// **'{n} pages sur 604 téléchargées'**
  String offlineMushafCount(int n);

  /// No description provided for @offlineMushafDownload.
  ///
  /// In fr, this message translates to:
  /// **'Tout télécharger'**
  String get offlineMushafDownload;

  /// No description provided for @offlineMushafStop.
  ///
  /// In fr, this message translates to:
  /// **'Arrêter'**
  String get offlineMushafStop;

  /// No description provided for @offlineMushafDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer les pages'**
  String get offlineMushafDelete;

  /// No description provided for @offlineProgress.
  ///
  /// In fr, this message translates to:
  /// **'{done} / {total}'**
  String offlineProgress(int done, int total);

  /// No description provided for @offlineFailed.
  ///
  /// In fr, this message translates to:
  /// **'{n} échec(s) : vérifie ta connexion puis réessaie.'**
  String offlineFailed(int n);

  /// No description provided for @offlineAudioTitle.
  ///
  /// In fr, this message translates to:
  /// **'Audio de {reciter}'**
  String offlineAudioTitle(String reciter);

  /// No description provided for @offlineAudioHint.
  ///
  /// In fr, this message translates to:
  /// **'Télécharge les sourates que tu veux écouter sans connexion. Le récitant se change dans les réglages audio.'**
  String get offlineAudioHint;

  /// No description provided for @offlineSurahVerses.
  ///
  /// In fr, this message translates to:
  /// **'{n} / {total} versets'**
  String offlineSurahVerses(int n, int total);

  /// No description provided for @offlineSurahDownload.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger'**
  String get offlineSurahDownload;

  /// No description provided for @offlineSurahDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get offlineSurahDelete;

  /// No description provided for @offlineAudioDeleteAll.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer tout l\'audio'**
  String get offlineAudioDeleteAll;

  /// No description provided for @offlineConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer ces contenus ?'**
  String get offlineConfirmTitle;

  /// No description provided for @offlineConfirmBody.
  ///
  /// In fr, this message translates to:
  /// **'Tu pourras les télécharger de nouveau. Ils seront aussi récupérés à la demande, quand tu auras internet.'**
  String get offlineConfirmBody;

  /// No description provided for @offlineConfirmYes.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get offlineConfirmYes;

  /// No description provided for @offlineConfirmNo.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get offlineConfirmNo;

  /// No description provided for @profileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Profil et réglages'**
  String get profileTitle;

  /// No description provided for @profileNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get profileNameLabel;

  /// No description provided for @profileNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Comment veux-tu qu\'on t\'appelle ?'**
  String get profileNameHint;

  /// No description provided for @profileNameEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Non renseigné'**
  String get profileNameEmpty;

  /// No description provided for @profileNameSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get profileNameSave;

  /// No description provided for @profileLevel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau'**
  String get profileLevel;

  /// No description provided for @levelBeginner.
  ///
  /// In fr, this message translates to:
  /// **'Débutant'**
  String get levelBeginner;

  /// No description provided for @levelOngoing.
  ///
  /// In fr, this message translates to:
  /// **'En cours de mémorisation'**
  String get levelOngoing;

  /// No description provided for @levelHafiz.
  ///
  /// In fr, this message translates to:
  /// **'Hafiz'**
  String get levelHafiz;

  /// No description provided for @planTitle.
  ///
  /// In fr, this message translates to:
  /// **'Plan d\'étude'**
  String get planTitle;

  /// No description provided for @planMinutes.
  ///
  /// In fr, this message translates to:
  /// **'Temps par jour'**
  String get planMinutes;

  /// No description provided for @planMinutesValue.
  ///
  /// In fr, this message translates to:
  /// **'{n} min'**
  String planMinutesValue(int n);

  /// No description provided for @planDays.
  ///
  /// In fr, this message translates to:
  /// **'Jours disponibles'**
  String get planDays;

  /// No description provided for @planDaysNeedOne.
  ///
  /// In fr, this message translates to:
  /// **'Garde au moins un jour disponible.'**
  String get planDaysNeedOne;

  /// No description provided for @planExplain.
  ///
  /// In fr, this message translates to:
  /// **'Ton plan règle tes objectifs, ton rappel et ta série : un jour où tu n\'es pas disponible ne la casse jamais.'**
  String get planExplain;

  /// No description provided for @readingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Lecture'**
  String get readingTitle;

  /// No description provided for @readingMode.
  ///
  /// In fr, this message translates to:
  /// **'Affichage du texte'**
  String get readingMode;

  /// No description provided for @readingModeArabic.
  ///
  /// In fr, this message translates to:
  /// **'Arabe'**
  String get readingModeArabic;

  /// No description provided for @readingModeTranslit.
  ///
  /// In fr, this message translates to:
  /// **'Translit.'**
  String get readingModeTranslit;

  /// No description provided for @readingModeBilingual.
  ///
  /// In fr, this message translates to:
  /// **'Bilingue'**
  String get readingModeBilingual;

  /// No description provided for @readingScale.
  ///
  /// In fr, this message translates to:
  /// **'Taille du texte'**
  String get readingScale;

  /// No description provided for @audioSectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Audio'**
  String get audioSectionTitle;

  /// No description provided for @audioReciter.
  ///
  /// In fr, this message translates to:
  /// **'Récitant'**
  String get audioReciter;

  /// No description provided for @audioSpeed.
  ///
  /// In fr, this message translates to:
  /// **'Vitesse par défaut'**
  String get audioSpeed;

  /// No description provided for @offlineTileSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Mushaf et audio sans connexion'**
  String get offlineTileSubtitle;

  /// No description provided for @offlineMushafEstimate.
  ///
  /// In fr, this message translates to:
  /// **'Environ {size} restent à télécharger. Préfère le Wi-Fi.'**
  String offlineMushafEstimate(String size);

  /// No description provided for @offlineMushafWifi.
  ///
  /// In fr, this message translates to:
  /// **'Cela peut représenter plus de 100 Mo : préfère le Wi-Fi.'**
  String get offlineMushafWifi;

  /// No description provided for @playbackOffline.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de lire cet audio sans connexion. Télécharge-le d\'avance quand tu auras internet.'**
  String get playbackOffline;

  /// No description provided for @playbackOfflineAction.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger'**
  String get playbackOfflineAction;

  /// No description provided for @tooltipPlay.
  ///
  /// In fr, this message translates to:
  /// **'Lecture'**
  String get tooltipPlay;

  /// No description provided for @tooltipPause.
  ///
  /// In fr, this message translates to:
  /// **'Pause'**
  String get tooltipPause;

  /// No description provided for @tooltipPreviousAyah.
  ///
  /// In fr, this message translates to:
  /// **'Verset précédent'**
  String get tooltipPreviousAyah;

  /// No description provided for @tooltipNextAyah.
  ///
  /// In fr, this message translates to:
  /// **'Verset suivant'**
  String get tooltipNextAyah;

  /// No description provided for @tooltipTextSmaller.
  ///
  /// In fr, this message translates to:
  /// **'Réduire le texte'**
  String get tooltipTextSmaller;

  /// No description provided for @tooltipTextLarger.
  ///
  /// In fr, this message translates to:
  /// **'Agrandir le texte'**
  String get tooltipTextLarger;

  /// No description provided for @tooltipBookmarkAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un signet'**
  String get tooltipBookmarkAdd;

  /// No description provided for @tooltipBookmarkRemove.
  ///
  /// In fr, this message translates to:
  /// **'Retirer le signet'**
  String get tooltipBookmarkRemove;

  /// No description provided for @mushafReadAsText.
  ///
  /// In fr, this message translates to:
  /// **'Lire en vue texte'**
  String get mushafReadAsText;

  /// No description provided for @homeReviseVersesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Révision'**
  String get homeReviseVersesTitle;

  /// No description provided for @homeReviseVersesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'{n} verset(s) à réciter aujourd\'hui'**
  String homeReviseVersesSubtitle(int n);

  /// No description provided for @statsCaptionStreakBest.
  ///
  /// In fr, this message translates to:
  /// **'record : {n} j'**
  String statsCaptionStreakBest(int n);

  /// No description provided for @maskNothingToHide.
  ///
  /// In fr, this message translates to:
  /// **'Ce verset est trop court pour être masqué : relis-le bien, puis passe à la suite.'**
  String get maskNothingToHide;

  /// No description provided for @wirdTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon Wird'**
  String get wirdTitle;

  /// No description provided for @wirdIntro.
  ///
  /// In fr, this message translates to:
  /// **'Chaque jour, une part des sourates que tu connais déjà, page après page, en boucle.'**
  String get wirdIntro;

  /// No description provided for @wirdTodayCount.
  ///
  /// In fr, this message translates to:
  /// **'{n} page(s) à lire aujourd\'hui'**
  String wirdTodayCount(int n);

  /// No description provided for @wirdTurn.
  ///
  /// In fr, this message translates to:
  /// **'Tour {n}'**
  String wirdTurn(int n);

  /// No description provided for @wirdProgress.
  ///
  /// In fr, this message translates to:
  /// **'{done} page(s) sur {total} dans ce tour'**
  String wirdProgress(int done, int total);

  /// No description provided for @wirdLoopIn.
  ///
  /// In fr, this message translates to:
  /// **'Un tour complet en {n} jour(s) à ce rythme.'**
  String wirdLoopIn(int n);

  /// No description provided for @wirdPageIn.
  ///
  /// In fr, this message translates to:
  /// **'Page {n} · {surah}'**
  String wirdPageIn(int n, String surah);

  /// No description provided for @wirdGoalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Objectif quotidien'**
  String get wirdGoalTitle;

  /// No description provided for @wirdUnitPages.
  ///
  /// In fr, this message translates to:
  /// **'Pages'**
  String get wirdUnitPages;

  /// No description provided for @wirdUnitJuz.
  ///
  /// In fr, this message translates to:
  /// **'Juz'**
  String get wirdUnitJuz;

  /// No description provided for @wirdGoalPagesValue.
  ///
  /// In fr, this message translates to:
  /// **'{n} page(s) par jour'**
  String wirdGoalPagesValue(int n);

  /// No description provided for @wirdGoalJuzValue.
  ///
  /// In fr, this message translates to:
  /// **'{n} Juz par jour'**
  String wirdGoalJuzValue(int n);

  /// No description provided for @wirdGoalSuggested.
  ///
  /// In fr, this message translates to:
  /// **'C\'est une proposition de départ : règle-la comme tu veux.'**
  String get wirdGoalSuggested;

  /// No description provided for @wirdGoalNoSourates.
  ///
  /// In fr, this message translates to:
  /// **'Le Wird se remplit avec les sourates que tu connais et qui sont bien fixées. Règle déjà ton objectif.'**
  String get wirdGoalNoSourates;

  /// No description provided for @wirdHow.
  ///
  /// In fr, this message translates to:
  /// **'Comment s\'est passée ta lecture de ces pages ?'**
  String get wirdHow;

  /// No description provided for @wirdOutcomeCleanSub.
  ///
  /// In fr, this message translates to:
  /// **'Bien lu, on passe à la suite'**
  String get wirdOutcomeCleanSub;

  /// No description provided for @wirdOutcomeHesitantSub.
  ///
  /// In fr, this message translates to:
  /// **'Lu, on passe à la suite'**
  String get wirdOutcomeHesitantSub;

  /// No description provided for @wirdOutcomeRedoSub.
  ///
  /// In fr, this message translates to:
  /// **'Cette part reste à faire'**
  String get wirdOutcomeRedoSub;

  /// No description provided for @wirdFinish.
  ///
  /// In fr, this message translates to:
  /// **'Terminer ma part'**
  String get wirdFinish;

  /// No description provided for @wirdDoneToday.
  ///
  /// In fr, this message translates to:
  /// **'C\'est fait pour aujourd\'hui, bravo. Ta prochaine part t\'attend demain.'**
  String get wirdDoneToday;

  /// No description provided for @wirdRoundDone.
  ///
  /// In fr, this message translates to:
  /// **'Tour terminé, mabrouk ! Un nouveau tour commence demain.'**
  String get wirdRoundDone;

  /// No description provided for @homeWirdTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon Wird'**
  String get homeWirdTitle;

  /// No description provided for @homeWirdToday.
  ///
  /// In fr, this message translates to:
  /// **'{n} page(s) à lire aujourd\'hui'**
  String homeWirdToday(int n);

  /// No description provided for @homeWirdDone.
  ///
  /// In fr, this message translates to:
  /// **'Faite aujourd\'hui'**
  String get homeWirdDone;

  /// No description provided for @wirdOnboardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ton Wird'**
  String get wirdOnboardTitle;

  /// No description provided for @wirdOnboardBody.
  ///
  /// In fr, this message translates to:
  /// **'Tu connais déjà une partie du Coran. Le Wird te la fait relire chaque jour, en boucle. Combien veux-tu en lire par jour ?'**
  String get wirdOnboardBody;

  /// No description provided for @wirdNext.
  ///
  /// In fr, this message translates to:
  /// **'Prochaine part : page {n}'**
  String wirdNext(int n);

  /// No description provided for @wirdLess.
  ///
  /// In fr, this message translates to:
  /// **'Moins'**
  String get wirdLess;

  /// No description provided for @wirdMore.
  ///
  /// In fr, this message translates to:
  /// **'Plus'**
  String get wirdMore;

  /// No description provided for @wirdSettingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon Wird'**
  String get wirdSettingsTitle;

  /// No description provided for @wirdSettingsHint.
  ///
  /// In fr, this message translates to:
  /// **'Ta lecture quotidienne des sourates déjà apprises.'**
  String get wirdSettingsHint;

  /// No description provided for @profileLevelHint.
  ///
  /// In fr, this message translates to:
  /// **'Défini à ton inscription'**
  String get profileLevelHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
