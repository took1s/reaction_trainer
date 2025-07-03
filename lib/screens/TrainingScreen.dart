import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

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
  double opacity = 0;

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
      opacity = 0;
    });

    // Fade in
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        opacity = 1;
      });
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
      body: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        color: backgroundColor,
        child: Stack(
          children: [
            Center(
              child: AnimatedOpacity(
                opacity: opacity,
                duration: Duration(milliseconds: 500),
                child: Text(
                  countdown > 0 ? countdown.toString() : currentItem,
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back, size: 32, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            if (countdown <= 0)
              Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.stop),
                  label: Text('Завершить тренировку'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
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
