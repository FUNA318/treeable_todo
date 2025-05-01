import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/todo.dart';
import '../../../repositories/todo.dart';
import '../../common/tile/todo_tile.dart';
import '../../providers/todos.dart';

class UncompletedTodoListLayer extends ConsumerWidget {
  const UncompletedTodoListLayer({
    super.key,
    this.depth = 0,
    this.parentTodoId,
  });

  final int depth;
  final String? parentTodoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoUncompletedListProvider);

    if (todoList == null) return const SizedBox.shrink();

    final todos =
        todoList
            .where(
              (todo) =>
                  parentTodoId == null
                      ? todo.depth == depth
                      : todo.depth == depth && todo.parentTodo == parentTodoId,
            )
            .toList();

    return Column(
      children: [
        ReorderableListView.builder(
          shrinkWrap: true,
          onReorder: (oldIndex, newIndex) async {
            final newList = ref
                .read(todoUncompletedListProvider.notifier)
                .realign(oldIndex, newIndex);
            await TodoRepository().bulkUpdate(
              newList.map((e) => e.id).toList(),
            );
            ref.read(todoUncompletedListProvider.notifier).fetch();
          },
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            Todo? parentTodo;
            if (todoList.any((v) => v.parentTodo == todo.id)) {
              parentTodo = todoList.firstWhere((v) => v.parentTodo == todo.id);
            }
            final isExistNext = todoList.any(
              (v) => v.depth == depth + 1 && v.parentTodo == todo.id,
            );
            return Padding(
              key: Key(todo.id),
              padding: EdgeInsets.only(left: 16.0 * depth),
              child: Column(
                children: [
                  TodoTile(
                    todo: todo,
                    parentTodo: parentTodo,
                    onDismissed: (DismissDirection direction) async {
                      ref
                          .read(todoUncompletedListProvider.notifier)
                          .removeIndex(index);
                      if (direction == DismissDirection.endToStart) {
                        await TodoRepository().delete(todo.id);
                      } else if (direction == DismissDirection.startToEnd) {
                        await TodoRepository().partialUpdate(
                          todo.id,
                          completedAt: DateTime.now(),
                        );
                      }
                      ref.read(todoUncompletedListProvider.notifier).fetch();
                    },
                  ),
                  isExistNext
                      ? UncompletedTodoListLayer(depth: depth + 1)
                      : const SizedBox.shrink(),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
