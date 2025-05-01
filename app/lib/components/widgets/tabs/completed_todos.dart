import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../repositories/http_client.dart';
import '../../../repositories/todo.dart';
import '../../common/tile/todo_tile.dart';
import '../../providers/auth_user.dart';
import '../../providers/todos.dart';

class CompletedTodoListTab extends ConsumerStatefulWidget {
  const CompletedTodoListTab({super.key});

  @override
  ConsumerState<CompletedTodoListTab> createState() =>
      _CompletedTodoListTabState();
}

class _CompletedTodoListTabState extends ConsumerState<CompletedTodoListTab> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      try {
        ref.read(todoCompletedListProvider.notifier).fetch();
      } catch (e) {
        if (e is AuthException) {
          ref.invalidate(authUserProvider);
        }
      }
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final todoList = ref.watch(todoCompletedListProvider);

    if (todoList == null) return const SizedBox.shrink();

    return ReorderableListView.builder(
      onReorder: (oldIndex, newIndex) async {
        final newList = ref
            .read(todoUncompletedListProvider.notifier)
            .realign(oldIndex, newIndex);

        await TodoRepository().bulkUpdate(
          newList.map((e) => e.id).toList().reversed,
        );
        ref.read(todoCompletedListProvider.notifier).fetch();
      },
      itemCount: todoList.length,
      itemBuilder: (context, index) {
        final todo = todoList[index];
        return TodoTile(
          key: Key(todo.id),
          todo: todo,
          onDismissed: (DismissDirection direction) async {
            ref.read(todoCompletedListProvider.notifier).removeIndex(index);
            if (direction == DismissDirection.endToStart) {
              await TodoRepository().delete(todo.id);
            } else if (direction == DismissDirection.startToEnd) {
              await TodoRepository().partialUpdate(
                todo.id,
                completedAt: DateTime.now(),
              );
            }
            ref.read(todoCompletedListProvider.notifier).fetch();
          },
        );
      },
    );
  }
}
