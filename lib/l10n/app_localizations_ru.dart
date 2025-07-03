// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get selectLanguage => 'Выберите язык';

  @override
  String get appTitle => 'Тренажёр реакции';

  @override
  String get startTraining => 'Начать тренировку';

  @override
  String get trainingSettings => 'Настройки тренировки';

  @override
  String get intervalBetweenSignals => 'Интервал между сигналами';

  @override
  String get selectElements => 'Выберите элементы';

  @override
  String get voiceAndLanguage => 'Голос и язык';

  @override
  String get finishTraining => 'Завершить тренировку';
}
