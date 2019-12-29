

import 'dart:html';

import 'package:arb/dart_arb.dart';
import 'package:arb_editor/generate/templates.dart';
import 'package:arb_editor/generate/utils.dart';

import 'date_utils.dart';
import 'methods.dart';





bool _isValidGetterAndMethodName(String name) {
  // Dart getter and method name cannot contain non-alphanumeric symbols
  if (name.contains(RegExp(r'[^a-zA-Z\d]')))
    return false;
  // Dart class name must start with lower case character
  if (name[0].contains(RegExp(r'[A-Z]')))
    return false;
  // Dart class name cannot start with a number
  if (name[0].contains(RegExp(r'\d')))
    return false;
  return true;
}

/// The localizations generation class used to generate the localizations
/// classes, as well as all pertinent Dart files required to internationalize a
/// Flutter application.
class LocalizationsGenerator {
  /// Creates an instance of the localizations generator class.
  LocalizationsGenerator(this.arbProject) {
    _generateClassMethods();
  }
  static RegExp pluralValueRE = RegExp(r'^\s*\{[\w\s,]*,\s*plural\s*,');
  final ArbProject arbProject;

  File stringFile;
  /// The list of all arb files in [l10nDirectory].
  final List<String> messageFiles = <String>[];

  /// The class methods that will be generated in the localizations class
  /// based on messages found in the template arb file.
  final List<String> classMethods = <String>[];

  /// Generates the methods for the localizations class.
  ///
  /// The method parses [templateArbFile] and uses its resource ids as the
  /// Dart method and getter names. It then uses each resource id's
  /// corresponding resource value to figure out how to define these getters.
  ///
  /// For example, a message with plurals will be handled differently from
  /// a simple, singular message.
  ///
  /// Throws an [L10nException] when a provided configuration is not allowed
  /// by [LocalizationsGenerator].
  ///
  /// Throws a [FileSystemException] when a file operation necessary for setting
  /// up the [LocalizationsGenerator] cannot be completed.
  ///
  /// Throws a [FormatException] when parsing the arb file is unsuccessful.
  void _generateClassMethods() {

    for (String key in arbProject.resources.keys) {
      if (key.startsWith('@'))
        continue;
      if (!_isValidGetterAndMethodName(key))
        throw L10nException(
            'Invalid key format: $key \n It has to be in camel case, cannot start '
                'with a number, and cannot contain non-alphanumeric characters.'
        );
    //  if (pluralValueRE.hasMatch(arbProject.resources[key]))
    //    classMethods.add(genPluralMethod(bundle, key));
    //  else
        classMethods.add(genSimpleMethod(arbProject.documents.first.resources[key]));
    }
  }

  /// Generates a file that contains the localizations class and the
  /// LocalizationsDelegate class.
  String generateOutputFile() {

    final fileString =
        defaultFileTemplate
            .replaceAll('@className', '${arbProject.fileName.capitalize()}Strings')
            .replaceAll('@classMethods', classMethods.join('\n'))
            .replaceAll('@importFile', 'l18n/${arbProject.fileName}strings.dart')
            .replaceAll('@supportedLocales', genSupportedLocaleProperty(arbProject.locales.map((locale) =>LocaleInfo.fromString(locale)).toList()))
            .replaceAll('@supportedLanguageCodes', arbProject.locales.map((local) => '\'${LocaleInfo.fromString(local).languageCode}\'').toList().join(', '));


    return fileString;
  }
}

class L10nException implements Exception {
  L10nException(this.message);

  final String message;
}

extension on String {
  String capitalize() => this[0].toUpperCase() + this.substring(1);
}
