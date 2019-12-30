import 'package:arb/dart_arb.dart';
import 'package:arb_editor/arb_bloc/arb_bloc.dart';
import 'package:arb_editor/components/arb_drop_zone.dart';
import 'package:arb_editor/components/drop_zone.dart';
import 'package:arb_editor/pages/home/home_page.dart';
import 'package:arb_editor/pages/project_page/project_page.dart';
import 'package:fluid_layout/fluid_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'i18n/app_strings.dart';

import 'utils.dart';

void main() => runApp(ArbApp());

class ArbApp extends StatefulWidget {
  @override
  _App createState() => _App();
}

class _App extends State<ArbApp> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArbProjectBloc(),
      child: MaterialApp(
        supportedLocales: AppStrings.supportedLocales,
        locale: Locale('es', 'ES'),
        localizationsDelegates: AppStrings.localizationsDelegates,
        title: '.ARB Editor',
        theme: ThemeData(
          accentColor: Colors.deepPurpleAccent,
          scaffoldBackgroundColor: Colors.deepPurpleAccent,
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
          ),
          textTheme: TextTheme(
            body1: TextStyle(
              color: Colors.black.withOpacity(0.7)
            ),
            subtitle: TextStyle(
                color: Colors.black.withOpacity(0.7)
            )
          )
        ),
        home: AppContent(),
      ),
    );
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
