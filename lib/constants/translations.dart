import 'package:flutter/material.dart';

class Language {
  final Locale locale;
  final String title;

  const Language(this.locale, this.title);
}

class Translations {
  static const languages = [
    Language(Locale('en'), 'English'),
    Language(Locale('uk'), 'Українська'),
    Language(Locale('ru'), 'Русский'),
  ];
}
