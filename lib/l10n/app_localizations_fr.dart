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
}
