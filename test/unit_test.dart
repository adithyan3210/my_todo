import 'package:flutter_test/flutter_test.dart';
import 'package:mytodo/provider/task_provider.dart';

void main() {
  group('TaskProvider - Add Task', () {
    test('should add a new task correctly', () {
      // Arrange
      final taskProvider = TaskProvider();

      // Act
      taskProvider.addTask('Test Task', 'Test Description');

      // Assert
      expect(taskProvider.tasks.length, 1);
      expect(taskProvider.tasks.first.title, 'Test Task');
      expect(taskProvider.tasks.first.description, 'Test Description');
      expect(taskProvider.tasks.first.isCompleted, false);
    });
  });
}
