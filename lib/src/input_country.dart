// Copyright 2021 djarjo@djarjo.com
// Please see the LICENSE file for details.

import 'package:flutter/material.dart';

import 'country.dart';

/// Widget to select a country from a sorted list of country names.
///
/// Displays flag and localized name of the country.
/// List is sorted by localized name.
/// Uses ISO-3166 code (2 char uppercase) as value.
///
/// See also:
///
/// * [Form] if you want to use this widget within a form
/// * [DropdownButton] for most of the parameters here
class InputCountry extends FormField<String> {
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

  /// List of ISO-3166 code-2 uppercase country codes which can be selected.
  /// `null` will show full list.
  final List<String>? selectableCountries;
  final TextStyle? style;

  final Widget? underline;

  /// `true` will show country flags in selection list.
  /// Default is `false`.
  ///
  /// Ensure sufficient horizontal space to show flags on items!
  final bool showFlagOnItems;

  /// 'false' will NOT show flag in selected country.
  /// Default is `true`.
  final bool showFlagOnSelection;

  /// Dropdown button to select a country.
  /// Set `showFlag = false` to hide flag images for countries.
  ///
  /// Uses ISO-3166 alpha-2 code. Two uppercase characters.
  InputCountry({
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
    this.selectableCountries,
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
              //--- Build list of countries
              List<DropdownMenuItem<String>> _buildCountryList(
                  Locale locale, bool showFlag) {
                List<Country> countries = <Country>[];
                List<String> filter = <String>[];
                //--- Prepare filter
                if (selectableCountries != null) {
                  filter.addAll(selectableCountries);
                }
                //--- Build list of codes. Apply filter
                for (Country country in Country.values()) {
                  if (filter.isEmpty || filter.contains(country.alpha2)) {
                    countries.add(country);
                  }
                }
                countries.sort((Country country1, Country country2) => country1
                    .getTranslation(locale)
                    .compareTo(country2.getTranslation(locale)));
                return countries
                    .map(
                      (Country country) => DropdownMenuItem<String>(
                        value: country.alpha2,
                        child: _buildItem(country, locale, showFlag),
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

              //--- Use given locale or active one from platform
              Locale localeToUse =
                  locale ?? Localizations.localeOf(state.context);

              return DropdownButton<String>(
                autofocus: autofocus,
                disabledHint: disabledHint ??
                    _buildItem(Country.findByCode2(state.value), localeToUse,
                        showFlagOnSelection),
                dropdownColor: dropdownColor,
                elevation: elevation ?? 8,
                focusColor: focusColor,
                focusNode: focusNode,
                hint: hint,
                icon: icon ??
                    Icon((state.value == null)
                        ? Icons.flag_outlined
                        : Icons.arrow_drop_down),
                iconDisabledColor: iconDisabledColor,
                iconEnabledColor: iconEnabledColor,
                iconSize: iconSize,
                isDense: isDense,
                isExpanded: isExpanded,
                items: _buildCountryList(localeToUse, showFlagOnItems),
                itemHeight: itemHeight,
                onChanged: enabled ? (String? v) => _onChanged(v) : null,
                onTap: onTap,
                selectedItemBuilder: (BuildContext ctx) =>
                    _buildCountryList(localeToUse, showFlagOnSelection),
                style: style,
                underline: underline,
                value: state.value,
              );
            });

  //--- Builds one country for display
  static Widget _buildItem(Country? country, Locale locale, bool showFlag) {
    // could happen to display disabledHint
    if (country == null) {
      return Text('');
    }
    return showFlag
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Image.asset(
                  IMAGE_PATH + country.alpha2 + '.png',
                  package: 'input_country',
                ),
              ),
              Flexible(
                child: Text(
                  country.getTranslation(locale),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ],
          )
        : Text(
            country.getTranslation(locale),
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          );
  }
}
