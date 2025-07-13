import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../l10n/app_localizations.dart';
import '../settings_screen.dart';
import 'TrainingScreen.dart';

void main() => runApp(const ReactionTrainerApp());

class ReactionTrainerApp extends StatefulWidget {
  const ReactionTrainerApp({super.key});

  @override
  _ReactionTrainerAppState createState() => _ReactionTrainerAppState();
}

class _ReactionTrainerAppState extends State<ReactionTrainerApp> {
  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.system;
  String? _selectedVoice = 'eng-voice';
  String _selectedLanguage = 'en';
  int _selectedInterval = 5;

  void _changeLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
      _selectedLanguage = newLocale.languageCode;
    });
  }

  void _changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  void _updateLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
  }

  void _updateVoice(String? voice) {
    setState(() {
      _selectedVoice = voice;
    });
  }

  void _updateInterval(int interval) {
    setState(() {
      _selectedInterval = interval;
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
        selectedLanguage: _selectedLanguage,
        selectedVoice: _selectedVoice,
        selectedInterval: _selectedInterval,
        updateLanguage: _updateLanguage,
        updateVoice: _updateVoice,
        updateInterval: _updateInterval,
        currentThemeMode: _themeMode,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Function(Locale) changeLocale;
  final Function(ThemeMode) changeTheme;
  final String selectedLanguage;
  final String? selectedVoice;
  final int selectedInterval;
  final Function(String) updateLanguage;
  final Function(String?) updateVoice;
  final Function(int) updateInterval;
  final ThemeMode currentThemeMode;

  const HomeScreen({
    required this.changeLocale,
    required this.changeTheme,
    required this.selectedLanguage,
    required this.selectedVoice,
    required this.selectedInterval,
    required this.updateLanguage,
    required this.updateVoice,
    required this.updateInterval,
    required this.currentThemeMode,
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  final List<String> allItems = [
    'Red', 'Green', 'Blue', 'White', 'Yellow', 'Purple', 'Left', 'Right', 'Forward', 'Backward',
  ];
  List<String> selectedItems = [];

  final Map<String, Map<String, String>> allItemsMap = {
    'Red': {'en': 'Red', 'de': 'Rot', 'ru': 'Красный'},
    'Green': {'en': 'Green', 'de': 'Grün', 'ru': 'Зелёный'},
    'Blue': {'en': 'Blue', 'de': 'Blau', 'ru': 'Синий'},
    'White': {'en': 'White', 'de': 'Weiß', 'ru': 'Белый'},
    'Yellow': {'en': 'Yellow', 'de': 'Gelb', 'ru': 'Жёлтый'},
    'Purple': {'en': 'Purple', 'de': 'Lila', 'ru': 'Фиолетовый'},
    'Left': {'en': 'Left', 'de': 'Links', 'ru': 'Лево'},
    'Right': {'en': 'Right', 'de': 'Rechts', 'ru': 'Право'},
    'Forward': {'en': 'Forward', 'de': 'Vorwärts', 'ru': 'Вперёд'},
    'Backward': {'en': 'Backward', 'de': 'Rückwärts', 'ru': 'Назад'},
  };

  final Map<String, Map<String, Map<String, String>>> audioMap = {
    'Red': {
      'eng-voice': {'en': 'sounds/red_eng.mp3'},
      'ru-voice': {'ru': 'sounds/red_ru.mp3'},
      'de-voice': {'de': 'sounds/red_de.mp3'},
    },
    'Green': {
      'eng-voice': {'en': 'sounds/green_eng.mp3'},
      'ru-voice': {'ru': 'sounds/green_ru.mp3'},
      'de-voice': {'de': 'sounds/green_de.mp3'},
    },
    'Blue': {
      'eng-voice': {'en': 'sounds/blue_eng.mp3'},
      'ru-voice': {'ru': 'sounds/blue_ru.mp3'},
      'de-voice': {'de': 'sounds/blue_de.mp3'},
    },
    'White': {
      'eng-voice': {'en': 'sounds/white_eng.mp3'},
      'ru-voice': {'ru': 'sounds/white_ru.mp3'},
      'de-voice': {'de': 'sounds/white_de.mp3'},
    },
    'Yellow': {
      'eng-voice': {'en': 'sounds/yellow_eng.mp3'},
      'ru-voice': {'ru': 'sounds/yellow_ru.mp3'},
      'de-voice': {'de': 'sounds/yellow_de.mp3'},
    },
    'Purple': {
      'eng-voice': {'en': 'sounds/purple_eng.mp3'},
      'ru-voice': {'ru': 'sounds/purple_ru.mp3'},
      'de-voice': {'de': 'sounds/purple_de.mp3'},
    },
    'Left': {
      'eng-voice': {'en': 'sounds/left_eng.mp3'},
      'ru-voice': {'ru': 'sounds/left_ru.mp3'},
      'de-voice': {'de': 'sounds/left_de.mp3'},
    },
    'Right': {
      'eng-voice': {'en': 'sounds/right_eng.mp3'},
      'ru-voice': {'ru': 'sounds/right_ru.mp3'},
      'de-voice': {'de': 'sounds/right_de.mp3'},
    },
    'Forward': {
      'eng-voice': {'en': 'sounds/forward_eng.mp3'},
      'ru-voice': {'ru': 'sounds/forward_ru.mp3'},
      'de-voice': {'de': 'sounds/forward_de.mp3'},
    },
    'Backward': {
      'eng-voice': {'en': 'sounds/backward_eng.mp3'},
      'ru-voice': {'ru': 'sounds/backward_ru.mp3'},
      'de-voice': {'de': 'sounds/backward_de.mp3'},
    },
  };

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void startTraining() {
    if (selectedItems.isEmpty || widget.selectedVoice == null) {
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
          intervalSeconds: widget.selectedInterval,
          items: selectedItems,
          audioPlayer: audioPlayer,
          audioMap: audioMap,
          selectedLanguage: widget.selectedLanguage,
          allItemsMap: allItemsMap,
          selectedVoice: widget.selectedVoice,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.appTitle ?? 'Тренажёр реакции'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    changeLocale: widget.changeLocale,
                    changeTheme: widget.changeTheme,
                    selectedLanguage: widget.selectedLanguage,
                    updateLanguage: widget.updateLanguage,
                    selectedVoice: widget.selectedVoice,
                    updateVoice: widget.updateVoice,
                    selectedInterval: widget.selectedInterval,
                    updateInterval: widget.updateInterval,
                    currentThemeMode: widget.currentThemeMode,
                  ),
                ),
              );
            },
            tooltip: AppLocalizations.of(context)?.selectLanguage ?? 'Настройки',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                          label: Text(allItemsMap[item]?[widget.selectedLanguage] ?? item),
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