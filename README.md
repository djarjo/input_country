# Input Country &rarr; Countries, Languages and Currencies

This package provides data about countries, languages and currencies
plus a selection widget (dropdown box) for each of them.

All widgets extend [FormField]
so they can both be used standalone or within a [Form].

All widgets display a flag next to the name by default.

### Countries

A `Country` is a plain Dart class providing:

* ISO-3166 codes alpha-2 (`alpha2`), alpha-3 (`alpha3`) and numeric-3 (`num3`)
* international phone pre-dial per country (`predial`)
* primary `language` per country
* primary `currency` per country
* localized country name
* a list of all countries with `Country.values()`


### Languages

A `Language` is a plain Dart class providing:

* `code` - 2 lowercase characters according to ISO-639
* `country` - ISO-3166 alpha-2 for the main country where this language is spoken
* `name` - localized name of the language
 
Languages are managed with Dart `Locales` only using the language code
without the country modifier.

A __special__ language with code `xx`
represents the current platform language.


### Currencies

A `Currency` is a plain Dart class providing:

* `code` - three uppercase characters according to ISO-4217
* `minor` - number of digits for minor currency (e.g. Cents)
* `symbol` - currency symbol (requires a UTF-8 font)
