import 'dart:async';
import 'dart:html';

import 'package:arb/models/arb_document.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'drop_zone.dart';

class ArbDropZone extends StatelessWidget {
  final Function(String name, List<ArbDocument> documents) onArbDocumentsAdded;

  const ArbDropZone({Key key, this.onArbDocumentsAdded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropZone(
      onFilesAdded: (files) => parseFiles(context, files),
    );
  }

  void parseFiles(BuildContext context, List<File> files) async {
    String fileName = 'app';

    Iterable<File> arbFiles = files.where((file) => file.name.endsWith('.arb'));
    final List<ArbDocument> documents =
        await Future.wait(arbFiles.map((file) async => await readFiles(file)));


    fileName = arbFiles.first.name.split('_').first;
    onArbDocumentsAdded(fileName, documents);
    print(documents);
  }

  Future<ArbDocument> readFiles(File file) async {
    RegExp re = new RegExp(r'_(.*).arb');
    final locale = re
        .firstMatch(file.name)
        ?.group(0)
        ?.substring(1, re.firstMatch(file.name).group(0).length - 4);
    print(locale);
    FileReader reader = FileReader();
    Future<ArbDocument> result = reader.onLoad
        .map((e) => ArbDocument.decode(reader.result as String, locale: locale))
        .first;
    reader.readAsText(file);
    return result;
    /*   StreamSubscription streamSubscription;
    streamSubscription = reader.onLoad.listen((fileEvent) {
      print(reader.result);
      streamSubscription.cancel();
      return reader.result;
    });
    reader.readAsText(file);*/
  }
}
