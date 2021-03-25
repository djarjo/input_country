// Copyright 2021 djarjo@djarjo.com
// Please see the LICENSE file for details.

import 'package:collection/collection.dart' show IterableExtension;

import 'country.csv.dart';

/// Country data according to ISO-3166.
///
/// Get the flag image with:
/// ```
/// Image.asset(
/// 'assets/packages/input_country/' + country.code2 + '.png',
/// package: 'input_country',
/// );
/// ```
///
/// Get a Locale with:
/// ```
/// Locale locale = Locale( country.language, country.code2 );
/// ```
///
/// Get the list of all countries with:
/// ```
/// List<Country> countries = Country.values();
/// ```
class Country {
  static final List<Country> countries = [];

  /// Constructor automatically initializes list of countries
  Country({
    required this.alpha2,
    this.alpha3,
    this.currency,
    this.language,
    required this.name,
    this.num3,
    this.predial,
    this.timezone,
    this.translations,
  })  : assert(alpha2.length == 2),
        assert(alpha3 == null || alpha3.length == 3,
            'Country "$alpha2" -> alpha3 "$alpha3" must be null or 3 uppercase chars') {
    _initialize();
  }

  /// ISO-3166 Alpha-2 code. 2 char uppercase
  final String alpha2;

  /// ISO-3166 Alpha-3 code. 3 char uppercase
  final String? alpha3;

  /// Official currency. ISO-4217 currency code. 3 char uppercase
  final String? currency;

  /// Official language. ISO-639-1 code. 2 char lowercase.
  final String? language;

  /// ISO-3166 Name in standard locale en
  final String name;

  /// ISO-3166 numerical code. up to 3 digits
  final int? num3;

  /// International phone predial code
  final int? predial;

  /// Timezone of this country.
  /// Returns mean timezone if the country covers multiple lines of latitude.
  final double? timezone;

  /// Country name by language code
  final Map<String, String>? translations;

  /// Returns `null` if `code2 == null` or not found
  static Country? findByCode2(String? code2) {
    _initialize();
    if ((code2 == null) || (code2.length != 2)) {
      return null;
    }
    code2 = code2.toUpperCase();
    return countries.firstWhereOrNull((country) => country.alpha2 == code2);
  }

  /// Returns `null` if `code3 == null` or not found
  static Country? findByCode3(String? code3) {
    _initialize();
    if ((code3 == null) || (code3.length != 3)) {
      return null;
    }
    code3 = code3.toUpperCase();
    return countries.firstWhereOrNull((country) => country.alpha3 == code3);
  }

  /// Returns `null` if `number == null` or not found
  static Country? findByPredial(int? number) {
    _initialize();
    if (number == null) return null;
    return countries.firstWhereOrNull((country) => country.predial == number);
  }

  /// Gets country name translated into given language.
  /// If no translation found then the english name will be returned.
  String getTranslation(String langCode) {
    if (langCode != 'en' && translations != null) {
      return translations?[langCode] ?? name;
    }
    return name;
  }

  @override
  String toString() {
    return '$name ($alpha2)';
  }

  static bool _initializing = false, _initialized = false;

  // Columns are: code2, code3, language, name, predial, codenum, timezone
  static void _initialize() {
    const int INDEX_NUM3 = 2;
    const int INDEX_PREDIAL = 6;
    const int INDEX_TRANSLATION = 8;
    if (_initialized || _initializing) {
      return;
    }
    _initializing = true;
    //--- Load country data
    List<String> _langCodes = [];
    List<String> lines = csv_list_of_countries.split('\n');
    for (String line in lines) {
      if (line.isEmpty) {
        continue;
      }
      List<String> parts = line.split(',');
      if (line.length < INDEX_TRANSLATION) {
        continue;
      }
      if (parts[0] == 'alpha-2') {
        for (int i = INDEX_TRANSLATION; i < parts.length; i++) {
          _langCodes.add(parts[i]);
        }
      } else {
        int? _num3 = (parts[INDEX_NUM3] == null)
            ? null
            : int.tryParse(parts[INDEX_NUM3]);
        int? _predial = (parts[INDEX_PREDIAL] == null)
            ? null
            : int.tryParse(parts[INDEX_PREDIAL]);
        double? _timezone =
            (parts[7] == null) ? null : double.tryParse(parts[7]);
        Map<String, String> _t10ns = {};
        for (int i = 0; i < _langCodes.length; i++) {
          String _t10n = parts[INDEX_TRANSLATION + i];
          if (_t10n != null && _t10n.isNotEmpty) {
            _t10ns[_langCodes[i]] = _t10n;
          }
        }
        countries.add(Country(
          alpha2: parts[0],
          alpha3: parts[1],
          name: parts[3],
          currency: parts[4],
          language: parts[5],
          num3: _num3,
          predial: _predial,
          timezone: _timezone,
          translations: _t10ns,
        ));
      }
    }
    //--- Ready
    _initialized = true;
  }

  /// Gets iterable list of all countries
  static List<Country> values() {
    _initialize();
    return countries;
  }
}
