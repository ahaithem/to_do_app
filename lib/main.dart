import 'package:flutter/material.dart';
import './contents/taskdatabase.dart';
import './contents/task.dart';
import './contents/task_item.dart'; // Your task item widget
import './contents/add_task_bottom_sheet.dart'; // Your add/edit task bottom sheet widget

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the TaskDatabase
  final taskDatabase = TaskDatabase();
  await taskDatabase.initialize();

  runApp(MyApp(taskDatabase: taskDatabase));
}

class MyApp extends StatelessWidget {
  final TaskDatabase taskDatabase;

  const MyApp({Key? key, required this.taskDatabase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(taskDatabase: taskDatabase),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final TaskDatabase taskDatabase;

  const MyHomePage({Key? key, required this.taskDatabase}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = widget.taskDatabase.getTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _tasksFuture = widget.taskDatabase.getTasks();
    });
  }

  Future<void> _addNewTask(
      String title, DateTime? date, TimeOfDay? time) async {
    final newTask = Task(title: title, date: date, time: time);
    await widget.taskDatabase.addTask(newTask);
    _loadTasks();
  }

  Future<void> _editTask(BuildContext context, Task task) async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return AddTaskBottomSheet(
          (title, date, time) async {
            task.title = title;
            task.date = date;
            task.time = time;
            await widget.taskDatabase.updateTask(task);
            _loadTasks();
          },
          task: task,
        );
      },
    );
  }

  Future<void> _finishTask(BuildContext context, Task task) async {
    await widget.taskDatabase.deleteTask(task.id);
    _loadTasks();
  }

  void _startAddNewTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return AddTaskBottomSheet((title, date, time) {
          _addNewTask(title, date, time);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Tasks',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Color(0xFF2C3E50),
      ),
      body: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No tasks added yet.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (ctx, index) {
                final task = snapshot.data![index];
                return TaskItem(
                  key: ValueKey(task.id),
                  task: task,
                  editTask: _editTask,
                  finishTask: _finishTask,
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewTask(context),
        child: const Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }
}
