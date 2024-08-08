import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart'; // Import this package for directory access
import 'task.dart'; // Ensure this file contains the Task model

class TaskDatabase {
  late final Isar _isar;

  // Singleton pattern to ensure only one instance of TaskDatabase
  static final TaskDatabase _instance = TaskDatabase._internal();

  factory TaskDatabase() {
    return _instance;
  }

  TaskDatabase._internal();

  Future<void> initialize() async {
    final directory =
        await getApplicationDocumentsDirectory(); // Get app's document directory
    _isar = await Isar.open(
      [TaskSchema],
      directory: directory.path, // Specify the directory
    );
  }

  Isar get isar => _isar;

  // Add a new task
  Future<void> addTask(Task task) async {
    await _isar.writeTxn(() async {
      await _isar.tasks.put(task);
    });
  }

  // Retrieve all tasks
  Future<List<Task>> getTasks() async {
    return _isar.tasks.where().findAll();
  }

  // Update an existing task
  Future<void> updateTask(Task task) async {
    await _isar.writeTxn(() async {
      await _isar.tasks.put(task);
    });
  }

  // Delete a task
  Future<void> deleteTask(int id) async {
    await _isar.writeTxn(() async {
      await _isar.tasks.delete(id);
    });
  }
}
