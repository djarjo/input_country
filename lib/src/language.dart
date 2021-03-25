// Copyright 2021 djarjo@djarjo.com
// Please see the LICENSE file for details.

import 'package:collection/collection.dart' show IterableExtension;

import 'language.csv.dart';

/// Language data according to ISO-639.
///
/// Get a Locale (without country) with:
/// ```
/// Locale locale = Locale( language.code );
/// ```
///
/// Get the list of all languages with:
/// ```
/// List<Language> languages = Language.values();
/// ```
class Language {
  static final List<Language> languages = [];

  /// Constructor initializes list of countries once.
  Language({
    required this.code,
    this.country,
    required this.name,
    this.translations,
  }) {
    _initialize();
  }

  /// ISO-639 Alpha-2 code. 2 char lowercase
  final String code;

  /// ISO-3166 country code used to display flag
  final String? country;

  /// ISO-639 Name in standard locale en
  final String name;

  /// Country name by language code
  final Map<String, String>? translations;

  /// Language code to use locale from platform
  static final String LANG_CODE_FROM_PLATFORM = 'xx';
  static Language fromPlatform =
      Language(code: LANG_CODE_FROM_PLATFORM, name: 'Platform');

  /// Returns `null` if `code == null` or not found
  static Language? findByCode(String? langCode) {
    _initialize();
    if ((langCode == null) || (langCode.length != 2)) return null;
    langCode = langCode.toLowerCase();
    if (langCode == LANG_CODE_FROM_PLATFORM) {
      return fromPlatform;
    }
    return languages.firstWhereOrNull((language) => language.code == langCode);
  }

  /// Gets language name translated into given language.
  /// If no translation found then the english name will be returned.
  String getTranslation(String langCode) {
    if (langCode != 'en' && translations != null) {
      return translations?[langCode] ?? name;
    }
    return name;
  }

  @override
  String toString() {
    return '$name ($code)';
  }

  static bool _initializing = false, _initialized = false;

  // Columns are: alpha-2,name,country,de,es,fr,it
  static void _initialize() {
    const int INDEX_TRANSLATION = 3;
    if (_initialized || _initializing) {
      return;
    }
    _initializing = true;
    //--- Load language data
    List<String> _langCodes = [];
    List<String> lines = csv_list_of_languages.split('\n');
    for (String line in lines) {
      if (line.isEmpty) {
        continue;
      }
      List<String> parts = line.split(',');
      if (parts[0] == 'alpha-2') {
        for (int i = INDEX_TRANSLATION; i < parts.length; i++) {
          _langCodes.add(parts[i]);
        }
      } else {
        Map<String, String> _t10ns = {};
        for (int i = 0; i < _langCodes.length; i++) {
          String _t10n = parts[INDEX_TRANSLATION + i];
          if (_t10n.isNotEmpty) {
            _t10ns[_langCodes[i]] = _t10n;
          }
        }
        Language lang = Language(
          code: parts[0],
          name: parts[1],
          country: parts[2],
          translations: _t10ns,
        );
        if (parts[0] == LANG_CODE_FROM_PLATFORM) {
          fromPlatform = lang;
        } else
          languages.add(lang);
      }
    }
    //--- Ready
    _initialized = true;
  }

  /// Gets iterable list of all countries
  static List<Language> values() {
    _initialize();
    return languages;
  }
}
