import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/database.dart';
import '../util/dialog_box.dart';
import '../util/caderneta.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  CadernetafiadoDataBase db = CadernetafiadoDataBase();

  @override
  void initState() {
    if (_myBox.get("Caderneta do Fiado") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    super.initState();
  }

  final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.CadernetafiadoList[index][1] = !db.CadernetafiadoList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewTask() {
    setState(() {
      db.CadernetafiadoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.CadernetafiadoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/nome_da_imagem.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text('Caderneta do Fiado Diária'),
              elevation: 0,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: createNewTask,
              child: Icon(Icons.add),
            ),
            body: ListView.builder(
              itemCount: db.CadernetafiadoList.length,
              itemBuilder: (context, index) {
                return CadernetafiadoTile(
                  taskName: db.CadernetafiadoList[index][0],
                  taskCompleted: db.CadernetafiadoList[index][1],
                  onChanged: (value) => checkBoxChanged(value, index),
                  deleteFunction: (context) => deleteTask(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CadernetafiadoTile extends StatelessWidget {
  final String taskName;
  final bool taskCompleted;
  final Function(bool?) onChanged;
  final Function(BuildContext) deleteFunction;

  const CadernetafiadoTile({
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(taskName),
      leading: Checkbox(
        value: taskCompleted,
        onChanged: onChanged,
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => deleteFunction(context),
      ),
    );
  }
}
