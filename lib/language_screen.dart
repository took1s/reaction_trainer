import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class LanguageScreen extends StatefulWidget {
  final Function(Locale) changeLocale;
  final String selectedLanguage;
  final Function(String) updateLanguage;
  final String? selectedVoice;
  final Function(String?) updateVoice;

  const LanguageScreen({
    required this.changeLocale,
    required this.selectedLanguage,
    required this.updateLanguage,
    required this.selectedVoice,
    required this.updateVoice,
    super.key,
  });

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.selectLanguage ?? 'Выберите язык'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)?.voiceAndLanguage ?? 'Язык и голос',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: Text(AppLocalizations.of(context)?.selectLanguage ?? 'Язык интерфейса'),
                subtitle: DropdownButton<String>(
                  value: widget.selectedLanguage,
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
                  value: widget.selectedVoice,
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
                      widget.updateVoice(voice);
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