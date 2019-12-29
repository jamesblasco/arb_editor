import 'dart:math';

import 'package:arb/dart_arb.dart';
import 'package:arb_editor/arb_bloc/arb_bloc.dart';
import 'package:arb_editor/i18n/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:arb_editor/utils.dart';

class ResourceCard extends StatefulWidget {
  final ArbResource resource;

  const ResourceCard({Key key, this.resource}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ResourceCardState();
}

class _ResourceCardState extends State<ResourceCard> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(child: Padding(
                  child: TextFormField(
                    initialValue: widget.resource.id,
                    onChanged: (id) {
                      final oldId = widget.resource.id;
                      context.arb.resources[id] = widget.resource;
                      context.arb.resources.remove(oldId);
                      widget.resource.id = id;

                      for(final doc in context.arb.documents) {
                        final resource = doc.resources[oldId];
                        resource.id = id;
                        doc.resources[id] = resource;
                        doc.resources.remove(oldId);
                      }
                      context.arbBloc.add(UpdateProject());
                    },
                    maxLines: 1,
                    style: Theme.of(context).textTheme.title,
                    decoration: InputDecoration.collapsed(
                        hintText: 'Id', hoverColor: Colors.grey[200]),
                  ),
                  padding: EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 0),
                ),),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 0, top: 12, bottom: 0),
                  child: Text(calculatePercentegeDone(context), style: Theme.of(context).textTheme.body2.copyWith(color: Theme.of(context).accentColor),)
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 20, top: 12, bottom: 0),
                  child: IconButton(
                    icon: Transform.rotate(angle: expanded ? pi : 0, child: Icon(Icons.keyboard_arrow_down),),
                    onPressed: () => {
                      setState(() => expanded = !expanded)
                    },
                  ),
                )
              ],
            ),
            Padding(
              child: TextFormField(
                initialValue: widget.resource.description,
                onChanged: (value) {
                  widget.resource.description = value;
                  context.arbBloc.add(UpdateProject());
                },
                maxLines: 1,
                style: Theme.of(context).textTheme.subtitle,
                decoration: InputDecoration.collapsed(
                    hintText: AppStrings.of(context).addDescription, hoverColor: Colors.grey[200]),
              ),
              /*Text(
              widget.resource.description.isEmpty ? 'Add description' : widget.resource.description,
              style: Theme.of(context).textTheme.body1,
            ),*/
              padding: EdgeInsets.symmetric(horizontal: 20),
            ),
            SizedBox(height: 12),
            if(expanded)
            ...(List<Widget>.from(context.arb.documents.map((doc) => Container(
                color: Colors.grey[050],
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.grey[100],
                      child: Text(doc.locale),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: TextFormField(
                          initialValue:
                              doc.resources[widget.resource.id]?.value?.text,
                          onChanged: (value) {
                            if (doc.resources[widget.resource.id] == null)
                              doc.resources[widget.resource.id] =
                                  widget.resource.copyWith(value: value);
                            else
                              doc.resources[widget.resource.id]?.value?.text =
                                  value;
                            context.arbBloc.add(UpdateProject());
                          },
                          maxLines: 1,
                          style: Theme.of(context).textTheme.body1,
                          decoration: InputDecoration.collapsed(
                              hintText: 'Empty', hoverColor: Colors.grey[200]),
                        ),
                      ),
                    )
                  ],
                ))))
              ..addItemInBetween<Widget>(Divider(height: 10)))
          ],
        ),
      ),
    );
  }

  String calculatePercentegeDone(BuildContext context) {
    int value = context.arb.documents.map((doc) => doc.resources[widget.resource.id] == null ? 0 : 1).fold(0, (r, a) => r+a);
    return '${(value * 100)/context.arb.locales.length}%';
  }
}

extension ListUtils<T> on List<T> {
  List<T> addItemInBetween<T>(T item) =>
      this.fold([], (r, element) => [...r, element as T, item])..removeLast();
}
