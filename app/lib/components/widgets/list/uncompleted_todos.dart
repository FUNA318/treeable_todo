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
          physics: const NeverScrollableScrollPhysics(), // スクロールの競合を防ぐ
          shrinkWrap: true,
          onReorder: (oldIndex, newIndex) async {
            final newList = ref
                .read(todoUncompletedListProvider.notifier)
                .realign(depth, oldIndex, newIndex, todos[oldIndex].parentTodo);
            await TodoRepository().bulkUpdate(
              newList.where((e) => e.depth == depth).map((e) => e.id).toList(),
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
            final children =
                todoList
                    .where(
                      (v) => v.depth == depth + 1 && v.parentTodo == todo.id,
                    )
                    .toList();
            return Padding(
              key: Key(todo.id),
              padding: EdgeInsets.only(left: 16.0 * depth),
              child: Column(
                children: [
                  TodoTile(
                    todo: todo,
                    parentTodo: parentTodo,
                    children: children,
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
                      return true;
                    },
                  ),
                  children.isNotEmpty
                      ? UncompletedTodoListLayer(
                        depth: depth + 1,
                        parentTodoId: todo.id,
                      )
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
