import 'dart:convert';
import 'dart:html';

import 'package:arb/models/arb_project.dart';
import 'package:arb_editor/arb_bloc/arb_bloc.dart';
import 'package:arb_editor/components/download_button.dart';
import 'package:arb_editor/generate/generate_string_file.dart';
import 'package:arb_editor/generate/messages_file_generator.dart';
import 'package:arb_editor/i18n/app_strings.dart';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';

import '../../utils.dart';

class ProjectHeaderBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      textBaseline: TextBaseline.alphabetic,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: <Widget>[
        Text(
          context.arb.fileName.capitalize(),
          style: Theme.of(context)
              .accentTextTheme
              .display2
              .copyWith(color: Colors.white),
        ),
        Text(
          ' ${AppStrings.of(context).project}',
          style: Theme.of(context).accentTextTheme.display1,
        ),
        Spacer(),
        FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            color: Colors.red.withOpacity(0.7),
            textColor: Colors.white.withOpacity(0.7),
            onPressed: () => {removeProject(context)},
            child: Row(
              children: <Widget>[
                Text(AppStrings.of(context).delete),
                SizedBox(width: 8),
                Icon(
                  Icons.delete,
                  size: 20,
                )
              ],
            )),
        SizedBox(width: 20),
        RaisedButton(
          elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            color: Colors.white,
            textColor: Theme.of(context).accentColor,
            onPressed: () => downloadFiles(context),
            child: Row(
              children: <Widget>[
                Text(AppStrings.of(context).download),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_downward,
                  size: 20,
                )
              ],
            ))
      ],
    );
  }

  void removeProject(BuildContext context) {
    showDialog(context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(AppStrings.of(context).deleteDialogTitle),
      content: Text(AppStrings.of(context).deleteDialogMessage),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.arbBloc.add(DeleteCurrentProject());
          },
          textColor: Colors.red.withOpacity(0.8),
          child: Text(AppStrings.of(context).delete),
        ),
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          textColor: Theme.of(context).accentColor,
          child: Text(AppStrings.of(context).cancel),
        )
      ],
    ));
  }

  void downloadFiles(BuildContext context) {
    final file = compress(context.arb);
    final fileName = '${context.arb.fileName}_intl.zip';
    download(file, fileName);
  }


  Blob compress(ArbProject project) {
    var output = OutputStream();
    var encode = ZipEncoder();
    encode.startEncode(output);

    final Map<String, String> arbFiles = project.documents
        .asMap()
        .map((_, doc) => MapEntry(doc.locale, doc.encode()));

    project.documents.forEach((doc) {
      final fileName = '${project.fileName}_${doc.locale}.arb';
      Blob file = Blob([doc.encode()], 'text/plain');
      final archive = ArchiveFile.noCompress(
          fileName, file.size, utf8.encode(doc.encode()));
      encode.addFile(archive);
    });

    final dartFileName = '${project.fileName}_strings.dart';
    String dartFileContent =
    LocalizationsGenerator(project).generateOutputFile();
    Blob file = Blob([dartFileContent], 'text/plain');
    final archive = ArchiveFile.noCompress(
        dartFileName, file.size, utf8.encode(dartFileContent));
    encode.addFile(archive);

    final messagesFiles = MessagesFileGenerator()
        .generateFiles(arbFiles, dartFileContent, dartFileName);

    messagesFiles.forEach((name, content) {
      Blob file = Blob([content], 'text/plain');
      final archive =
      ArchiveFile.noCompress(name, file.size, utf8.encode(content));
      encode.addFile(archive);
    });

    encode.endEncode();

    print(output);

    return Blob(
      [output.getBytes()],
      'application/zip',
    );
  }
}

