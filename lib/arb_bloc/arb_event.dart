
import 'package:arb/models/arb_project.dart';

mixin ArbBlocEvent {}

class InitProject with ArbBlocEvent {
  final ArbProject project;

  InitProject(this.project);
}

class CreateProject with ArbBlocEvent {
  final ArbProject project;

  CreateProject(this.project);
}

class UpdateProject with ArbBlocEvent {
  UpdateProject();
}

class ClearProject with ArbBlocEvent {
  ClearProject();
}

class DeleteCurrentProject with ArbBlocEvent {
  DeleteCurrentProject();
}
