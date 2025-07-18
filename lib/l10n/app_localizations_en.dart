// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn() : super('en');

  @override String get selectLanguage => 'Select Language';
  @override String get appTitle => 'Reaction Trainer';
  @override String get startTraining => 'Start Training';
  @override String get trainingSettings => 'Theme Selection';
  @override String get intervalBetweenSignals => 'Interval Between Signals';
  @override String get selectElements => 'Select Elements';
  @override String get voiceAndLanguage => 'Voice and Language';
  @override String get finishTraining => 'Finish Training';
  @override String get noVoicesFound => 'No Voices Found';
  @override String get errorLoadingVoices => 'Error Loading Voices';
  @override String get errorSettingVoice => 'Error Setting Voice';
  @override String get errorSpeaking => 'Error Speaking';
  @override String get voiceSelection => 'Voice Selection';
  @override String get lightTheme => 'Light Theme';
  @override String get darkTheme => 'Dark Theme';
  @override String get systemTheme => 'System Theme';
}