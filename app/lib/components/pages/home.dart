import 'package:app/components/widgets/modals/todo_create.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/tabs/completed_todos.dart';
import '../widgets/tabs/uncompleted_todos.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorTheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('ToDo リスト', style: textTheme.headlineSmall),
          backgroundColor: colorTheme.secondaryContainer,
          bottom: const TabBar(
            tabs: [Tab(text: 'ToDo'), Tab(text: 'Completed')],
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [UncompletedTodoListTab(), CompletedTodoListTab()],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return FractionallySizedBox(
                  heightFactor: 0.75,
                  child: TodoCreateFormModal(),
                );
              },
            );
          },
          backgroundColor: colorTheme.primary,
          foregroundColor: colorTheme.onPrimary,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
