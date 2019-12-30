
import 'package:arb/dart_arb.dart';
import 'package:hive/hive.dart';

class ArbLocalRepository {
  Box<ArbProject> box;

  ArbLocalRepository() {
    Hive.registerAdapter(ArbProjectAdapter(), 0);
  }

  Future<List<ArbProject>> get projects async {
    if(box == null) await setupBox();
    return box.values.toList();
  }

  Future  setProject(ArbProject project) async {
    if(box == null) await setupBox();
    return box.put(project.fileName, project);
  }

  Future removeProject(ArbProject project) async {
    if(box == null) await setupBox();
    return box.delete(project.fileName);
  }

  Future setupBox() async {
    this.box = await Hive.openBox<ArbProject>('projects');
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

