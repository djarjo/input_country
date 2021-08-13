// Copyright 2021 djarjo@djarjo.com
// Please see the LICENSE file for details.

import 'package:flutter/material.dart';

import 'language.dart';

/// Widget to select a language from a sorted list of names.
///
/// Works with Dart [Locale].
/// Based on ISO-639 (alpha-2 lowercase language codes).
class InputLanguage extends FormField<Locale> {
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
  final ValueChanged<Locale?>? onChanged;
  final Function()? onTap;

  /// Shows flag on each item of main country
  /// from which the language is derived.
  final bool showFlagOnItems;

  /// Shows flag on selected language.
  final bool showFlagOnSelection;

  /// Filter for selectable languages.
  /// `null` will show full list.
  final List<Locale>? selectableLocales;
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
    Locale? initialValue,
    this.isDense = false,
    this.isExpanded = true,
    this.itemHeight = kMinInteractiveDimension,
    Locale? locale,
    this.onChanged,
    FormFieldSetter<Locale>? onSaved,
    this.onTap,
    this.selectableLocales,
    this.style,
    this.underline,
    this.showFlagOnItems = false,
    this.showFlagOnSelection = true,
    FormFieldValidator<Locale>? validator,
    this.withPlatformSelection = false,
  }) : super(
            key: key,
            autovalidateMode: autovalidateMode,
            enabled: enabled,
            initialValue: (initialValue == null)
                ? null
                : (selectableLocales != null &&
                        selectableLocales.contains(initialValue))
                    ? Locale(initialValue.languageCode)
                    : null,
            onSaved: onSaved,
            validator: validator,
            builder: (FormFieldState<Locale> state) {
              //
              //--- Build list of languages
              List<DropdownMenuItem<Locale>> _buildLanguageList(
                  Locale targetLanguage) {
                List<Language> languages = <Language>[];
                List<String> filter = <String>[];
                //--- Prepare filter
                if (selectableLocales != null) {
                  selectableLocales.forEach(
                      (Locale locale) => filter.add(locale.languageCode));
                }
                //--- Build list of codes. Apply filter
                for (Language lang in Language.values()) {
                  if (filter.isEmpty || filter.contains(lang.code)) {
                    languages.add(lang);
                  }
                }
                languages.sort((Language lang1, Language lang2) => lang1
                    .getTranslation(targetLanguage)
                    .compareTo(lang2.getTranslation(targetLanguage)));
                if (withPlatformSelection) {
                  languages.insert(0, Language.fromPlatform);
                }
                return languages
                    .map(
                      (Language language) => DropdownMenuItem<Locale>(
                        value: language.toLocale(),
                        child: _buildDisplayItem(
                            language, targetLanguage, showFlagOnItems),
                      ),
                    )
                    .toList();
              }

              void _onChanged(Locale? value) {
                if (onChanged != null) {
                  onChanged(value);
                }
                state.didChange(value);
              }

              //--- Use given locale or active one from platform
              Locale targetLanguage =
                  locale ?? Localizations.localeOf(state.context);
              targetLanguage = Locale(targetLanguage.languageCode);

              /// List of translated country names
              List<DropdownMenuItem<Locale>> languageList =
                  _buildLanguageList(targetLanguage);

              return DropdownButton<Locale>(
                autofocus: autofocus,
                disabledHint: disabledHint ??
                    _buildDisplayItem(Language.fromLocale(state.value),
                        targetLanguage, showFlagOnSelection),
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
                onChanged: enabled ? (Locale? v) => _onChanged(v) : null,
                onTap: onTap,
                style: style,
                underline: underline,
                value: state.value,
              );
            });

  //--- Builds one language for display
  static Widget _buildDisplayItem(
      Language? language, Locale targetLanguage, bool showFlag) {
    if (language == null) {
      return Text(''); // could happen to display disabledHint
    }
    return showFlag
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (language.country != null)
                  ? Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Image.asset(
                        IMAGE_PATH + language.country! + '.png',
                        package: 'input_country',
                      ),
                    )
                  : SizedBox.shrink(),
              Flexible(
                child: Text(
                  '  ' + language.getTranslation(targetLanguage),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
            ],
          )
        : Text(
            language.getTranslation(targetLanguage),
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          );
  }
}
