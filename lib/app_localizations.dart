import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A class that provides localization for the app.
class AppLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);

  /// Loads the localization JSON file for the current locale.
  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('assets/translations/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  /// Translates a key into the localized string.
  String translate(String key, {List<String>? args}) {
    String translation = _localizedStrings[key] ?? key;

    if (args != null) {
      for (int i = 0; i < args.length; i++) {
        translation = translation.replaceAll('{$i}', args[i]);
      }
    }

    return translation;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}

extension AppLocalizationsExtension on BuildContext {
  AppLocalizations get localizations => Localizations.of<AppLocalizations>(this, AppLocalizations)!;
}
