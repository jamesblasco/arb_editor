


import 'package:arb/models/arb_project.dart';

mixin ArbBlocState {}

class Empty with  ArbBlocState {}

class Editing  with  ArbBlocState {
  final ArbProject project;

  Editing(this.project);
}