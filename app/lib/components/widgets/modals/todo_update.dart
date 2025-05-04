import 'package:app/models/todo.dart';
import 'package:app/repositories/todo.dart';
import 'package:app/components/providers/todos.dart';
import 'package:app/components/common/styles/field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../common/styles/button.dart';
import '../fields/preceding_todo_dropdown.dart';

class TodoUpdateFormModal extends ConsumerStatefulWidget {
  const TodoUpdateFormModal({
    super.key,
    required this.todo,
    required this.children,
    this.parentTodo,
  });

  final Todo todo;
  final Todo? parentTodo;
  final List<Todo> children;

  @override
  TodoUpdateFormModalState createState() => TodoUpdateFormModalState();
}

class TodoUpdateFormModalState extends ConsumerState<TodoUpdateFormModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    contentController.text = widget.todo.content;
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;

    final completedDiff = widget.todo.completedAt?.compareTo(DateTime.now());
    final isCompleted = completedDiff != null && completedDiff > 0;

    final dateFormat = DateFormat('完了日: yyyy/MM/dd');

    final parentCompletedDiff = widget.parentTodo?.completedAt?.compareTo(
      DateTime.now(),
    );
    final parentIsCompleted =
        parentCompletedDiff != null && parentCompletedDiff > 0;

    final isCompletable =
        !isCompleted && !(widget.todo.parentTodo != null && !parentIsCompleted);

    final childrenIsCompleted = widget.children.any((e) {
      final completedDiff = e.completedAt?.compareTo(DateTime.now());
      final isCompleted = completedDiff != null && completedDiff > 0;
      return isCompleted;
    });

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                  child:
                      isCompletable || (isCompleted && !childrenIsCompleted)
                          ? TextButton(
                            style: TextButtonStyles.primaryTextButtonStyle,
                            onPressed: () async {
                              await TodoRepository().update(
                                widget.todo.id,
                                completedAt:
                                    isCompleted ? null : DateTime.now(),
                                content: widget.todo.content,
                                parentTodoId: widget.todo.parentTodo,
                              );
                              ref
                                  .read(todoUncompletedListProvider.notifier)
                                  .fetch();
                              ref
                                  .read(todoCompletedListProvider.notifier)
                                  .fetch();
                              if (!context.mounted) return;
                              context.pop();
                            },
                            child: Text(isCompleted ? '未完了に戻す' : '完了にする'),
                          )
                          : const SizedBox(height: 36),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Text('編集', style: textTheme.headlineSmall),
                    const SizedBox(height: 24),
                    PrecedingTodoDropdownFormField(
                      defaultId: widget.todo.parentTodo,
                      todoId: widget.todo.id,
                    ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        isCompleted
                            ? Text(
                              // 完了しているので、completedAt は確実に存在する
                              widget.todo.completedAt != null
                                  ? dateFormat.format(widget.todo.completedAt!)
                                  : '',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorTheme.primary,
                              ),
                              textAlign: TextAlign.right,
                            )
                            : const SizedBox(height: 8),
                      ],
                    ),
                    const SizedBox(height: 18),
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

                              await TodoRepository().update(
                                widget.todo.id,
                                completedAt: widget.todo.completedAt,
                                content: contentController.text,
                                parentTodoId:
                                    selectedId != null && selectedId != 'null'
                                        ? selectedId
                                        : null,
                              );
                              ref
                                  .read(todoUncompletedListProvider.notifier)
                                  .fetch();
                              ref
                                  .read(todoCompletedListProvider.notifier)
                                  .fetch();
                              if (!context.mounted) return;
                              context.pop();
                            },
                            child: const Text('保存する'),
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
            ],
          ),
        ),
      ),
    );
  }
}
