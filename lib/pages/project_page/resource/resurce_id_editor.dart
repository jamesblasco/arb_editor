import 'package:arb/dart_arb.dart';
import 'package:arb_editor/arb_bloc/arb_event.dart';
import 'package:arb_editor/i18n/app_strings.dart';
import 'package:flutter/material.dart';

import '../../../utils.dart';

class ResourceIdEditor extends StatelessWidget {
  final ArbResource resource;
  final bool error;
  final Function(bool error) onEdit;
  const ResourceIdEditor({Key key, this.resource, this.onEdit, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: resource.id,
      onChanged: (newId) => updateId(context, newId),
      maxLines: null,
      style: Theme
          .of(context)
          .textTheme
          .title
          .copyWith(
          color: resource.id == 'undefined' || error
              ? Colors.red
              : Colors.black),
      decoration: InputDecoration.collapsed(
          hintText: AppStrings.of(context).id, hoverColor: Colors.grey[200]),
    );
  }

  updateId(BuildContext context, String newId) {
    onEdit?.call(context.arb.resources[newId] != null && newId != resource.id);
    if (context.arb.resources[newId] == null) {
      final oldId = resource.id;
      context.arb.resources[newId] = resource;
      context.arb.resources.remove(oldId);
      resource.id = newId;

      for (final doc in context.arb.documents) {
        final resource = doc.resources[oldId];
        resource.id = newId;
        doc.resources[newId] = resource;
        doc.resources.remove(oldId);
      }
      context.arbBloc.add(UpdateProject());
    } else {
      print('Resource id already exists');
    }
  }
}