import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() => runApp(ReactionTrainerApp());

class ReactionTrainerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reaction Trainer',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<int> intervals = [5, 10, 15, 30, 60];
  int selectedInterval = 5;
  List<String> selectedItems = [
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

  final FlutterTts flutterTts = FlutterTts();
  List<Map<String, String>> filteredVoices = [];
  Map<String, String>? selectedVoice;

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
        .map<Map<String, String>>((v) => {'name': v['name'], 'locale': v['locale']})
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
      hint: Text('Выберите язык'),
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
      appBar: AppBar(title: Text('Reaction Trainer - Settings')),
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
            Text('Выберите категории (цвета и направления):'),
            Wrap(
              spacing: 10,
              children: [
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
              ].map((item) {
                return FilterChip(
                  label: Text(item),
                  selected: selectedItems.contains(item),
                  onSelected: (val) {
                    setState(() {
                      val ? selectedItems.add(item) : selectedItems.remove(item);
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Язык озвучки:'),
            buildVoiceDropdown(),
            Spacer(),
            ElevatedButton(
              onPressed: selectedVoice != null ? startTraining : null,
              child: Text('Начать тренировку'),
            ),
          ],
        ),
      ),
    );
  }
}

class TrainingScreen extends StatefulWidget {
  final int intervalSeconds;
  final List<String> items;
  final Map<String, String>? voice;

  TrainingScreen({
    required this.intervalSeconds,
    required this.items,
    required this.voice,
  });

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final FlutterTts flutterTts = FlutterTts();
  Timer? timer;
  String currentItem = '';
  Color backgroundColor = Colors.black;
  int countdown = 3;

  final Map<String, Map<String, String>> translations = {
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

  @override
  void initState() {
    super.initState();
    flutterTts.setVoice({
      'name': widget.voice!['name']!,
      'locale': widget.voice!['locale']!,
    });
    startCountdown();
  }

  void startCountdown() {
    Timer.periodic(Duration(seconds: 1), (t) {
      setState(() => countdown--);
      if (countdown == 0) {
        t.cancel();
        startSession();
      }
    });
  }

  void startSession() {
    updateItem();
    timer = Timer.periodic(Duration(seconds: widget.intervalSeconds), (_) {
      updateItem();
    });
  }

  void updateItem() async {
    final random = Random();
    final item = widget.items[random.nextInt(widget.items.length)];

    setState(() {
      currentItem = item;
      backgroundColor = getColorForItem(item);
    });

    final locale = widget.voice?['locale'] ?? 'en-US';
    final langCode = locale.startsWith('ru')
        ? 'ru'
        : locale.startsWith('de')
            ? 'de'
            : 'en';

    final textToSpeak = translations[item]?[langCode] ?? item;

    await flutterTts.speak(textToSpeak);
  }

  Color getColorForItem(String item) {
    switch (item.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'white':
        return Colors.white;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.grey.shade900;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Center(
            child: Text(
              countdown > 0 ? countdown.toString() : currentItem,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back, size: 32, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
