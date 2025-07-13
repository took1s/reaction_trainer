import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  final Function(Locale) changeLocale;
  final Function(ThemeMode) changeTheme;
  final String selectedLanguage;
  final Function(String) updateLanguage;
  final String? selectedVoice;
  final Function(String?) updateVoice;
  final int selectedInterval;
  final Function(int) updateInterval;
  final ThemeMode currentThemeMode; // Новый параметр для темы

  const SettingsScreen({
    required this.changeLocale,
    required this.changeTheme,
    required this.selectedLanguage,
    required this.updateLanguage,
    required this.selectedVoice,
    required this.updateVoice,
    required this.selectedInterval,
    required this.updateInterval,
    required this.currentThemeMode,
    super.key,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _selectedLanguage;
  late String? _selectedVoice;
  late int _selectedInterval;
  late ThemeMode _selectedThemeMode;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.selectedLanguage;
    _selectedVoice = widget.selectedVoice;
    _selectedInterval = widget.selectedInterval;
    _selectedThemeMode = widget.currentThemeMode; // Используем переданную тему
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.selectLanguage ?? 'Настройки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)?.voiceAndLanguage ?? 'Язык, голос и настройки',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: Text(AppLocalizations.of(context)?.selectLanguage ?? 'Язык интерфейса'),
                subtitle: DropdownButton<String>(
                  value: _selectedLanguage,
                  hint: Text(AppLocalizations.of(context)?.selectLanguage ?? 'Выберите язык'),
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'ru', child: Text('Русский')),
                    DropdownMenuItem(value: 'de', child: Text('Deutsch')),
                  ],
                  onChanged: (lang) {
                    if (lang != null) {
                      setState(() {
                        _selectedLanguage = lang;
                      });
                      widget.updateLanguage(lang);
                      widget.changeLocale(Locale(lang));
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: Text(AppLocalizations.of(context)?.voiceSelection ?? 'Голос озвучки'),
                subtitle: DropdownButton<String>(
                  value: _selectedVoice,
                  hint: Text(AppLocalizations.of(context)?.voiceSelection ?? 'Выберите голос'),
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'eng-voice', child: Text('English Voice')),
                    DropdownMenuItem(value: 'ru-voice', child: Text('Russian Voice')),
                    DropdownMenuItem(value: 'de-voice', child: Text('German Voice')),
                  ],
                  onChanged: (voice) {
                    if (voice != null) {
                      setState(() {
                        _selectedVoice = voice;
                      });
                      widget.updateVoice(voice);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: Text(AppLocalizations.of(context)?.intervalBetweenSignals ?? 'Интервал между сигналами'),
                subtitle: DropdownButton<int>(
                  value: _selectedInterval,
                  hint: Text(AppLocalizations.of(context)?.intervalBetweenSignals ?? 'Выберите интервал'),
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 5, child: Text('5 сек')),
                    DropdownMenuItem(value: 10, child: Text('10 сек')),
                    DropdownMenuItem(value: 15, child: Text('15 сек')),
                    DropdownMenuItem(value: 30, child: Text('30 сек')),
                    DropdownMenuItem(value: 60, child: Text('60 сек')),
                  ],
                  onChanged: (interval) {
                    if (interval != null) {
                      setState(() {
                        _selectedInterval = interval;
                      });
                      widget.updateInterval(interval);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: Text(AppLocalizations.of(context)?.trainingSettings ?? 'Выбор темы'),
                subtitle: DropdownButton<ThemeMode>(
                  value: _selectedThemeMode,
                  hint: Text(AppLocalizations.of(context)?.trainingSettings ?? 'Выберите тему'),
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: ThemeMode.light, child: Text('Light Theme')),
                    DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark Theme')),
                    DropdownMenuItem(value: ThemeMode.system, child: Text('System Theme')),
                  ],
                  onChanged: (themeMode) {
                    if (themeMode != null) {
                      setState(() {
                        _selectedThemeMode = themeMode;
                      });
                      widget.changeTheme(themeMode);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}