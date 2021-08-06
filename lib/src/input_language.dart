// Copyright 2021 djarjo@djarjo.com
// Please see the LICENSE file for details.

import 'package:flutter/material.dart';

import 'language.dart';

/// Widget to select a language from a sorted list of names.
///
/// Works with ISO-639 codes (2 char lowercase).
class InputLanguage extends FormField<String> {
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

  /// List of ISO-639 alpha-2 lowercase language codes which can be selected.
  /// `null` will show full list unless [supportedLocales] is provided.
  final List<String>? selectableLanguages;

  /// Flag of main country from which the language derived.
  /// `false` will not show the flag icon. Default is `true`.
  final bool showFlag;

  /// Filter for selectable list of languages.
  /// `null` will show full list unless [selectableLanguages] is provided.
  final List<Locale>? supportedLocales;
  final TextStyle? style;
  final Widget? underline;

  /// `true` adds language with code 'xx' to selection list.
  /// Default is `false`.
  final bool withPlatformSelection;

  /// Provides a dropdown menu to select a language from a sorted list of names.
  /// Works with ISO-639 codes (2 char lowercase).
  /// Special language code `xx` will be used if `platformSelection=true`.
  InputLanguage({
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
    this.selectableLanguages,
    this.supportedLocales,
    this.style,
    this.underline,
    this.showFlag = true,
    FormFieldValidator<String>? validator,
    this.withPlatformSelection = false,
  }) : super(
            key: key,
            autovalidateMode: autovalidateMode,
            enabled: enabled,
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            builder: (FormFieldState<String> state) {
              //--- Builds one language for display
              Widget _buildDisplayItem(Language? lang, String langCode) {
                if (lang == null) {
                  return Text(''); // could happen to display disabledHint
                }
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    (showFlag && lang.country != null)
                        ? Image.asset(
                            IMAGE_PATH + lang.country! + '.png',
                            package: 'input_country',
                          )
                        : SizedBox.shrink(),
                    Flexible(
                      child: Text(
                        '  ' + lang.getTranslation(langCode),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                  ],
                );
              }

              //--- Build list of languages
              List<DropdownMenuItem<String>> _buildLanguageList(
                  String langCode) {
                List<Language> languages = <Language>[];
                List<String> filter = <String>[];
                //--- Prepare filter
                if (selectableLanguages != null) {
                  filter.addAll(selectableLanguages);
                }
                if (supportedLocales != null) {
                  supportedLocales.forEach(
                      (Locale locale) => filter.add(locale.languageCode));
                }
                //--- Build list of codes. Apply filter
                for (Language lang in Language.values()) {
                  if (filter.isEmpty || filter.contains(lang.code)) {
                    languages.add(lang);
                  }
                }
                languages.sort((Language lang1, Language lang2) => lang1
                    .getTranslation(langCode)
                    .compareTo(lang2.getTranslation(langCode)));
                if (withPlatformSelection) {
                  languages.insert(0, Language.fromPlatform);
                }
                return languages
                    .map(
                      (Language language) => DropdownMenuItem<String>(
                        value: language.code,
                        child: _buildDisplayItem(language, langCode),
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
              List<DropdownMenuItem<String>> languageList =
                  _buildLanguageList(langToUse);

              return DropdownButton<String>(
                autofocus: autofocus,
                disabledHint: disabledHint ??
                    _buildDisplayItem(
                        Language.findByCode(state.value), langToUse),
                dropdownColor: dropdownColor,
                elevation: elevation ?? 8,
                focusColor: focusColor,
                focusNode: focusNode,
                hint: hint,
                icon: icon ??
                    Icon((state.value == null)
                        ? Icons.language
                        : Icons.arrow_drop_down),
                iconDisabledColor: iconDisabledColor,
                iconEnabledColor: iconEnabledColor,
                iconSize: iconSize,
                isDense: isDense,
                isExpanded: isExpanded,
                items: languageList,
                itemHeight: itemHeight,
                onChanged: enabled ? (String? v) => _onChanged(v) : null,
                onTap: onTap,
                style: style,
                underline: underline,
                value: state.value,
              );
            });
}
