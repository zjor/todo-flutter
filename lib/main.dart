import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'TODO Flutter App'),
    );
  }
}

class TaskWidget extends StatefulWidget {

  final Task _task;

  TaskWidget(this._task);

  @override
  State<StatefulWidget> createState() => _TaskState(_task);

}

class _TaskState extends State<TaskWidget> {

  final Task _task;
  
  _TaskState(this._task);

  void toggleDone(value) {
    setState(() {
      _task.done = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => toggleDone(!_task.done),
      child: Row(
        children: <Widget>[
          Checkbox(value: _task.done, onChanged: toggleDone),
          Text(
              _task.name,
              style: TextStyle(decoration: _task.done ? TextDecoration.lineThrough : TextDecoration.none)),
        ],
      )
    );
  }

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> _items = [
    Task("Work"),
    Task("Play"),
    Task("Love")];

  Future<void> _showAddTaskDialog() async {
    TextEditingController controller = TextEditingController();
    Future<String> future = showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Task"),
          content: TextField(controller: controller),
          actions: <Widget>[
            FlatButton(
              child: Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
            )
          ],
        );
      }
    );
    return future.then((value) {
      setState(() {
        _items.add(Task(value));
      });
    });
  }

  void _popupMenuClicked(String item) {
    if (item == "clear") {
      setState(() {
        _items.clear();
      });
    }
  }
  
  List<Widget> _buildItems() {
    return _items.map((item) => Container(
        height: 50,
        child: TaskWidget(item)
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _popupMenuClicked,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: "clear",
                  child: Text("Clear"),
                )
              ];
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: _buildItems(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class Task {

  String _name;
  bool _done;

  Task(this._name) : _done = false;

  get name => _name;

  get done => _done;

  set done(isDone) => _done = isDone;

}