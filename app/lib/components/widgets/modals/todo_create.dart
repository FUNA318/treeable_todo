import 'package:app/repositories/todo.dart';
import 'package:app/components/providers/todos.dart';
import 'package:app/components/common/styles/field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/styles/button.dart';
import '../fields/preceding_todo_dropdown.dart';

class TodoCreateFormModal extends ConsumerWidget {
  TodoCreateFormModal({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8,
              children: [
                Text('新規追加', style: textTheme.headlineSmall),
                const SizedBox(height: 24),
                PrecedingTodoDropdownFormField(),
                const SizedBox.shrink(),
                TextFormField(
                  controller: contentController,
                  decoration: TextInputFieldStyles.outlinedTextFieldStyle
                      .copyWith(hintText: '内容'),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '内容を入力してください。';
                    } else if (value.length > 500) {
                      return '内容が長すぎます。';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        style: FilledButtonStyles.primaryFilledButtonStyle,
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          _formKey.currentState?.save();

                          final selectedId = ref.watch(
                            selectedParentTodoIdProvider,
                          );

                          await TodoRepository().create(
                            content: contentController.text,
                            parentTodoId:
                                selectedId != null && selectedId != 'null'
                                    ? selectedId
                                    : null,
                          );
                          ref
                              .read(todoUncompletedListProvider.notifier)
                              .fetch();
                          ref.read(todoCompletedListProvider.notifier).fetch();
                          if (!context.mounted) return;
                          context.pop();
                        },
                        child: const Text('追加する'),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButtonStyles.primaryTextButtonStyle,
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text('キャンセル'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
