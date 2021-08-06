import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:input_country/input_country.dart';

import 'main.i18n.dart';

/// Supported locales. First entry `en` is default.
const List<Locale> supportedLocales = [
  Locale('en', 'US'),
  Locale('de', 'DE'),
  Locale('es', 'ES'),
];

late ValueNotifier<Locale> thisAppsLocaleNotifier;

const double SAFE_AREA_PADDING = 5.0;

/// Entry point for example application
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {
    thisAppsLocaleNotifier = ValueNotifier(window.locale);
    Localization.langCode = window.locale.languageCode;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: thisAppsLocaleNotifier,
      builder: (BuildContext context, Locale thisAppsLocale, Widget? child) =>
          MaterialApp(
        home: MyHomePage(),
        locale: thisAppsLocale,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: supportedLocales,
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        title: 'input_country',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _countryCode1,
      _currencyCode1,
      _languageCode1,
      _countryCode2,
      _currencyCode2;
  String _languageCode2 = window.locale.languageCode;

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
          Text('thisAppsLocale = ${thisAppsLocaleNotifier.value} / langCode ='
              ' ${Localization.langCode}'),
          _buildAllItems(context),
          _buildSelectableItems(context),
        ],
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
                initialValue: _languageCode1,
                onChanged: (String? newCode) =>
                    setState(() => _languageCode1 = newCode),
                withPlatformSelection: true,
              ),
              Text('$_languageCode1'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableItems(BuildContext context) {
    List<String> _selectableCountries = ['DE', 'ES', 'FR', 'IT'];
    List<String> _selectableCurrencies = ['EUR', 'USD'];
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
            0: FlexColumnWidth(3.0),
            1: FlexColumnWidth(6.0),
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
                initialValue: _languageCode2,
                onChanged: (String? langCode) => _setNewLanguage(
                    langCode ?? Language.LANG_CODE_FROM_PLATFORM),
                supportedLocales: supportedLocales,
                withPlatformSelection: true,
              ),
              Text('$_languageCode2'),
            ]),
          ],
        ),
      ),
    );
  }

  void _setNewLanguage(String langCode) {
    if (langCode == Language.LANG_CODE_FROM_PLATFORM) {
      langCode = Localizations.localeOf(context).languageCode;
    }
    if (langCode != thisAppsLocaleNotifier.value.languageCode) {
      setState(() {
        _languageCode2 = langCode;
        Localization.langCode = langCode;
        thisAppsLocaleNotifier.value =
            (langCode == Language.LANG_CODE_FROM_PLATFORM)
                ? window.locale
                : supportedLocales
                    .firstWhere((locale) => (langCode == locale.languageCode));
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        thisAppsLocaleNotifier.notifyListeners();
      });
    }
  }
}
