import 'dart:convert';
import 'dart:html';

import 'package:arb/dart_arb.dart';
import 'package:arb_editor/arb_bloc/arb_bloc.dart';
import 'package:arb_editor/components/download_button.dart';
import 'package:arb_editor/generate/generate_string_file.dart';
import 'package:arb_editor/generate/messages_file_generator.dart';
import 'package:arb_editor/i18n/app_strings.dart';

import 'package:arb_editor/pages/project_page/create_resource_card.dart';
import 'package:arb_editor/pages/project_page/locale_tag_selector.dart';
import 'package:arb_editor/pages/project_page/resource_card.dart';
import 'package:archive/archive.dart';

import '../../main.dart';
import 'package:fluid_layout/fluid_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:arb_editor/utils.dart';

class ProjectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPadding(padding: EdgeInsets.all(30)),
          SliverFluid(
              sliver: SliverToBoxAdapter(
                  child: GestureDetector(
                    onTap: () => {
                    context.arbBloc.add(ClearProject())
                  },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'images/arb-editor.png',
                        height: 60,
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.fitHeight,
                      ),),
                  ))),
          SliverPadding(padding: EdgeInsets.all(20)),
          SliverFluid(
            sliver: SliverToBoxAdapter(
                child: Row(
                  textBaseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: <Widget>[
                    Text(
                      context.arb.fileName.capitalize(),
                      style: Theme
                          .of(context)
                          .accentTextTheme
                          .display2
                          .copyWith(color: Colors.white),
                    ),
                    Text(
                      ' project',
                      style: Theme
                          .of(context)
                          .accentTextTheme
                          .display1,
                    ),
                  ],
                )),
          ),
          SliverPadding(padding: EdgeInsets.all(8)),
          SliverFluid(sliver: SliverToBoxAdapter(child: LocaleTagSelector())),
          SliverPadding(padding: EdgeInsets.all(12)),
          SliverFluid(sliver: SliverToBoxAdapter(child: Container(
            color: Colors.white.withOpacity(0.2),
            width: double.infinity,
            height: 1,))),
          SliverPadding(padding: EdgeInsets.all(12)),
          SliverFluidGrid(
            children: context.arb.resources.values
                .map((resource) =>
                FluidCell.fit(
                    size: context.fluid(12, xl: 6),
                    child: ResourceCard(resource: resource)))
                .toList()
              ..add(FluidCell.fit(size: 12, child: CreateResourceCard())),
          ),
          SliverSafeArea(
            sliver: SliverPadding(padding: EdgeInsets.all(100)),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final file = compress(context.arb);
          final fileName = '${context.arb.fileName}_intl.zip';
          download(file, fileName);
        },
        child: Icon(Icons.arrow_downward),
      ),
    );
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
