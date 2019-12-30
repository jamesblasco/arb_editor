import 'package:arb/dart_arb.dart';
import 'package:arb_editor/arb_bloc/arb_bloc.dart';
import 'package:arb_editor/utils.dart';
import 'package:flutter/material.dart';

import 'locale_tag.widget.dart';
import 'new_locale_dialog.widget.dart';

class LocaleTagSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 12,
      spacing: 12,
      children: context.arb.documents
          .map((doc) => LocaleTag(
                locale: doc.localeString,
                selected: doc.localeString == context.arb.defaultTemplate,
                onSelect: (_) => {},
              ))
          .toList()
            ..add(
              LocaleTag(
                locale: ' + ',
                selected: false,
                onSelect: (_) {
                  NewLocaleDialog.display(context, (newLocale) {
                    if (newLocale != null && newLocale.isNotEmpty)
                      print('selected');
                    context.arb..documents.add(ArbDocument(newLocale));
                    context.arbBloc.add(UpdateProject());
                  });
                },
              ),
            ),
    );
  }
}
