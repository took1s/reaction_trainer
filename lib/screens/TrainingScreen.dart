import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../l10n/app_localizations.dart';

class TrainingScreen extends StatefulWidget {
  final int intervalSeconds;
  final List<String> items;
  final AudioPlayer audioPlayer;
  final Map<String, Map<String, Map<String, String>>> audioMap;
  final String selectedLanguage;
  final Map<String, Map<String, String>> allItemsMap;
  final String? selectedVoice;

  const TrainingScreen({
    required this.intervalSeconds,
    required this.items,
    required this.audioPlayer,
    required this.audioMap,
    required this.selectedLanguage,
    required this.allItemsMap,
    required this.selectedVoice,
    super.key,
  });

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  Timer? timer;
  String currentItem = '';
  Color backgroundColor = Colors.black;
  int countdown = 3; // Начальный отсчет
  double opacity = 0.0;
  bool isCountingDown = true;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (countdown > 0) {
            countdown--;
          } else {
            timer.cancel();
            isCountingDown = false;
            startSession();
          }
        });
      }
    });
  }

  void startSession() {
    updateItem();
    timer = Timer.periodic(Duration(seconds: widget.intervalSeconds), (_) {
      if (mounted) updateItem();
    });
  }

  Future<void> updateItem() async {
    if (!mounted) return;
    final random = Random();
    final item = widget.items[random.nextInt(widget.items.length)];

    setState(() {
      currentItem = item;
      backgroundColor = getColorForItem(item);
      opacity = 0.0;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() => opacity = 1.0);
      final voice = widget.selectedVoice ?? 'eng-voice';
      final language = widget.selectedLanguage;
      final audioPath = widget.audioMap[item]?[voice]?[language];

      print('Attempting to play: $audioPath'); // Отладка пути
      if (audioPath != null && audioPath.isNotEmpty) {
        try {
          await widget.audioPlayer.play(AssetSource(audioPath));
          print('Successfully played: $audioPath'); // Успешное воспроизведение
        } catch (e) {
          print('Error playing sound: $e'); // Ошибка воспроизведения
        }
      } else {
        print('No audio path found for item: $item, voice: $voice, language: $language');
      }
    }
  }

  Color getColorForItem(String item) {
    switch (item.toLowerCase()) {
      case 'red': return Colors.red;
      case 'green': return Colors.green;
      case 'blue': return Colors.blue;
      case 'white': return Colors.white;
      case 'yellow': return Colors.yellow;
      case 'purple': return Colors.purple;
      default: return Colors.grey.shade900;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    widget.audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: backgroundColor,
        child: Stack(
          children: [
            Center(
              child: AnimatedOpacity(
                opacity: isCountingDown ? 1.0 : opacity,
                duration: const Duration(milliseconds: 500),
                child: Text(
                  isCountingDown ? countdown.toString() : widget.allItemsMap[currentItem]?[widget.selectedLanguage] ?? currentItem,
                  style: const TextStyle(
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
                icon: const Icon(Icons.arrow_back, size: 32, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            if (!isCountingDown)
              Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.stop),
                  label: Text(AppLocalizations.of(context)?.finishTraining ?? 'Завершить тренировку'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
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