**This project is not under development anymore.**

I am using https://localise.biz/ for editing my translations and exporting them to arb.
With the following dart file I automate the proccess of downloading the files and converting them to dart code.

```dart
void main() async {
  var shell = Shell();

  await shell.run('''

curl -s -o 'translated.zip' 'https://localise.biz/api/export/archive/arb.zip?key=$key'
unzip -qq 'translated.zip' -d 'l10n'
rm -f translated.zip
rm -rf lib/l10n/
mv l10n/insights-arb-archive/l10n/ lib/
rm -rf l10n/
dart ../../flutter/dev/tools/localization/bin/gen_l10n.dart --template-arb-file intl_messages_en.arb --output-class AppStrings

''');
}
```

----




<a href="https://jamesblasco.github.io/arb_editor/master/" rel="">![Arb Editor](https://github.com/jamesblasco/arb_editor/blob/master/header.png?raw=true)</a>

# Arb Editor

This project is not stable and it could cause some errors during downloading
Master version => https://jamesblasco.github.io/arb_editor/master/#/


## Roadmap

- [ ] Stable and functional
- [ ] Number, plurals and dates support
- [ ] Github implementation 

