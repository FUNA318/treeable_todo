import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/todo.dart';
import '../../widgets/modals/todo_update.dart';

class TodoTile extends ConsumerWidget {
  const TodoTile({
    super.key,
    required this.todo,
    required this.onDismissed,
    this.parentTodo,
  });

  final Todo todo;
  final Todo? parentTodo;
  final void Function(DismissDirection)? onDismissed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorTheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final completedDiff = todo.completedAt?.compareTo(DateTime.now());
    final isCompleted = completedDiff != null && completedDiff > 0;

    final parentCompletedDiff = parentTodo?.completedAt?.compareTo(
      DateTime.now(),
    );
    final parentIsCompleted =
        parentCompletedDiff != null && parentCompletedDiff > 0;

    return Dismissible(
      key: Key(todo.id),
      onDismissed: onDismissed,
      direction:
          isCompleted || !parentIsCompleted
              ? DismissDirection.endToStart
              : DismissDirection.horizontal,
      secondaryBackground: Container(
        color: colorTheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Icon(Icons.delete, color: colorTheme.onPrimary),
      ),
      background: Container(
        color: colorTheme.primary,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Icon(Icons.check, color: colorTheme.onPrimary),
      ),
      child: ListTile(
        trailing:
            isCompleted || parentIsCompleted
                ? Icon(Icons.check, color: colorTheme.primary)
                : null,
        title: Text(todo.content),
        titleTextStyle: textTheme.bodyLarge?.copyWith(
          overflow: TextOverflow.ellipsis,
        ),
        splashColor: colorTheme.secondaryContainer,
        onTap: () {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return FractionallySizedBox(
                heightFactor: 0.75,
                child: TodoUpdateFormModal(todo: todo, parentTodo: parentTodo),
              );
            },
          );
        },
      ),
    );
  }
}
