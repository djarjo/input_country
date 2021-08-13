# Input Country &rarr; Countries, Currencies and Languages

This package provides data about countries, currencies and languages
plus a selection widget (dropdown box) for each of them.

All widgets extend [FormField]
so they can both be used standalone or within a [Form].

All widgets can display a flag for each selectable item and
on the selection itself.

### Countries

A `Country` is a plain Dart class providing:

* `alpha2` &rarr; ISO-3166 alpha-2 code 
* `alpha3` &rarr; ISO-3166 alpha-3 code
* `num3` &rarr; ISO-3166 numerical code
* `predial` &rarr; international phone pre-dial
* `language` &rarr; official language in the country
* `currency` &rarr; official currency in the country
* localized country name
* `Country.values()` &rarr; list of all countries 


### Currencies

A `Currency` is a plain Dart class providing:

* `code` - three uppercase characters according to ISO-4217
* `minor` - number of digits for minor currency (e.g. Cents)
* `symbol` - currency symbol (requires a UTF-8 font)


### Languages

A `Language` is a plain Dart class providing:

* `code` - 2 lowercase characters according to ISO-639
* `country` - ISO-3166 alpha-2 for the main country where this language is spoken
* `name` - localized name of the language
 
Languages are managed with Dart `Locales` only using the language code
without the country modifier.

A __special__ language with code `xx`
represents the current platform language.
