import 'package:arb/dart_arb.dart';
import 'package:arb_editor/generate/templates.dart';
import 'package:arb_editor/generate/utils.dart';

import 'date_utils.dart';
import 'generate_string_file.dart';

bool _isDateParameter(dynamic placeholderValue) {
  return placeholderValue is Map<String, dynamic> &&
      placeholderValue['type'] == 'DateTime';
}

bool _dateParameterIsValid(Map<String, dynamic> placeholderValue, String placeholder) {
  if (allowableDateFormats.contains(placeholderValue['format']))
    return true;
  throw L10nException(
      'Date format ${placeholderValue['format']} for the $placeholder \n'
          'placeholder does not have a corresponding DateFormat \n'
          'constructor. Check the intl library\'s DateFormat class \n'
          'constructors for allowed date formats.'
  );
}

bool _containsFormatKey(Map<String, dynamic> placeholderValue, String placeholder) {
  if (placeholderValue.containsKey('format'))
    return true;
  throw L10nException(
      'The placeholder, $placeholder, has its "type" resource attribute set to '
          'the "DateTime" type. To properly resolve for the right DateTime format, '
          'the "format" attribute needs to be set to determine which DateFormat to '
          'use. \n'
          'Check the intl library\'s DateFormat class constructors for allowed '
          'date formats.'
  );
}

List<String> genMethodParameters(Map<String, dynamic> bundle, String key, String type) {
  final Map<String, dynamic> attributesMap = bundle['@$key'] as Map<String, dynamic>;
  if (attributesMap != null && attributesMap.containsKey('placeholders')) {
    final Map<String, dynamic> placeholders = attributesMap['placeholders'] as Map<String, dynamic>;
    return placeholders.keys.map((String parameter) => '$type $parameter').toList();
  }
  return <String>[];
}

String generateDateFormattingLogic(Map<String, dynamic> bundle, String key) {
  String result = '';
  final Map<String, dynamic> attributesMap = bundle['@$key'] as Map<String, dynamic>;
  if (attributesMap != null && attributesMap.containsKey('placeholders')) {
    final Map<String, dynamic> placeholders = attributesMap['placeholders'] as Map<String, dynamic>;
    for (String placeholder in placeholders.keys) {
      final dynamic value = placeholders[placeholder];
      if (
      _isDateParameter(value) &&
          _containsFormatKey(value, placeholder) &&
          _dateParameterIsValid(value, placeholder)
      ) {
        result += '''
    final DateFormat ${placeholder}DateFormat = DateFormat.${value['format']}(_localeName);
    final String ${placeholder}String = ${placeholder}DateFormat.format($placeholder);
''';
      }
    }
  }

  return result;
}

List<String> genIntlMethodArgs(Map<String, dynamic> bundle, String key) {
  final List<String> attributes = <String>['name: \'$key\''];
  final Map<String, dynamic> attributesMap = bundle['@$key'] as Map<String, dynamic>;
  if (attributesMap != null) {
    if (attributesMap.containsKey('description')) {
      final String description = attributesMap['description'] as String;
      attributes.add('desc: ${generateString(description)}');
    }
    if (attributesMap.containsKey('placeholders')) {
      final Map<String, dynamic> placeholders = attributesMap['placeholders'] as Map<String, dynamic>;
      if (placeholders.isNotEmpty) {
        final List<String> argumentList = <String>[];
        for (String placeholder in placeholders.keys) {
          final dynamic value = placeholders[placeholder];
          if (
          _isDateParameter(value) &&
              _containsFormatKey(value, placeholder) &&
              _dateParameterIsValid(value, placeholder)
          ) {
            argumentList.add('${placeholder}String');
          } else {
            argumentList.add(placeholder);
          }
        }
        final String args = argumentList.join(', ');
        attributes.add('args: <Object>[$args]');
      }
    }
  }
  return attributes;
}

