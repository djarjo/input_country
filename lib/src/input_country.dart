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

  /// `false` will not show country flags.
  final bool showFlag;

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
    this.isExpanded = false,
    this.itemHeight = kMinInteractiveDimension,
    Locale? locale,
    this.onChanged,
    FormFieldSetter<String>? onSaved,
    this.onTap,
    this.selectableCountries,
    this.showFlag = true,
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
              //--- Builds one country for display
              Widget _buildDisplayItem(Country? country, String langCode) {
                // could happen to display disabledHint
                if (country == null) {
                  return Text('');
                }
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (showFlag)
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Image.asset(
                          IMAGE_PATH + country.alpha2 + '.png',
                          package: 'input_country',
                        ),
                      ),
                    Flexible(
                      child: Text(
                        country.getTranslation(langCode),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                  ],
                );
              }

              //--- Build list of countries
              List<DropdownMenuItem<String>> _buildCountryList(
                  String langCode) {
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
                    .getTranslation(langCode)
                    .compareTo(country2.getTranslation(langCode)));
                return countries
                    .map(
                      (Country country) => DropdownMenuItem<String>(
                        value: country.alpha2,
                        child: _buildDisplayItem(country, langCode),
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
              String langToUse = localeToUse.languageCode;

              /// List of translated country names
              List<DropdownMenuItem<String>> countryList =
                  _buildCountryList(langToUse);

              return DropdownButton<String>(
                autofocus: autofocus,
                disabledHint: disabledHint ??
                    _buildDisplayItem(
                        Country.findByCode2(state.value), langToUse),
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
                items: countryList,
                itemHeight: itemHeight,
                onChanged: enabled ? (String? v) => _onChanged(v) : null,
                onTap: onTap,
                style: style,
                underline: underline,
                value: state.value,
              );
            });
}
