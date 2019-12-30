

import 'package:arb/dart_arb.dart';
import 'package:arb_editor/arb_bloc/arb_local_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';

import 'arb_event.dart';
import 'arb_state.dart';

export 'arb_state.dart';
export 'arb_event.dart';

class ArbProjectBloc extends Bloc<ArbBlocEvent, ArbBlocState> {
  ArbProject project;
  List<ArbProject> projects = [];

  ArbLocalRepository repository;
  @override
  get initialState =>  Empty();

  ArbProjectBloc() {
    repository = ArbLocalRepository();
    repository.projects.then((projects) {
      this.projects = projects;
      if(state is Empty) add(ClearProject());
    });
  }

  @override
  Stream<ArbBlocState> mapEventToState(ArbBlocEvent event)  async* {
    if(event is InitProject){
      project = event.project;
      yield Editing(project);
    } else if(event is CreateProject){
      project = event.project;
      projects.add(project);
      await repository.setProject(project);
      yield Editing(project);
    } else if (event is UpdateProject) {
      await repository.setProject(project);
      yield Editing(project);
    } else if (event is ClearProject) {
      project = null;
      yield Empty();
    } else if (event is DeleteCurrentProject) {
      await repository.removeProject(project);
      projects.remove(project);
      project = null;
      yield Empty();
    }
  }
}
