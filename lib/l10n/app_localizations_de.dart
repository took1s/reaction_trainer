// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get appTitle => 'Reaktionstrainer';

  @override
  String get startTraining => 'Training starten';

  @override
  String get trainingSettings => 'Trainingseinstellungen';

  @override
  String get intervalBetweenSignals => 'Intervall zwischen Signalen';

  @override
  String get selectElements => 'Elemente auswählen';

  @override
  String get voiceAndLanguage => 'Stimme und Sprache';

  @override
  String get finishTraining => 'Training beenden';
}
