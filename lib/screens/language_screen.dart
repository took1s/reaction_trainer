import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class LanguageScreen extends StatelessWidget {
  final Function(Locale) onChangeLocale;

  LanguageScreen({required this.onChangeLocale});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // Добавлен ! для non-nullable

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.selectLanguage),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.language),
            title: Text('English'),
            onTap: () {
              onChangeLocale(Locale('en'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Русский'),
            onTap: () {
              onChangeLocale(Locale('ru'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Deutsch'),
            onTap: () {
              onChangeLocale(Locale('de'));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}