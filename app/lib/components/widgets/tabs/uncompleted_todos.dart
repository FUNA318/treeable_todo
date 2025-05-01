import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../repositories/http_client.dart';
import '../../providers/auth_user.dart';
import '../../providers/todos.dart';
import '../list/umcompleted_todos_layer.dart';

class UncompletedTodoListTab extends ConsumerStatefulWidget {
  const UncompletedTodoListTab({super.key});

  @override
  ConsumerState<UncompletedTodoListTab> createState() =>
      _UncompletedTodoListTabState();
}

class _UncompletedTodoListTabState
    extends ConsumerState<UncompletedTodoListTab> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      try {
        ref.read(todoUncompletedListProvider.notifier).fetch();
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
    final todoList = ref.watch(todoUncompletedListProvider);

    if (todoList == null) return const SizedBox.shrink();

    return const UncompletedTodoListLayer();
  }
}
