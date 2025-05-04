import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../repositories/http_client.dart';
import '../../providers/auth_user.dart';
import '../../providers/todos.dart';
import '../list/completed_todos.dart';

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

    return const SingleChildScrollView(
      child: Column(children: [CompletedTodoListLayer()]),
    );
  }
}
