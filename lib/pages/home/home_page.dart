import 'package:arb/models/arb_project.dart';
import 'package:arb_editor/arb_bloc/arb_bloc.dart';
import 'package:arb_editor/components/arb_drop_zone.dart';
import 'package:arb_editor/components/change_locale.dart';
import 'package:arb_editor/i18n/app_strings.dart';
import 'package:arb_editor/pages/home/project_card.widget.dart';
import 'package:fluid_layout/fluid_layout.dart';
import 'package:flutter/material.dart';
import 'package:arb_editor/utils.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Fluid(
        child: Fluid(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 100),
              Image.asset(
                'images/arb-editor.png',
                height: 100,
                alignment: Alignment.center,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(height: 60),
              ArbDropZone(onArbDocumentsAdded: (name, files) {
                print('pre arbBloc');
                context.arbBloc
                    .add(CreateProject(ArbProject(name, documents: files)));
              }),
              SizedBox(height: 60),
              Text(AppStrings.of(context).recentProjects,
                  style: Theme.of(context).accentTextTheme.title),
              SizedBox(height: 12),
              FluidGridView(
                  fluid: false,
                  shrinkWrap: true,
                  children: context.arbBloc.projects
                      .map((project) => FluidCell.withFixedHeight(
                            size: 3,
                            height: 100,
                            child: ProjectCard(project: project),
                          ))
                      .toList()),
              SizedBox(height: 40),
              Row(
                children: <Widget>[
                  Spacer(),
                //  ChangeLocaleDropDownButton()
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
