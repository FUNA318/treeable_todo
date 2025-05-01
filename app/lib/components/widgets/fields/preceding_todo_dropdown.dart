import 'package:app/colors.dart';
import 'package:app/components/providers/todos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrecedingTodoDropdownFormField extends ConsumerWidget {
  PrecedingTodoDropdownFormField({super.key, this.todoId, this.defaultId});

  final contentController = TextEditingController();
  final String? todoId;
  final String? defaultId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoListState = ref.watch(todoListProvider);

    final selectedId = ref.watch(selectedParentTodoIdProvider);

    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonFormField(
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
        value: selectedId ?? defaultId,
        isDense: true,
        items: switch (todoListState) {
          AsyncData(:final value) => [
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
          AsyncError() => <DropdownMenuItem<String>>[],
          _ => <DropdownMenuItem<String>>[],
        },
        onChanged: (value) {
          if (value == 'null') {
            ref.read(selectedParentTodoIdProvider.notifier).set('null');
          } else {
            ref.read(selectedParentTodoIdProvider.notifier).set(value);
          }
        },
      ),
    );
  }
}
