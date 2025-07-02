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

  List<String> allItems = [
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
  List<String> selectedItems = ['Red', 'Green', 'Blue', 'White'];

  @override
  void initState() {
    super.initState();
    loadVoices();
  }

  Future<void> loadVoices() async {
    List<dynamic> voices = await flutterTts.getVoices;
    List<String> allowed = ['en-US', 'ru-RU', 'de-DE'];

    filteredVoices = voices
        .where((v) => allowed.contains(v['locale']))
        .map<Map<String, String>>((v) => {
              'name': v['name'],
              'locale': v['locale'],
            })
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

  Widget buildVoiceDropdown() {
    return DropdownButton<Map<String, String>>(
      value: selectedVoice,
      hint: Text('Выберите голос'),
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
      appBar: AppBar(title: Text('Настройки тренировки')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Интервал между сигналами (сек):'),
            DropdownButton<int>(
              value: selectedInterval,
              items: intervals
                  .map((sec) => DropdownMenuItem(
                        value: sec,
                        child: Text('$sec сек'),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => selectedInterval = value!),
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            Text('Язык и голос озвучки:'),
            buildVoiceDropdown(),
            Spacer(),
            ElevatedButton(
              onPressed: startTraining,
              child: Text('Начать тренировку'),
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
            ),
          ],
        ),
      ),
    );
  }
}
