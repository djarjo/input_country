// Copyright 2021 djarjo@djarjo.com
// Please see the LICENSE file for details.

import 'package:flutter/material.dart';

import 'currency.dart';

/// Widget to select a currency from a sorted list of currency names.
///
/// Works with ISO-4217 codes (3 char uppercase).
class InputCurrency extends FormField<String> {
  static const String IMAGE_PATH = 'lib/assets/flags/';

  final bool autofocus;
  final Widget? disabledHint;
  final Color? dropdownColor;
  final int? elevation;
  final Color? focusColor;
  final FocusNode? focusNode;
  final Widget? hint;
  final Widget? icon;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  final double iconSize;
  final bool isDense, isExpanded;
  final double itemHeight;
  final ValueChanged<String?>? onChanged;
  final Function()? onTap;

  /// List of ISO-4217 alpha-3 uppercase currency codes which can be selected.
  /// `null` will show full list.
  final List<String>? selectableCurrencies;

  /// `true` will show country flags in selection list.
  /// Default is `false`.
  ///
  /// Ensure sufficient horizontal space to show flags on items!
  final bool showFlagOnItems;

  /// 'false' will NOT show flag in selected country.
  /// Default is `true`.
  final bool showFlagOnSelection;

  final TextStyle? style;
  final Widget? underline;

  /// Widget to select a currency from a sorted list of currency names.
  ///
  /// Works with ISO-4217 alpha-3 codes (3 char uppercase).
  InputCurrency({
    Key? key,
    this.autofocus = false,
    AutovalidateMode? autovalidateMode,
    this.disabledHint,
    this.dropdownColor,
    this.elevation,
    bool enabled = true,
    this.focusColor,
    this.focusNode,
    this.hint,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24.0,
    String? initialValue,
    this.isDense = false,
    this.isExpanded = true,
    this.itemHeight = kMinInteractiveDimension,
    Locale? locale,
    this.onChanged,
    FormFieldSetter<String>? onSaved,
    this.onTap,
    this.selectableCurrencies,
    this.showFlagOnItems = false,
    this.showFlagOnSelection = true,
    this.style,
    this.underline,
    FormFieldValidator<String>? validator,
  }) : super(
            key: key,
            autovalidateMode: autovalidateMode,
            enabled: enabled,
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            builder: (FormFieldState<String> state) {
              //--- Build list of currencies
              List<DropdownMenuItem<String>> _buildCurrencyList(
                  String langCode, bool showFlag) {
                List<Currency> currencies = <Currency>[];
                List<String> filter = <String>[];
                //--- Prepare filter
                if (selectableCurrencies != null) {
                  filter.addAll(selectableCurrencies);
                }
                //--- Build list of codes. Apply filter
                for (Currency currency in Currency.values()) {
                  if (filter.isEmpty || filter.contains(currency.code)) {
                    currencies.add(currency);
                  }
                }
                currencies.sort((Currency currency1, Currency currency2) =>
                    currency1
                        .getTranslation(langCode)
                        .compareTo(currency2.getTranslation(langCode)));
                return currencies
                    .map(
                      (Currency currency) => DropdownMenuItem<String>(
                        value: currency.code,
                        child: _buildItem(currency, langCode, showFlag),
                      ),
                    )
                    .toList();
              }

              void _onChanged(String? value) {
                if (onChanged != null) {
                  onChanged(value);
                }
                state.didChange(value);
              }

              //--- Use given locale or use active one from platform
              Locale localeToUse =
                  locale ?? Localizations.localeOf(state.context);
              String langToUse = localeToUse.languageCode;

              return DropdownButton<String>(
                autofocus: autofocus,
                disabledHint: disabledHint ??
                    _buildItem(Currency.findByCode(state.value), langToUse,
                        showFlagOnSelection),
                dropdownColor: dropdownColor,
                elevation: elevation ?? 8,
                focusColor: focusColor,
                focusNode: focusNode,
                hint: hint,
                icon: icon ??
                    Icon((state.value == null)
                        ? Icons.money
                        : Icons.arrow_drop_down),
                iconDisabledColor: iconDisabledColor,
                iconEnabledColor: iconEnabledColor,
                iconSize: iconSize,
                isDense: isDense,
                isExpanded: isExpanded,
                items: _buildCurrencyList(langToUse, showFlagOnItems),
                itemHeight: itemHeight,
                onChanged: enabled ? (String? v) => _onChanged(v) : null,
                onTap: onTap,
                selectedItemBuilder: (BuildContext ctx) =>
                    _buildCurrencyList(langToUse, showFlagOnSelection),
                style: style,
                underline: underline,
                value: state.value,
              );
            });

  //--- Builds one country for display
  static Widget _buildItem(Currency? currency, String langCode, bool showFlag) {
    if (currency == null) {
      return Text('');
    }
    return showFlag
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (showFlag && (currency.country != null))
                  ? Image.asset(
                      IMAGE_PATH + currency.country! + '.png',
                      package: 'input_country',
                    )
                  : SizedBox.shrink(),
              Flexible(
                child: Text(
                  '  ' + currency.getTranslation(langCode),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
            ],
          )
        : Text(
            currency.getTranslation(langCode),
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          );
  }
}
