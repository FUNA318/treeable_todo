import 'package:app/colors.dart';
import 'package:app/components/providers/todos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/todo.dart';

class PrecedingTodoDropdownFormField extends ConsumerWidget {
  PrecedingTodoDropdownFormField({
    super.key,
    this.todoId,
    this.defaultId,
    this.disabled = false,
  });

  final contentController = TextEditingController();
  final String? todoId;
  final String? defaultId;
  final bool disabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoListState = ref.watch(todoListProvider);

    final selectedId = ref.watch(selectedParentTodoIdProvider);

    return ButtonTheme(
      alignedDropdown: true,
      child: switch (todoListState) {
        AsyncData(:final value) => DropdownButtonFormField(
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: ThemeColors.outline, // const にするため
                width: 0.33,
              ),
            ),
            hintText: '先行する Todo',
            hintStyle: TextStyle(color: ThemeColors.outline),
          ),
          value: selectedId ?? defaultId ?? 'null',
          isDense: true,
          items:
              disabled
                  ? null
                  : [
                    const DropdownMenuItem(
                      value: 'null',
                      child: SizedBox(
                        width: 256,
                        child: Text(
                          '未設定',
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    ...value
                        .where((todo) => todo.id != todoId)
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.id,
                            child: SizedBox(
                              width: 256,
                              child: Text(
                                e.content,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                  ],
          onChanged: (value) {
            if (value == 'null') {
              ref.read(selectedParentTodoIdProvider.notifier).set('null');
            } else {
              ref.read(selectedParentTodoIdProvider.notifier).set(value);
            }
          },
          validator: (id) {
            Todo todo = value.firstWhere((e) => e.id == id);
            while (true) {
              if (todo.parentTodo == null) break;
              if (todo.parentTodo == todoId) {
                return '後続する TODO には紐づけられません。';
              }
              todo = value.firstWhere((e) => e.id == todo.parentTodo);
            }
            return null;
          },
        ),
        AsyncError() => const SizedBox(height: 64),
        _ => const SizedBox(height: 64),
      },
    );
  }
}
