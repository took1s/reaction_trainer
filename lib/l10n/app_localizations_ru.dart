// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu() : super('ru');

  @override String get selectLanguage => 'Выберите язык';
  @override String get appTitle => 'Тренажёр реакции';
  @override String get startTraining => 'Начать тренировку';
  @override String get trainingSettings => 'Выбор темы';
  @override String get intervalBetweenSignals => 'Интервал между сигналами';
  @override String get selectElements => 'Выберите элементы';
  @override String get voiceAndLanguage => 'Язык и голос';
  @override String get finishTraining => 'Завершить тренировку';
  @override String get noVoicesFound => 'Голоса не найдены';
  @override String get errorLoadingVoices => 'Ошибка загрузки голосов';
  @override String get errorSettingVoice => 'Ошибка установки голоса';
  @override String get errorSpeaking => 'Ошибка воспроизведения голоса';
  @override String get voiceSelection => 'Выберите голос';
  @override String get lightTheme => 'Светлая тема';
  @override String get darkTheme => 'Темная тема';
  @override String get systemTheme => 'Системная тема';
}