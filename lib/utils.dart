import 'package:arb/models/arb_project.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'arb_bloc/arb_bloc.dart';

extension BuilContextExtension on BuildContext {
  ArbProject get arb =>
      BlocProvider
          .of<ArbProjectBloc>(this)
          .project;

  ArbProjectBloc get arbBloc => BlocProvider.of<ArbProjectBloc>(this);
}

extension StringExtension on String {
  String capitalize() => this[0].toUpperCase() + this.substring(1);
}
