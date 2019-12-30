
import 'package:arb_editor/arb_bloc/arb_bloc.dart';

import '../../utils.dart';
import 'package:flutter/cupertino.dart';
import 'dart:js' as js;

class AppHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () => {
            context.arbBloc.add(ClearProject())
          },
          child: Container(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'images/arb-editor.png',
              height: 60,
              alignment: Alignment.centerLeft,
              fit: BoxFit.fitHeight,
            ),),
        ),
        Spacer(),
        GestureDetector(
          onTap: () => {
            js.context.callMethod("open", ["https://github.com/jamesblasco/arb_editor"])
          },
          child: Container(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'images/github.png',
              height: 40,
              alignment: Alignment.centerLeft,
              fit: BoxFit.fitHeight,
            ),),
        )
      ],
    );
  }

}