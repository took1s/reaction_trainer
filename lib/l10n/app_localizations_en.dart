// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get appTitle => 'Reaction Trainer';

  @override
  String get startTraining => 'Start Training';

  @override
  String get trainingSettings => 'Training Settings';

  @override
  String get intervalBetweenSignals => 'Interval Between Signals';

  @override
  String get selectElements => 'Select Elements';

  @override
  String get voiceAndLanguage => 'Voice and Language';

  @override
  String get finishTraining => 'Finish Training';
}
