import 'package:flutter/material.dart';

class Translations {
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'settings': 'Settings',
      'preferences': 'Preferences',
      'language': 'Language',
      'notifications': 'Notifications',
      'theme': 'Theme',
      'aboutApp': 'About the app',
    },
    'ru': {
      'settings': 'Настройки',
      'preferences': 'Предпочтения',
      'language': 'Язык',
      'notifications': 'Уведомления',
      'theme': 'Тема',
      'aboutApp': 'О приложении',
    },
  };

  static String of(BuildContext context, String key) {
    final locale = Localizations.localeOf(context).languageCode;
    return _localizedValues[locale]?[key] ?? key;
  }
}