String genSimpleMethod(ArbResource resource) {
  String genSimpleMethodMessage(ArbResource resource) {
    String message = resource.value.text;
    /*final Map<String, dynamic> attributesMap = resource.attributes;
    final Map<String, dynamic> placeholders = attributesMap['placeholders'] as Map<String, dynamic>;
    for (String placeholder in placeholders.keys) {
      final dynamic value = placeholders[placeholder];
      if (_isDateParameter(value)) {
        message = message.replaceAll('{$placeholder}', '\$${placeholder}String');
      } else {
        message = message.replaceAll('{$placeholder}', '\$$placeholder');
      }
    }*/
    return generateString(message);
  }

/*
  final Map<String, dynamic> attributesMap = bundle['@$key'] as Map<String, dynamic>;
  if (attributesMap == null)
    throw L10nException(
        'Resource attribute "@$key" was not found. Please ensure that each '
            'resource id has a corresponding resource attribute.'
    );*/

/*  if (attributesMap.containsKey('placeholders')) {
    return simpleMethodTemplate
        .replaceAll('@methodName', key)
        .replaceAll('@methodParameters', genMethodParameters(bundle, key, 'Object').join(', '))
        .replaceAll('@dateFormatting', generateDateFormattingLogic(bundle, key))
        .replaceAll('@message', '${genSimpleMethodMessage(bundle, key)}')
        .replaceAll('@intlMethodArgs', genIntlMethodArgs(bundle, key).join(',\n      '));*/
//  }
  if(resource == null) {
    print('There is a null resource that won\'t be saved');
    return '';
  }
    return getterMethodTemplate
        .replaceAll('@methodName', '${resource.id}' )
        .replaceAll('@message', '${generateString(resource.value.text)}')
        .replaceAll('@intlMethodArgs', [ 'name: \'${resource.id}\'', 'desc: ${generateString(resource.description)}'].join(',\n      '));
      //genIntlMethodArgs(bundle, key).join(',\n      '));
}

String genPluralMethod(Map<String, dynamic> bundle, String key) {
  final Map<String, dynamic> attributesMap = bundle['@$key'] as Map<String, dynamic>;
  assert(attributesMap != null && attributesMap.containsKey('placeholders'));
  final Iterable<String> placeholders = attributesMap['placeholders'].keys as Iterable<String>;

  // To make it easier to parse the plurals message, temporarily replace each
  // "{placeholder}" parameter with "#placeholder#".
  String message = bundle[key] as String;
  for (String placeholder in placeholders)
    message = message.replaceAll('{$placeholder}', '#$placeholder#');

  final Map<String, String> pluralIds = <String, String>{
    '=0': 'zero',
    '=1': 'one',
    '=2': 'two',
    'few': 'few',
    'many': 'many',
    'other': 'other'
  };

  final List<String> methodArgs = <String>[
    ...placeholders,
    'locale: _localeName',
    ...genIntlMethodArgs(bundle, key),
  ];

  for (String pluralKey in pluralIds.keys) {
    final RegExp expRE = RegExp('($pluralKey){([^}]+)}');
    final RegExpMatch match = expRE.firstMatch(message);
    if (match != null && match.groupCount == 2) {
      String argValue = match.group(2);
      for (String placeholder in placeholders)
        argValue = argValue.replaceAll('#$placeholder#', '\$$placeholder');

      methodArgs.add("${pluralIds[pluralKey]}: '$argValue'");
    }
  }

  return pluralMethodTemplate
      .replaceAll('@methodName', key)
      .replaceAll('@methodParameters', genMethodParameters(bundle, key, 'int').join(', '))
      .replaceAll('@intlMethodArgs', methodArgs.join(',\n      '));
}

String genSupportedLocaleProperty(List<LocaleInfo> supportedLocales) {
  const String prefix = 'static const List<Locale> supportedLocales = <Locale>[\n    Locale(''';
  const String suffix = '),\n  ];';

  String resultingProperty = prefix;
  for (LocaleInfo locale in supportedLocales) {
    final String languageCode = locale.languageCode;
    final String countryCode = locale.countryCode;

    resultingProperty += '\'$languageCode\'';
    if (countryCode != null)
      resultingProperty += ', \'$countryCode\'';
    resultingProperty += '),\n    Locale(';
  }
  resultingProperty = resultingProperty.substring(0, resultingProperty.length - '),\n    Locale('.length);
  resultingProperty += suffix;

  return resultingProperty;
}