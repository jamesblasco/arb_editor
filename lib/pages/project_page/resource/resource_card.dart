import 'dart:math';

import 'package:arb/dart_arb.dart';
import 'package:arb_editor/arb_bloc/arb_bloc.dart';
import 'package:arb_editor/i18n/app_strings.dart';
import 'package:arb_editor/pages/project_page/resource/resurce_id_editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:arb_editor/utils.dart';

class ResourceCard extends StatefulWidget {
  final ArbResource resource;

  const ResourceCard({Key key, this.resource}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ResourceCardState();
}

class _ResourceCardState extends State<ResourceCard>
    with TickerProviderStateMixin {
  bool expanded = false;
  bool idError = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    child: ResourceIdEditor(
                        resource: widget.resource,
                        error: idError,
                        onEdit: (error) => setState(() => idError = error)),
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 12, bottom: 0),
                  ),
                ),
                Spacer(),
                if (idError)
                  Padding(
                padding:
                EdgeInsets.only(left: 20, right: 0, top: 12, bottom: 0),
                child:  Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .errorColor
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            AppStrings.of(context).idAlreadyExists,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: Theme.of(context)
                                .errorColor),
                          ))),
                Padding(
                    padding:
                        EdgeInsets.only(left: 20, right: 0, top: 12, bottom: 0),
                    child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).accentColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          calculatePercentegeDone(context),
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: Theme.of(context).accentColor),
                        ))),
                Padding(
                  padding:
                      EdgeInsets.only(left: 10, right: 20, top: 12, bottom: 0),
                  child: IconButton(
                    icon: Transform.rotate(
                      angle: expanded ? pi : 0,
                      child: Icon(Icons.keyboard_arrow_down),
                    ),
                    onPressed: () => {setState(() => expanded = !expanded)},
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
                    hintText: AppStrings.of(context).addDescription,
                    hoverColor: Colors.grey[200]),
              ),
              /*Text(
              widget.resource.description.isEmpty ? 'Add description' : widget.resource.description,
              style: Theme.of(context).textTheme.body1,
            ),*/
              padding: EdgeInsets.symmetric(horizontal: 20),
            ),
            SizedBox(height: 12),
            AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 300),
              child: !expanded
                  ? Container()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ...(List<Widget>.from(
                            context.arb.documents.map((doc) => Container(
                                color: Colors.grey[050],
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      color: Colors.grey[100],
                                      child: Text(doc.localeString),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: TextFormField(
                                          initialValue: doc
                                              .resources[widget.resource.id]
                                              ?.value
                                              ?.text,
                                          onChanged: (value) {
                                            if (doc.resources[
                                                    widget.resource.id] ==
                                                null) {
                                              print('create new widget');
                                              doc.resources[
                                                      widget.resource.id] =
                                                  widget.resource
                                                      .copyWith(value: value);
                                            } else {
                                              print('update widget');
                                              doc.resources[widget.resource.id]
                                                  ?.value?.text = value;
                                            }
                                            context.arbBloc
                                                .add(UpdateProject());
                                          },
                                          maxLines: 1,
                                          style:
                                              Theme.of(context).textTheme.body1,
                                          decoration: InputDecoration.collapsed(
                                              hintText: AppStrings.of(context).empty,
                                              hoverColor: Colors.grey[200]),
                                        ),
                                      ),
                                    )
                                  ],
                                ))))
                          ..addItemInBetween<Widget>(Divider(height: 10)))
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }

  String calculatePercentegeDone(BuildContext context) {
    int value = context.arb.documents
        .map((doc) => doc.resources[widget.resource.id] == null ? 0 : 1)
        .fold(0, (r, a) => r + a);
    return '${(value * 100) / context.arb.locales.length}%';
  }
}

extension ListUtils<T> on List<T> {
  List<T> addItemInBetween<T>(T item) =>
      this.fold([], (r, element) => [...r, element as T, item])..removeLast();
}
