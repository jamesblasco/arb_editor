library generate_localized;

import 'dart:convert';
import 'dart:html';

import 'generate_message_file.dart';
import 'generate_message_file.dart';
import 'message_extration.dart';
import 'package:intl_translation/src/intl_message.dart';
import 'package:intl_translation/src/intl_message.dart';
import 'package:intl_translation/src/icu_parser.dart';

Map<String, List<MainMessage>> messages;

class MessagesFileGenerator {
  Map<String, String> generateFiles(Map<String, String> arbFiles,
      String dartFileContent, String dartFileName) {
    var extraction = new MessageExtraction();
    var generation = new MessageGeneration();
    var transformer = false;
    extraction.suppressWarnings = true;
    var allMessages = arbFiles.map((name, content) {
      try {
        return MapEntry(name,
            extraction.parseFile(dartFileName, dartFileContent, transformer));
      } catch (e) {
        print('Error parsing $dartFileName:');
        print(e);
        return MapEntry(name, <String, MainMessage>{});
      }
    }).values;

    messages = new Map();
    for (var eachMap in allMessages) {
      eachMap.forEach(
          (key, value) => messages.putIfAbsent(key, () => []).add(value));
    }
    print(allMessages);
    var messagesByLocale = <String, List<Map>>{};

    // In order to group these by locale, to support multiple input files,
    // we're reading all the data eagerly, which could be a memory
    // issue for very large projects.
    for (var key in arbFiles.keys) {
      loadData(key, arbFiles[key], messagesByLocale, generation);
    }

    final files = <String, String>{};

    messagesByLocale.forEach((locale, data) {
      files['${generation.generatedFilePrefix}messages_$locale.dart'] =
          generateLocaleFile(locale, data, generation);
    });

    files['${generation.generatedFilePrefix}messages_all.dart'] =
        generation.generateMainImportFile();
    return files;
  }

  loadData(String local, String content,
      Map<String, List<Map>> messagesByLocale, MessageGeneration generation) {
    var data = jsonDecode(content);
    var locale = data["@@locale"] ?? data["_locale"] ?? local;
    messagesByLocale.putIfAbsent(locale, () => []).add(data);
    generation.allLocales.add(locale);
  }

  /// Create the file of generated code for a particular locale.
  ///
  /// We read the ARB
  /// data and create [BasicTranslatedMessage] instances from everything,
  /// excluding only the special _locale attribute that we use to indicate the
  /// locale. If that attribute is missing, we try to get the locale from the
  /// last section of the file name. Each ARB file produces a Map of message
  /// translations, and there can be multiple such maps in [localeData].
  String generateLocaleFile(
      String locale, List<Map> localeData, MessageGeneration generation) {
    List<TranslatedMessage> translations = [];
    for (var jsonTranslations in localeData) {
      jsonTranslations.forEach((id, messageData) {
        TranslatedMessage message = recreateIntlObjects(id, messageData);
        if (message != null) {
          translations.add(message);
        }
      });
    }
    return generation.generateIndividualMessageFile(locale, translations);
  }

  /// Regenerate the original IntlMessage objects from the given [data]. For
  /// things that are messages, we expect [id] not to start with "@" and
  /// [data] to be a String. For metadata we expect [id] to start with "@"
  /// and [data] to be a Map or null. For metadata we return null.
  BasicTranslatedMessage recreateIntlObjects(String id, data) {
    if (id.startsWith("@")) return null;
    if (data == null) return null;
    var parsed = pluralAndGenderParser.parse(data).value;
    if (parsed is LiteralString && parsed.string.isEmpty) {
      parsed = plainParser.parse(data).value;
    }
    return new BasicTranslatedMessage(id, parsed);
  }
}

/// A TranslatedMessage that just uses the name as the id and knows how to look
/// up its original messages in our [messages].
class BasicTranslatedMessage extends TranslatedMessage {
  /// A TranslatedMessage that just uses the name as the id and knows how to look
  /// up its original messages in our [messages].class BasicTranslatedMessage extends TranslatedMessage {
  BasicTranslatedMessage(String name, translated) : super(name, translated);

  List<MainMessage> get originalMessages => (super.originalMessages == null)
      ? _findOriginals()
      : super.originalMessages;

  // We know that our [id] is the name of the message, which is used as the
  //key in [messages].
  List<MainMessage> _findOriginals() => originalMessages = messages[id];
}

final pluralAndGenderParser = new IcuParser().message;
final plainParser = new IcuParser().nonIcuMessage;
