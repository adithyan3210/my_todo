import 'package:flutter/foundation.dart';
import '../model/task_model.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];
  //unmod tasks is read-only outside the provider
  List<Task> get tasks => List.unmodifiable(_tasks);

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  List<Task> get incompleteTasks =>
      _tasks.where((task) => !task.isCompleted).toList();

  int get taskCount => _tasks.length;

  int get completedTaskCount => completedTasks.length;

  void addTask(String title, String description) {
    if (title.trim().isEmpty) return;
    final task = Task(title: title.trim(), description: description.trim());
    _tasks.add(task);
    notifyListeners();
  }

  void toggleTaskComplete(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index].toggleComplete();
      notifyListeners();
    }
  }

  void deleteTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
      notifyListeners();
    }
  }

  void updateTask(int index, String title, String description) {
    if (index >= 0 && index < _tasks.length && title.trim().isNotEmpty) {
      _tasks[index] = _tasks[index].copyWith(
        title: title.trim(),
        description: description.trim(),
      );
      notifyListeners();
    }
  }

  void clearAllTasks() {
    _tasks.clear();
    notifyListeners();
  }

  void clearCompletedTasks() {
    _tasks.removeWhere((task) => task.isCompleted);
    notifyListeners();
  }
}
