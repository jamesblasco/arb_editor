import 'package:arb/dart_arb.dart';
import 'package:arb_editor/arb_bloc/arb_bloc.dart';
import 'package:arb_editor/utils.dart';
import 'package:flutter/material.dart';

class LocaleTagSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
        runSpacing: 12,
        spacing: 12,
        children: context.arb.documents
            .map((doc) => LocaleTag(
                  locale: doc.locale,
                  selected: doc.locale == context.arb.defaultTemplate,
                  onSelect: (_) => {},
                ))
            .toList()
              ..add(LocaleTag(
                locale: ' + ',
                selected: false,
                onSelect: (_) {
                  NewLocaleDialog.display(context, (newLocale) {
                    if (newLocale != null && newLocale.isNotEmpty)
                      print('selected');
                    context.arbBloc.add(InitArbProject(context.arb
                      ..documents.add(ArbDocument(newLocale))));
                  });
                },
              ),
              ),
    );
  }
}

class LocaleTag extends StatelessWidget {
  final String locale;
  final bool selected;
  final Function(String locale) onSelect;

  const LocaleTag(
      {Key key, @required this.locale, this.selected = false, this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => onSelect(locale),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: selected
                      ? Colors.white
                      : Colors.white30,
                  borderRadius: BorderRadius.circular(12)),
              child: Text(
                locale ?? 'undefined',
                style: selected
                    ? Theme.of(context).accentTextTheme.caption.copyWith(color: Theme.of(context).accentColor)
                    : Theme.of(context).accentTextTheme.caption,
              ),
            )));
  }
}

class NewLocaleDialog extends StatefulWidget {
  final Function(String) newLocale;

  const NewLocaleDialog({Key key, this.newLocale}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewLocaleDialogState();

  static display(BuildContext context, Function(String) newLocale) async {
    showDialog(
        context: context,
        builder: (context) {
          return NewLocaleDialog(
            newLocale: newLocale,
          );
        });
  }
}

class _NewLocaleDialogState extends State<NewLocaleDialog> {
  TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add new translation'),
      content: TextField(
        controller: _textFieldController,
        decoration: InputDecoration(hintText: "en_US"),
      ),
      actions: <Widget>[
         FlatButton(
          child: new Text('CANCEL'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: new Text('DONE'),
          onPressed: () {
            widget.newLocale(_textFieldController.text);
            Navigator.of(context).pop();
          },
        )
      ],
    );
    ;
  }
}
