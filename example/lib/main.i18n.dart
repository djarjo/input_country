extension Localization on String {
  static String langCode = 'en';

  String get i18n => localize(this, _t);

  static final Map<String, Map<String, String>> _t = {
    'All': {
      'de': 'Alle',
      'es': 'Todas',
    },
    'All items': {
      'de': 'Alle Einträge',
      'es': 'Todas las entradas',
    },
    'Countries': {
      'de': 'Länder',
      'es': 'países',
    },
    'Currencies': {
      'de': 'Währungen',
      'es': 'Monedas',
    },
    'Example': {
      'de': 'Beispiel',
      'es': 'Ejemplo',
    },
    'In-App Language Selection': {
      'de': 'App interne Sprachauswahl',
      'es': 'App interna idioma seleccion',
    },
    'Languages': {
      'de': 'Sprachen',
      'es': 'Idiomas',
    },
    'Selectable Items': {
      'de': 'Auswählbare Einträge',
      'es': 'Entradas seleccionables',
    },
    'Selectables': {
      'de': 'Einträge',
      'es': 'Entradas',
    },
    'Selection': {
      'de': 'Auswahl',
      'es': 'Selección',
    },
    'Select language': {
      'de': 'Sprache wählen',
      'es': 'Selección de idioma',
    },
  };

  String localize(String english, Map<String, Map<String, String>> t10ns) {
    if (langCode != 'en') {
      Map<String, String>? _t10ns = t10ns[english];
      if (_t10ns == null) {
        print('No translations found for "$english"');
      } else {
        String? translated = _t10ns[langCode];
        if (translated == null) {
          print('Translation to language "$langCode" missing for "$english"');
        } else {
          return translated;
        }
      }
    }
    return english;
  }
}
