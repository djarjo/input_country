// Copyright 2021 djarjo@djarjo.com
// Please see the LICENSE file for details.

/// List of languages including attributes and translations.
/// Column `country` denotes the main country of the language.
/// It is used to display the flag with `showFlag: true`.
///
/// The text is just a csv file with a header row and each language on one line.
/// To add a translation add a column with language code in the header row.
/// The new language will be used automatically.
String csv_list_of_languages = '''
alpha-2,name,country,de,es,fr,it
de,german,DE,deutsch,alemán,allemand,tedesco 
en,english,GB,englisch,inglés,anglais,inglese 
es,spanish,ES,spanisch,español,espagnol,spagnolo 
fr,french,FR,französisch,francés,français,francese
it,italian,IT,italienisch,italiano,italien,italiano
ja,japanese,JP,japanisch,japonés,japonais,giapponese 
nl,netherlands,NL,niederländisch,holandés,néerlandais ,olandese 
ru,russian,RU,russisch,ruso,russej,russo
th,thai,TH,thailändisch,tailandésj,thaïlandais,tailandese 
xx,from platform,XX,vom Gerät,desde dispositivo,depuis appareil,dal dispositivo
zh,chinese,CN,chinesisch,chino,chinois ,cinese
''';
