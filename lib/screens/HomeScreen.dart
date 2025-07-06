import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'TrainingScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<int> intervals = [5, 10, 15, 30, 60];
  int selectedInterval = 5;

  final AudioPlayer audioPlayer = AudioPlayer();
  String selectedLanguage = 'en'; // По умолчанию английский
  String selectedVoice = 'eng-voice'; // По умолчанию английский голос

  // Карта элементов с переводами
  final Map<String, Map<String, String>> allItems = {
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

  // Карта путей к аудиофайлам с учетом голоса
  final Map<String, Map<String, Map<String, String>>> audioMap = {
    'Red': {
      'eng-voice': {'en': 'assets/sounds/red.mp3'},
      'ru-voice': {'ru': 'assets/sounds/Красный.mp3'},
      'de-voice': {'de': 'assets/sounds/rot.mp3'},
    },
    'Green': {
      'eng-voice': {'en': 'assets/sounds/green.mp3'},
      'ru-voice': {'ru': 'assets/sounds/Зелёный.mp3'},
      'de-voice': {'de': 'assets/sounds/grün.mp3'},
    },
    'Blue': {
      'eng-voice': {'en': 'assets/sounds/blue.mp3'},
      'ru-voice': {'ru': 'assets/sounds/Синий.mp3'},
      'de-voice': {'de': 'assets/sounds/blau.mp3'},
    },
    'White': {
      'eng-voice': {'en': 'assets/sounds/white.mp3'},
      'ru-voice': {'ru': 'assets/sounds/Белый.mp3'},
      'de-voice': {'de': 'assets/sounds/weiß.mp3'},
    },
    'Yellow': {
      'eng-voice': {'en': 'assets/sounds/yellow.mp3'},
      'ru-voice': {'ru': 'assets/sounds/Жёлтый.mp3'},
      'de-voice': {'de': 'assets/sounds/gelb.mp3'},
    },
    'Purple': {
      'eng-voice': {'en': 'assets/sounds/purple.mp3'},
      'ru-voice': {'ru': 'assets/sounds/Фиолетовый.mp3'},
      'de-voice': {'de': 'assets/sounds/violett.mp3'},
    },
    'Left': {
      'eng-voice': {'en': 'assets/sounds/left.mp3'},
      'ru-voice': {'ru': 'assets/sounds/Лево.mp3'},
      'de-voice': {'de': 'assets/sounds/Links.mp3'},
    },
    'Right': {
      'eng-voice': {'en': 'assets/sounds/right.mp3'},
      'ru-voice': {'ru': 'assets/sounds/Право.mp3'},
      'de-voice': {'de': 'assets/sounds/Rechts.mp3'},
    },
    'Forward': {
      'eng-voice': {'en': 'assets/sounds/forward.mp3'},
      'ru-voice': {'ru': 'assets/sounds/Вперёд.mp3'},
      'de-voice': {'de': 'assets/sounds/Hoch.mp3'},
    },
    'Backward': {
      'eng-voice': {'en': 'assets/sounds/backward.mp3'},
      'ru-voice': {'ru': 'assets/sounds/Вниз.mp3'},
      'de-voice': {'de': 'assets/sounds/Runter.mp3'},
    },
  };

  List<String> selectedItems = ['Red', 'Green', 'Blue'];

  @override
  void initState() {
    super.initState();
    // Синхронизация языка и голоса
    if (selectedVoice == 'eng-voice') selectedLanguage = 'en';
    if (selectedVoice == 'ru-voice') selectedLanguage = 'ru';
    if (selectedVoice == 'de-voice') selectedLanguage = 'de';
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void startTraining() {
    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Выберите хотя бы один элемент')),
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
          allItemsMap: allItems,
          selectedVoice: selectedVoice,
        ),
      ),
    );
  }

  /// Виджет Dropdown выбора языка
  Widget buildLanguageDropdown() {
    return DropdownButton<String>(
      value: selectedLanguage,
      hint: Text('Выберите язык'),
      items: ['en', 'de', 'ru'].map((lang) {
        return DropdownMenuItem(
          value: lang,
          child: Text(lang == 'en' ? 'English' : lang == 'de' ? 'Deutsch' : 'Русский'),
        );
      }).toList(),
      onChanged: (lang) {
        if (lang != null && mounted) {
          setState(() {
            selectedLanguage = lang;
            selectedItems = selectedItems.where((item) => allItems.containsKey(item)).toList();
            // Синхронизация голоса с языком
            selectedVoice = lang == 'en' ? 'eng-voice' : lang == 'de' ? 'de-voice' : 'ru-voice';
          });
        }
      },
    );
  }

  /// Виджет Dropdown выбора голоса
  Widget buildVoiceDropdown() {
    return DropdownButton<String>(
      value: selectedVoice,
      hint: Text('Выберите голос'),
      items: ['eng-voice', 'ru-voice', 'de-voice'].map((voice) {
        return DropdownMenuItem(
          value: voice,
          child: Text(voice == 'eng-voice' ? 'English Voice' : voice == 'ru-voice' ? 'Russian Voice' : 'German Voice'),
        );
      }).toList(),
      onChanged: (voice) {
        if (voice != null && mounted) {
          setState(() {
            selectedVoice = voice;
            // Синхронизация языка с голосом
            selectedLanguage = voice == 'eng-voice' ? 'en' : voice == 'de-voice' ? 'de' : 'ru';
            selectedItems = selectedItems.where((item) => allItems.containsKey(item)).toList();
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки тренировки'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                title: Text('Интервал между сигналами'),
                trailing: DropdownButton<int>(
                  value: selectedInterval,
                  items: intervals
                      .map(
                        (sec) => DropdownMenuItem(
                          value: sec,
                          child: Text('$sec сек'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => selectedInterval = value!),
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Выберите элементы для озвучки:'),
                    Wrap(
                      spacing: 10,
                      children: allItems.keys.map((item) {
                        return FilterChip(
                          label: Text(allItems[item]![selectedLanguage]!),
                          selected: selectedItems.contains(item),
                          onSelected: (val) {
                            setState(() {
                              if (val) {
                                selectedItems.add(item);
                              } else {
                                selectedItems.remove(item);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              child: ListTile(
                title: Text('Язык'),
                subtitle: buildLanguageDropdown(),
              ),
            ),
            SizedBox(height: 10),
            Card(
              child: ListTile(
                title: Text('Голос'),
                subtitle: buildVoiceDropdown(),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: startTraining,
                icon: Icon(Icons.play_arrow),
                label: Text('Начать тренировку'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}