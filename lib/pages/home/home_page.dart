import 'package:arb/models/arb_project.dart';
import 'package:arb_editor/arb_bloc/arb_bloc.dart';
import 'package:arb_editor/components/arb_drop_zone.dart';
import 'package:fluid_layout/fluid_layout.dart';
import 'package:flutter/material.dart';
import 'package:arb_editor/utils.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Fluid(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 140),
              Image.asset(
                'images/arb-editor.png',
                height: 100,
                alignment: Alignment.center,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(height: 100),
              ArbDropZone(onArbDocumentsAdded: (files) {
                print('pre arbBloc');
                context.arbBloc
                    .add(InitArbProject(ArbProject('app', documents: files)));
                print(files.map((file) => file.locale));
              }),
              SizedBox(height: 80),
              Text('Recent projects', style: Theme.of(context).accentTextTheme.title),
              SizedBox(height: 12),
              FluidGridView(
                fluid: false,
                shrinkWrap: true,
                children: context.arbBloc.projects.map((project) =>
                  FluidCell.withFixedHeight(size: 3, height: 100, child: Card(
                    child: InkWell(
                      onTap: ()=> context.arbBloc.add(InitArbProject(project)),
                        child:
                    Center(
                      child: Text(project.fileName, style: Theme.of(context).textTheme.title,),
                    )
                  )))
                ).toList()
              )
            ],
          ),
        ),
      ),
    );
  }
}
