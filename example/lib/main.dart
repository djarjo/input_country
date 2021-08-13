import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:input_country/input_country.dart';

import 'main.i18n.dart';

const double SAFE_AREA_PADDING = 5.0;

/// Entry point for example application
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {
    LocaleHandler.initialize(window.locale);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
        valueListenable: LocaleHandler.thisAppsLocaleNotifier,
        builder: (BuildContext ctx, Locale locale, Widget? child) {
          debugPrint('--- builder called --- locale=$locale');
          return MaterialApp(
            home: MyHomePage(),
            locale: locale,
            localeResolutionCallback:
                (Locale? newLocale, Iterable<Locale> supportedLocales) =>
                    LocaleHandler.localeResolutionCallback(
                        newLocale, supportedLocales),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LocaleHandler.supportedLocales,
            theme: ThemeData(
              primarySwatch: Colors.orange,
            ),
            title: 'input_country',
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _countryCode1, _currencyCode1, _countryCode2, _currencyCode2;
  Locale? _language1;
  Locale _language2 = window.locale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('input_country ' + 'Example'.i18n),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(SAFE_AREA_PADDING),
        child: SingleChildScrollView(
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildLanguageSelection(context),
          _buildAllItems(context),
          _buildSelectableItems(context),
        ],
      ),
    );
  }

  Widget _buildLanguageSelection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SAFE_AREA_PADDING),
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          labelText: 'In-App Language Selection'.i18n,
        ),
        child: Table(
            columnWidths: {
              0: FlexColumnWidth(2.0),
              1: FlexColumnWidth(7.0),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(children: [
                Text('window.locale'),
                Text('= ${window.locale}'),
              ]),
              TableRow(children: [
                Text('useLocaleFromPlatform'),
                Text('= ${LocaleHandler.isLocaleFromPlatform}'),
              ]),
              TableRow(children: [
                Text('thisAppsLocale'),
                Text('= ${LocaleHandler.thisAppsLocale}'),
              ]),
              TableRow(children: [
                Text('Localization.code'),
                Text('= ${Localization.langCode}'),
              ]),
              TableRow(children: [
                Text('Select language'.i18n),
                InputLanguage(
                  initialValue: LocaleHandler.thisAppsLocale,
                  onChanged: (Locale? newLang) =>
                      LocaleHandler.thisAppsLocale = newLang,
                  selectableLocales: LocaleHandler.supportedLocales,
                  withPlatformSelection: true,
                ),
              ]),
            ]),
      ),
    );
  }

  Widget _buildAllItems(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SAFE_AREA_PADDING),
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          labelText: 'All items'.i18n,
        ),
        child: Table(
          columnWidths: {
            0: FlexColumnWidth(2.0),
            1: FlexColumnWidth(7.0),
            2: FlexColumnWidth(1.0),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                Text('All'.i18n),
                Text('Selection'.i18n),
                Text('Code'),
              ],
            ),
            TableRow(
              children: [
                Text('Countries'.i18n),
                InputCountry(
                  showFlagOnSelection: true,
                  showFlagOnItems: true,
                  initialValue: _countryCode1,
                  onChanged: (String? newCode) =>
                      setState(() => _countryCode1 = newCode),
                ),
                Text('$_countryCode1'),
              ],
            ),
            TableRow(
              children: [
                Text('Currencies'.i18n),
                InputCurrency(
                  initialValue: _currencyCode1,
                  onChanged: (String? newCode) =>
                      setState(() => _currencyCode1 = newCode),
                ),
                Text('$_currencyCode1'),
              ],
            ),
            TableRow(children: [
              Text('Languages'.i18n),
              InputLanguage(
                initialValue: _language1,
                onChanged: (Locale? newLang) =>
                    setState(() => _language1 = newLang),
                showFlagOnItems: true,
                showFlagOnSelection: true,
                withPlatformSelection: true,
              ),
              Text('$_language1'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableItems(BuildContext context) {
    List<String> _selectableCountries = ['DE', 'ES', 'FR', 'IT'];
    List<String> _selectableCurrencies = ['EUR', 'USD'];
    List<Locale> _selectableLocales = [Locale('en'), Locale('es')];

    return Padding(
      padding: EdgeInsets.all(SAFE_AREA_PADDING),
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          labelText: 'Selectable Items'.i18n,
        ),
        child: Table(
          columnWidths: {
            0: FlexColumnWidth(2.0),
            1: FlexColumnWidth(7.0),
            2: FlexColumnWidth(1.0),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                Text('Selectables'.i18n),
                Text('Selection'.i18n),
                Text('Code'),
              ],
            ),
            TableRow(
              children: [
                Text('$_selectableCountries'),
                InputCountry(
                  initialValue: _countryCode2,
                  onChanged: (String? newCode) =>
                      setState(() => _countryCode2 = newCode),
                  selectableCountries: _selectableCountries,
                ),
                Text('$_countryCode2'),
              ],
            ),
            TableRow(
              children: [
                Text('$_selectableCurrencies'),
                InputCurrency(
                  initialValue: _currencyCode2,
                  onChanged: (String? newCode) =>
                      setState(() => _currencyCode2 = newCode),
                  selectableCurrencies: _selectableCurrencies,
                ),
                Text('$_currencyCode2'),
              ],
            ),
            TableRow(children: [
              Text('Languages'.i18n),
              InputLanguage(
                initialValue: _language2,
                onChanged: (Locale? newLang) =>
                    setState(() => _language2 = newLang!),
                selectableLocales: _selectableLocales,
              ),
              Text('${_language2.languageCode}'),
            ]),
          ],
        ),
      ),
    );
  }
}

