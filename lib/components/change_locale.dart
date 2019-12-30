import 'package:arb_editor/i18n/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeLocaleDropDownButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
     // value:  Provider.of<ValueNotifier<String>>(context).value,
      items: AppStrings.supportedLocales.map((local)  {
      return DropdownMenuItem(
        child: Text(local.toLocaleString),
      );
    }).toList(), onChanged: (local) {
      Provider.of<ValueNotifier<String>>(context).value = local.toLocaleString;
    });
  }
}

extension LocaleUtil on Locale {
  String get toLocaleString => '${this.languageCode}_${this.countryCode}';
}
