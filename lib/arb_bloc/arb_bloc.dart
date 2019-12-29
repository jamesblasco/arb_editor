

import 'package:arb/dart_arb.dart';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';

mixin ArbBlocState {}

class Empty with  ArbBlocState {}
class Editing  with  ArbBlocState {
  final ArbProject project;

  Editing(this.project);
}

mixin ArbBlocEvent {}

class InitArbProject with ArbBlocEvent {
  final ArbProject project;

  InitArbProject(this.project);
}

class UpdateProject with ArbBlocEvent {

  UpdateProject();
}

class ClearProject with ArbBlocEvent {

  ClearProject();
}
class ArbProjectBloc extends Bloc<ArbBlocEvent, ArbBlocState> {
  ArbProject project;
  List<ArbProject> projects = [];
  Box<ArbProject> box;
  @override
  get initialState =>  Empty();

  ArbProjectBloc() {
    Hive.registerAdapter(ArbProjectAdapter(), 0);
    Hive.openBox<ArbProject>('projects').then((box)
    {
      this.box = box;
      if(box.values.isNotEmpty)
      projects = box.values.toList();
      if(state is Empty) add(ClearProject());
    });
  }

  @override
  Stream<ArbBlocState> mapEventToState(ArbBlocEvent event)  async* {
    print('hello');
    if(event is InitArbProject){
      print('is init');
      project = event.project;
      box.put(project.fileName, project);

      yield Editing(project);
    } else if (event is UpdateProject) {
      box.put(project.fileName, project);
      yield Editing(project);
    } else if (event is ClearProject) {
      project = null;
      print('is not init');
      yield Empty();
    }
  }



}

class ArbProjectAdapter extends TypeAdapter<ArbProject> {
  @override
  ArbProject read(BinaryReader reader) {
    return ArbProject.decode(reader.readString());
  }

  @override
  void write(BinaryWriter writer, ArbProject obj) {
    writer.writeString(obj.encode());
  }
}

