


import 'package:arb_editor/i18n/app_strings.dart';
import 'package:flutter/material.dart';

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
      title: Text(AppStrings.of(context).addLocale),
      content: TextField(
        controller: _textFieldController,
        decoration: InputDecoration(hintText: "en_US"),
      ),
      actions: <Widget>[
        FlatButton(
          child: new Text(AppStrings.of(context).cancel.toUpperCase()),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: new Text(AppStrings.of(context).create.toUpperCase()),
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
