import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/task_model.dart';
import '../provider/task_provider.dart';
import 'widgets/add_task_dialoge.dart';
import 'widgets/task_item.dart';
import 'widgets/task_stats.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        toolbarHeight: 70,
        title: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.orange[200],
              child: const Text('👨🏽', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hello,',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const Text(
                  'Adithyan ks',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_active, size: 20),
              onPressed: () {},
              color: Colors.black,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Consumer<TaskProvider>(
              builder: (context, taskProvider, child) {
                return PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert_outlined,
                    size: 20,
                    color: Colors.black,
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'clear_all':
                        _showClearDialog(context, taskProvider, 'all');
                        break;
                      case 'clear_completed':
                        _showClearDialog(context, taskProvider, 'completed');
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'clear_completed',
                          enabled: taskProvider.completedTaskCount > 0,
                          child: const Text('Clear Completed'),
                        ),
                        PopupMenuItem<String>(
                          value: 'clear_all',
                          enabled: taskProvider.taskCount > 0,
                          child: const Text('Clear All'),
                        ),
                      ],
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const TaskStats(),
          Expanded(child: _buildTaskList()),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 56,
        child: ElevatedButton.icon(
          onPressed: () => _showAddTaskDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            elevation: 6,
            shadowColor: Colors.blue.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          icon: const Icon(Icons.add, size: 24),
          label: const Text(
            'Add Task',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        if (taskProvider.tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.task_alt,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'No tasks yet!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the + button to add your first task',
                  style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          key: const Key('task_list'),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: taskProvider.tasks.length,
          itemBuilder: (context, index) {
            final task = taskProvider.tasks[index];
            return TaskItem(
              task: task,
              onToggle: () => taskProvider.toggleTaskComplete(index),
              onDelete: () => _showDeleteDialog(context, taskProvider, index),
              onEdit: () => _showEditTaskDialog(context, task, index),
            );
          },
        );
      },
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const AddTaskDialog());
  }

  void _showEditTaskDialog(BuildContext context, Task task, int index) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(task: task, index: index),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    TaskProvider taskProvider,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              taskProvider.deleteTask(index);
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(
    BuildContext context,
    TaskProvider taskProvider,
    String type,
  ) {
    final title = type == 'all' ? 'Clear All Tasks' : 'Clear Completed Tasks';
    final content = type == 'all'
        ? 'Are you sure you want to delete all tasks?'
        : 'Are you sure you want to delete all completed tasks?';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (type == 'all') {
                taskProvider.clearAllTasks();
              } else {
                taskProvider.clearCompletedTasks();
              }
              Navigator.of(context).pop();
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