///
/// Combines functionality to handle locale changes for this app.
///
/// Initial setup:
/// * `thisAppsLocale.value = window.locale
/// * `useLocaleFromPlatform` = true
///
class LocaleHandler {
  /// Locale used if no other matches
  static const DEFAULT_LOCALE = Locale('en', 'US');

  /// Supported locales. First entry `en` is default.
  static const List<Locale> supportedLocales = [
    DEFAULT_LOCALE,
    Locale('de', 'DE'),
    Locale('es', 'ES'),
  ];

  /// Set by initialize
  static late ValueNotifier<Locale> thisAppsLocaleNotifier;

  /// Set by initialize
  static late Locale _thisAppsLocale;

  static Locale get thisAppsLocale => _thisAppsLocale;

  /// Sets locale to use.
  /// Returns resolved locale which is used.
  static set thisAppsLocale(Locale? newLocale) {
    Locale localeToSet;
    if ((newLocale == null) ||
        (newLocale.languageCode == Language.LANG_CODE_FROM_PLATFORM)) {
      localeToSet = window.locale;
      _isLocaleFromPlatform = true;
    } else {
      localeToSet = newLocale;
      _isLocaleFromPlatform = false;
    }
    Locale resolvedLocale = _resolveLocaleToUse(localeToSet);
//    if (_thisAppsLocale.languageCode != resolvedLocale.languageCode) {
    _thisAppsLocale = resolvedLocale;
    thisAppsLocaleNotifier.value = resolvedLocale;
    Localization.langCode = resolvedLocale.languageCode;
    debugPrint(
        'set thisAppsLocale( $newLocale ) // fromPlatform=$_isLocaleFromPlatform -> use=$resolvedLocale');
//    } else {
//      debugPrint(
//          'set thisAppsLocale( $newLocale ) // fromPlatform=$_isLocaleFromPlatform -> unchanged');
//    }
  }

  static bool _isLocaleFromPlatform = false;
  static bool get isLocaleFromPlatform => _isLocaleFromPlatform;

  static bool _breakCircularCallFromMaterialApp = true;

  static void initialize(Locale startupLocale) {
    _thisAppsLocale = _resolveLocaleToUse(window.locale);
    thisAppsLocaleNotifier = ValueNotifier<Locale>(_thisAppsLocale);
    Localization.langCode = _thisAppsLocale.languageCode;
  }

  /// Callback method for [MaterialApp]
  static Locale localeResolutionCallback(
      Locale? newLocale, Iterable<Locale> appLocales) {
/*    if (_breakCircularCallFromMaterialApp) {
      _breakCircularCallFromMaterialApp = false;
      return _thisAppsLocale;
    }
 */
    thisAppsLocale = newLocale;
    debugPrint(
        'localeResolutionMethod( $newLocale, $appLocales ) -> $thisAppsLocale');
    return thisAppsLocale;
  }

  static Locale _resolveLocaleToUse(Locale? newLocale) {
    if (newLocale != null) {
      String langCode = newLocale.languageCode;
      for (Locale loc in supportedLocales) {
        if (langCode == loc.languageCode) {
          return loc;
        }
      }
    }
    return DEFAULT_LOCALE;
  }
}
