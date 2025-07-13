// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe() : super('de');

  @override String get selectLanguage => 'Sprache auswählen';
  @override String get appTitle => 'Reaktions-Trainer';
  @override String get startTraining => 'Training starten';
  @override String get trainingSettings => 'Themenwahl';
  @override String get intervalBetweenSignals => 'Intervall zwischen Signalen';
  @override String get selectElements => 'Elemente auswählen';
  @override String get voiceAndLanguage => 'Sprache und Stimme';
  @override String get finishTraining => 'Training beenden';
  @override String get noVoicesFound => 'Keine Stimmen gefunden';
  @override String get errorLoadingVoices => 'Fehler beim Laden der Stimmen';
  @override String get errorSettingVoice => 'Fehler beim Einstellen der Stimme';
  @override String get errorSpeaking => 'Fehler beim Sprechen';
  @override String get voiceSelection => 'Stimme auswählen';
  @override String get lightTheme => 'Helle Theme';
  @override String get darkTheme => 'Dunkle Theme';
  @override String get systemTheme => 'System Theme';
}
