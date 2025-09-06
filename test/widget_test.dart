import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mytodo/provider/task_provider.dart';
import 'package:mytodo/screens/todo_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('tapping Add Task opens Add New Task dialog', (tester) async {
    // Arrange
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => TaskProvider(),
        child: MaterialApp(home: TodoScreen()),
      ),
    );

    // Assert initial state
    expect(find.text('No tasks yet!'), findsOneWidget);
    expect(find.text('Add Task'), findsOneWidget);

    // Act: tap "Add Task"
    await tester.tap(find.text('Add Task'));
    await tester.pumpAndSettle();

    // Assert: dialog shows up
    expect(find.text('Add New Task'), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Description (Optional)'), findsOneWidget);
  });
}
