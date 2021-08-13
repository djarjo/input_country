## [2.1.0] - 2021-08-13 - Always uses Locale for language

* If there is a language then always [Locale] will be used. This change improves code readability and reduces coding errors.
* Flags can now be sets separately for items and selection by parameters: [showFlagOnItems] and [showFlagOnSelection]
* Some country names have been shortened to better fit to small screens

## [2.0.0] - 2021-03-25 - Full null-safety

* Package is completely null-safe

## [1.1.0] - 2021-02-25 - Wrapped into Flutter [FormField]

* Breaking change: parameter `value` must be changed to `initialValue`
* Invokes [onSaved] if widget is descendant of a [Form] and `Form.save()` is called

## [1.0.0] - 2020-12-13 - Initial Release

* Provides widgets [InputCountry], [InputCurrency] and [InputLanguage]
* Example shows usage including language switch of application 
