// Copyright 2021 djarjo@djarjo.com
// Please see the LICENSE file for details.

import 'package:collection/collection.dart' show IterableExtension;

import 'currency.csv.dart';

/// Currency data according to ISO-4217.
///
/// A currency is identified by its code of 3 uppercase characters.
///
/// Get the list of all currencies with:
/// ```
/// List<Currency> currencies = Currency.values();
/// ```
class Currency {
  static final List<Currency> currencies = [];

  /// Constructor initializes list of countries once.
  Currency({
    required this.code,
    this.country,
    required this.name,
    this.minor,
    this.symbol,
    this.translations,
  })  : assert(code.length == 3),
        assert(country == null || country.length == 2,
            'Currency "$code" -> country "$country" must be null or 2 uppercase chars') {
    _initialize();
  }

  /// ISO-4217 Alpha-3 code. 3 char uppercase
  final String code;

  /// ISO-3166 Alpha-2 code for country. 2 char uppercase
  final String? country;

  /// ISO-4217 Name in standard locale en
  final String name;

  /// Number of digits for minor currency (fraction)
  final int? minor;

  /// Symbol of this currency
  final String? symbol;

  /// Country name by language code
  final Map<String, String>? translations;

  /// Returns `null` if `code == null` or not found
  static Currency? findByCode(String? code) {
    _initialize();
    if ((code == null) || (code.length != 3)) return null;
    code = code.toUpperCase();
    return currencies.firstWhereOrNull((currency) => currency.code == code);
  }

  /// Gets currency name translated into given language.
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

  // Columns are: code2, code3, language, name, predial, codenum, timezone
  static void _initialize() {
    const int INDEX_MINOR = 2;
    const int INDEX_TRANSLATION = 5; // First translation column
    if (_initialized || _initializing) {
      return;
    }
    _initializing = true;
    //--- Load currency data
    List<String> _langCodes = [];
    List<String> lines = csv_list_of_currencies.split('\n');
    for (String line in lines) {
      if (line.isEmpty) {
        continue;
      }
      List<String> parts = line.split(',');
      if (parts[0] == 'alpha-3') {
        for (int i = INDEX_TRANSLATION; i < parts.length; i++) {
          _langCodes.add(parts[i]);
        }
      } else {
        int? _minor = (parts[INDEX_MINOR].isEmpty)
            ? null
            : int.tryParse(parts[INDEX_MINOR]);
        Map<String, String> _t10ns = {};
        for (int i = 0; i < _langCodes.length; i++) {
          String? _t10n = parts[INDEX_TRANSLATION + i];
          if (_t10n.isNotEmpty) {
            _t10ns[_langCodes[i]] = _t10n;
          }
        }
        String? country = parts[4];
        if (country.length != 2) {
          print('Currency initialize error for ${parts[0]}. country len = '
              '${country.length}');
          country = null;
        }
        currencies.add(Currency(
          code: parts[0],
          name: parts[1],
          minor: _minor,
          symbol: parts[3],
          country: country,
          translations: _t10ns,
        ));
      }
    }
    //--- Ready
    _initialized = true;
  }

  /// Gets iterable list of all countries
  static List<Currency> values() {
    _initialize();
    return currencies;
  }
}
