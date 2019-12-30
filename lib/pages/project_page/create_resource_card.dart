import 'package:arb/dart_arb.dart';
import 'package:arb_editor/arb_bloc/arb_bloc.dart';
import 'package:arb_editor/i18n/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:arb_editor/utils.dart';

class CreateResourceCard extends StatefulWidget {
  final Function(ArbResource resource) resource;

  const CreateResourceCard({Key key, this.resource}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ResourceCardState();
}

class _ResourceCardState extends State<CreateResourceCard> {
  @override
  Widget build(BuildContext context) {
    return  Material(
          color: Colors.transparent,
          child: InkWell(
              borderRadius: BorderRadius.circular(8),
            onTap: ()  {
              if(context.arb.resources['undefined'] == null) {
                context.arb.resources['undefined'] =
                    ArbResource('undefined', '');
                context.arbBloc.add(UpdateProject());
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('There is already an undefined field',),
                  backgroundColor: Colors.red,
                ));
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(8)
              ),
              padding: EdgeInsets.all(12),
              alignment: Alignment.center,
              child: Text(AppStrings.of(context).newResource, style: Theme.of(context).accentTextTheme.body2,),
          ),
      )
    );
  }
}

extension ListUtils<T> on List<T> {
  List<T> addItemInBetween<T>(T item) =>
      this.fold([], (r, element) => [...r, element as T, item])..removeLast();
}
