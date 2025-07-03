import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'TrainingScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<int> intervals = [5, 10, 15, 30, 60];
  int selectedInterval = 5;

  final FlutterTts flutterTts = FlutterTts();
  List<Map<String, String>> filteredVoices = [];
  Map<String, String>? selectedVoice;

  final List<String> allItems = [
    'Red',
    'Green',
    'Blue',
    'White',
    'Yellow',
    'Purple',
    'Left',
    'Right',
    'Forward',
    'Backward',
  ];
  List<String> selectedItems = ['Red', 'Green', 'Blue'];

  @override
  void initState() {
    super.initState();
    loadVoices();
  }

  /// Загружает список доступных голосов
  Future<void> loadVoices() async {
    List<dynamic> voices = await flutterTts.getVoices;
    List<String> allowedLocales = ['en-US', 'ru-RU', 'de-DE'];

    filteredVoices = voices
        .where((v) => allowedLocales.contains(v['locale']))
        .map<Map<String, String>>(
          (v) => {
            'name': v['name'],
            'locale': v['locale'],
          },
        )
        .toList();

    if (filteredVoices.isNotEmpty) {
      selectedVoice = filteredVoices.first;
      await flutterTts.setVoice({
        'name': selectedVoice!['name']!,
        'locale': selectedVoice!['locale']!,
      });
    }

    setState(() {});
  }

  /// Запускает тренировку
  void startTraining() {
    if (selectedItems.isEmpty || selectedVoice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Выберите хотя бы один элемент и голос')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TrainingScreen(
          intervalSeconds: selectedInterval,
          items: selectedItems,
          voice: selectedVoice,
        ),
      ),
    );
  }

  /// Виджет Dropdown выбора голоса
  Widget buildVoiceDropdown() {
    return DropdownButton<Map<String, String>>(
      value: selectedVoice,
      hint: Text('Выберите голос'),
      isExpanded: true,
      items: filteredVoices.map((voice) {
        return DropdownMenuItem(
          value: voice,
          child: Text('${voice['locale']} (${voice['name']})'),
        );
      }).toList(),
      onChanged: (voice) async {
        setState(() => selectedVoice = voice);
        await flutterTts.setVoice({
          'name': voice!['name']!,
          'locale': voice['locale']!,
        });
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
            /// Карточка выбора интервала
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
                  onChanged: (value) =>
                      setState(() => selectedInterval = value!),
                ),
              ),
            ),
            SizedBox(height: 10),

            /// Карточка выбора элементов
            Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Выберите элементы для озвучки:'),
                    Wrap(
                      spacing: 10,
                      children: allItems.map((item) {
                        return FilterChip(
                          label: Text(item),
                          selected: selectedItems.contains(item),
                          onSelected: (val) {
                            setState(() {
                              val
                                  ? selectedItems.add(item)
                                  : selectedItems.remove(item);
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

            /// Карточка выбора голоса
            Card(
              child: ListTile(
                title: Text('Язык и голос озвучки'),
                subtitle: buildVoiceDropdown(),
              ),
            ),
            Spacer(),

            /// Кнопка запуска тренировки по центру
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
