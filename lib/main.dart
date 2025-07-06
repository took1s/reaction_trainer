import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../l10n/app_localizations.dart'; // Добавьте импорт
import 'language_screen.dart';
import 'screens/TrainingScreen.dart';

void main() => runApp(const ReactionTrainerApp());

class ReactionTrainerApp extends StatefulWidget {
  const ReactionTrainerApp({super.key});

  @override
  _ReactionTrainerAppState createState() => _ReactionTrainerAppState();
}

class _ReactionTrainerAppState extends State<ReactionTrainerApp> {
  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.system;

  void _changeLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  void _changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reaction Trainer',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomeScreen(
        changeLocale: _changeLocale,
        changeTheme: _changeTheme,
        currentThemeMode: _themeMode, // Передаем текущую тему
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Function(Locale) changeLocale;
  final Function(ThemeMode) changeTheme;
  final ThemeMode currentThemeMode; // Добавляем параметр для темы

  const HomeScreen({
    required this.changeLocale,
    required this.changeTheme,
    required this.currentThemeMode,
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<int> intervals = [5, 10, 15, 30, 60];
  int selectedInterval = 5;

  final AudioPlayer audioPlayer = AudioPlayer();
  String selectedLanguage = 'en';
  String? selectedVoice = 'eng-voice';

  final List<String> allItems = [
    'Red', 'Green', 'Blue', 'White', 'Yellow', 'Purple', 'Left', 'Right', 'Forward', 'Backward',
  ];
  List<String> selectedItems = [];

  final Map<String, Map<String, String>> allItemsMap = {
    'Red': {'en': 'Red', 'ru': 'Красный', 'de': 'Rot'},
    'Green': {'en': 'Green', 'ru': 'Зелёный', 'de': 'Grün'},
    'Blue': {'en': 'Blue', 'ru': 'Синий', 'de': 'Blau'},
    'White': {'en': 'White', 'ru': 'Белый', 'de': 'Weiß'},
    'Yellow': {'en': 'Yellow', 'ru': 'Жёлтый', 'de': 'Gelb'},
    'Purple': {'en': 'Purple', 'ru': 'Фиолетовый', 'de': 'Lila'},
    'Left': {'en': 'Left', 'ru': 'Лево', 'de': 'Links'},
    'Right': {'en': 'Right', 'ru': 'Право', 'de': 'Rechts'},
    'Forward': {'en': 'Forward', 'ru': 'Вперёд', 'de': 'Vorwärts'},
    'Backward': {'en': 'Backward', 'ru': 'Назад', 'de': 'Rückwärts'},
  };

  final Map<String, Map<String, Map<String, String>>> audioMap = {
    'Red': {'eng-voice': {'en': 'assets/sounds/red_eng-voice.mp3'}, 'ru-voice': {'ru': 'assets/sounds/red_ru-voice.mp3'}, 'de-voice': {'de': 'assets/sounds/red_de-voice.mp3'}},
    'Green': {'eng-voice': {'en': 'assets/sounds/green_eng-voice.mp3'}, 'ru-voice': {'ru': 'assets/sounds/green_ru-voice.mp3'}, 'de-voice': {'de': 'assets/sounds/green_de-voice.mp3'}},
    'Blue': {'eng-voice': {'en': 'assets/sounds/blue_eng-voice.mp3'}, 'ru-voice': {'ru': 'assets/sounds/blue_ru-voice.mp3'}, 'de-voice': {'de': 'assets/sounds/blue_de-voice.mp3'}},
    'White': {'eng-voice': {'en': 'assets/sounds/white_eng-voice.mp3'}, 'ru-voice': {'ru': 'assets/sounds/white_ru-voice.mp3'}, 'de-voice': {'de': 'assets/sounds/white_de-voice.mp3'}},
    'Yellow': {'eng-voice': {'en': 'assets/sounds/yellow_eng-voice.mp3'}, 'ru-voice': {'ru': 'assets/sounds/yellow_ru-voice.mp3'}, 'de-voice': {'de': 'assets/sounds/yellow_de-voice.mp3'}},
    'Purple': {'eng-voice': {'en': 'assets/sounds/purple_eng-voice.mp3'}, 'ru-voice': {'ru': 'assets/sounds/purple_ru-voice.mp3'}, 'de-voice': {'de': 'assets/sounds/purple_de-voice.mp3'}},
    'Left': {'eng-voice': {'en': 'assets/sounds/left_eng-voice.mp3'}, 'ru-voice': {'ru': 'assets/sounds/left_ru-voice.mp3'}, 'de-voice': {'de': 'assets/sounds/left_de-voice.mp3'}},
    'Right': {'eng-voice': {'en': 'assets/sounds/right_eng-voice.mp3'}, 'ru-voice': {'ru': 'assets/sounds/right_ru-voice.mp3'}, 'de-voice': {'de': 'assets/sounds/right_de-voice.mp3'}},
    'Forward': {'eng-voice': {'en': 'assets/sounds/forward_eng-voice.mp3'}, 'ru-voice': {'ru': 'assets/sounds/forward_ru-voice.mp3'}, 'de-voice': {'de': 'assets/sounds/forward_de-voice.mp3'}},
    'Backward': {'eng-voice': {'en': 'assets/sounds/backward_eng-voice.mp3'}, 'ru-voice': {'ru': 'assets/sounds/backward_ru-voice.mp3'}, 'de-voice': {'de': 'assets/sounds/backward_de-voice.mp3'}},
  };

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void startTraining() {
    if (selectedItems.isEmpty || selectedVoice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.selectElements ??
              'Выберите хотя бы один элемент и голос'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrainingScreen(
          intervalSeconds: selectedInterval,
          items: selectedItems,
          audioPlayer: audioPlayer,
          audioMap: audioMap,
          selectedLanguage: selectedLanguage,
          allItemsMap: allItemsMap,
          selectedVoice: selectedVoice,
        ),
      ),
    );
  }

  Widget buildLanguageDropdown() {
    return DropdownButton<String>(
      value: selectedLanguage,
      hint: Text(AppLocalizations.of(context)?.selectLanguage ?? 'Выберите язык'),
      isExpanded: true,
      items: ['en', 'ru', 'de'].map((lang) {
        return DropdownMenuItem(
          value: lang,
          child: Text(lang == 'en' ? 'English' : lang == 'ru' ? 'Русский' : 'Deutsch'),
        );
      }).toList(),
      onChanged: (lang) {
        if (lang != null) {
          setState(() {
            selectedLanguage = lang;
            widget.changeLocale(Locale(lang));
          });
        }
      },
    );
  }

  Widget buildVoiceDropdown() {
    return DropdownButton<String>(
      value: selectedVoice,
      hint: Text(AppLocalizations.of(context)?.voiceSelection ?? 'Выберите голос'),
      isExpanded: true,
      items: ['eng-voice', 'ru-voice', 'de-voice'].map((voice) {
        return DropdownMenuItem(
          value: voice,
          child: Text(
            voice == 'eng-voice'
                ? 'English Voice'
                : voice == 'ru-voice'
                    ? 'Russian Voice'
                    : 'German Voice',
          ),
        );
      }).toList(),
      onChanged: (voice) {
        if (voice != null) {
          setState(() {
            selectedVoice = voice;
          });
        }
      },
    );
  }

  Widget buildThemeSwitcher() {
    return DropdownButton<ThemeMode>(
      value: widget.currentThemeMode, // Используем переданную тему
      hint: Text(AppLocalizations.of(context)?.trainingSettings ?? 'Тема интерфейса'),
      isExpanded: true,
      items: [
        DropdownMenuItem(
          value: ThemeMode.system,
          child: Text(AppLocalizations.of(context)?.trainingSettings ?? 'Системная'),
        ),
        DropdownMenuItem(
          value: ThemeMode.light,
          child: Text(AppLocalizations.of(context)?.trainingSettings ?? 'Светлая'),
        ),
        DropdownMenuItem(
          value: ThemeMode.dark,
          child: Text(AppLocalizations.of(context)?.trainingSettings ?? 'Темная'),
        ),
      ],
      onChanged: (themeMode) {
        if (themeMode != null) {
          setState(() {
            widget.changeTheme(themeMode);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.appTitle ?? 'Тренажёр реакции - Настройки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LanguageScreen(
                    changeLocale: widget.changeLocale,
                    selectedLanguage: selectedLanguage,
                    updateLanguage: (lang) {
                      setState(() {
                        selectedLanguage = lang;
                      });
                    },
                    selectedVoice: selectedVoice,
                    updateVoice: (voice) {
                      setState(() {
                        selectedVoice = voice;
                      });
                    },
                  ),
                ),
              );
            },
            tooltip: AppLocalizations.of(context)?.selectLanguage ?? 'Выберите язык',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                title: Text(AppLocalizations.of(context)?.intervalBetweenSignals ??
                    'Интервал между сигналами'),
                trailing: DropdownButton<int>(
                  value: selectedInterval,
                  items: intervals
                      .map((sec) => DropdownMenuItem(
                            value: sec,
                            child: Text('$sec сек'),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => selectedInterval = value!),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)?.selectElements ??
                        'Выберите элементы для голосового вывода:'),
                    Wrap(
                      spacing: 10,
                      children: allItems.map((item) {
                        return FilterChip(
                          label: Text(allItemsMap[item]?[selectedLanguage] ?? item),
                          selected: selectedItems.contains(item),
                          onSelected: (val) {
                            setState(() {
                              val ? selectedItems.add(item) : selectedItems.remove(item);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: Text(AppLocalizations.of(context)?.selectLanguage ?? 'Язык интерфейса'),
                subtitle: buildLanguageDropdown(),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: Text(AppLocalizations.of(context)?.voiceSelection ?? 'Голос озвучки'),
                subtitle: buildVoiceDropdown(),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: Text(AppLocalizations.of(context)?.trainingSettings ?? 'Тема интерфейса'),
                subtitle: buildThemeSwitcher(),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: Text(AppLocalizations.of(context)?.startTraining ?? 'Начать тренировку'),
                onPressed: startTraining,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}