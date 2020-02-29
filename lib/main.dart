import 'dart:html';

import 'package:arb/dart_arb.dart';
import 'package:arb_editor/arb_bloc/arb_bloc.dart';
import 'package:arb_editor/components/arb_drop_zone.dart';
import 'package:arb_editor/components/drop_zone.dart';
import 'package:arb_editor/pages/home/home_page.dart';
import 'package:arb_editor/pages/project_page/project_page.dart';
import 'package:fluid_layout/fluid_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';
import 'package:provider/provider.dart';
import 'i18n/app_strings.dart';

import 'utils.dart';

void main() async {
  FlutterError.onError = (e) => print(e);
  runApp(ArbApp());
}

extension LocaleUtils on Locale {
  static Locale fromString(String localeString) {
    List<String> codes = localeString.split('_');
    return Locale(codes.first, codes.length > 1 ? codes[1] : null);
  }
}

class ArbApp extends StatefulWidget {
  @override
  _App createState() => _App();
}

class _App extends State<ArbApp> {
  ValueNotifier<String> locale;

  @override
  void initState() {

    locale = ValueNotifier(window.navigator.language.replaceAll('-', '_'));
    super.initState();
  }

  updateLocale() {
    setState(() => {});
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableProvider.value(
        value: locale,
        child: ValueListenableBuilder(
          valueListenable: locale,
          builder:  (_, __, ___)=>BlocProvider(
          create: (_) => ArbProjectBloc(),
          child: MaterialApp(
            locale: AppStrings.delegate.isSupported(LocaleUtils.fromString(locale.value)) ? LocaleUtils.fromString(locale.value) : null,
            supportedLocales: AppStrings.supportedLocales,
            localizationsDelegates: AppStrings.localizationsDelegates,
            title: '.ARB Editor',
            theme: ThemeData(
                accentColor: Colors.deepPurpleAccent,
                scaffoldBackgroundColor: Colors.deepPurpleAccent,
                cardTheme: CardTheme(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                textTheme: TextTheme(
                    body1: TextStyle(color: Colors.black.withOpacity(0.7)),
                    subtitle: TextStyle(color: Colors.black.withOpacity(0.7)))),
            home: AppContent(),
          ),
        )));
  }
}

class AppContent extends StatefulWidget {
  AppContent({Key key}) : super(key: key);

  @override
  _AppContentState createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: context.arbBloc,
        builder: (_, arb) {
          if (context.arb == null)
            return FluidLayout(
              child: HomePage(),
            );
          else
            return FluidLayout(
              horizontalPadding: FluidValue((_) => 20),
              child: ProjectPage(),
            );
        });
  }
}
