
import 'package:arb/models/arb_project.dart';
import 'package:arb_editor/arb_bloc/arb_bloc.dart';
import 'package:arb_editor/i18n/app_strings.dart';
import 'package:flutter/material.dart';
import '../../utils.dart';

class ProjectCard extends StatelessWidget {
  final ArbProject project;

  const ProjectCard({Key key, this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.arbBloc.add(InitProject(project)),
        child: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  project.fileName,
                  style: Theme.of(context).textTheme.title,
                ),
                Text(
                  '${AppStrings.of(context).lastUpdate} :\n${project.lastModified.toUtc()}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            )
        ),
      ),
    );
  }
}
