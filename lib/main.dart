import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:moviedb/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'screens/movie_grid_screen.dart';
import 'themes/app_themes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  Locale _locale = Locale('ru', 'RU');
  String currentLanguage = 'ru-RU';

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void toggleLanguage() {
    setState(() {
      if (_locale.languageCode == 'ru') {
        _locale = Locale('en', 'US');
        currentLanguage = 'en-US';
      } else {
        _locale = Locale('ru', 'RU');
        currentLanguage = 'ru-RU';
      }
    });
    print("Updated app language: $currentLanguage");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie DB',
      theme: isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme,
      locale: _locale,
      supportedLocales: L10n.all,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: MovieGridScreen(
        toggleTheme: toggleTheme,
        toggleLanguage: toggleLanguage,
        isDarkMode: isDarkMode,
        currentLanguage: currentLanguage,
      ),
    );
  }
}