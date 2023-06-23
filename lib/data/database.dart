import 'package:hive_flutter/hive_flutter.dart';

class CadernetafiadoDataBase {
  List CadernetafiadoList = [];

  final _myBox = Hive.box('mybox');

  void createInitialData() {
    CadernetafiadoList = [
      ["Tessele: DEVE UMA PIZZA", true],
      ["Elisson: DEVE OUTRA PIZZA", false],
    ];
  }

  void loadData() {
    CadernetafiadoList = _myBox.get("Caderneta do fiado");
  }

  void updateDataBase() {
    _myBox.put("Caderneta do fiado", CadernetafiadoList);
  }
}
