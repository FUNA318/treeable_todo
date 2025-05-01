import 'package:app/models/todo.dart';
import 'package:app/repositories/todo.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todos.g.dart';

@riverpod
Future<List<Todo>> todoList(Ref ref) async {
  final todoList = await TodoRepository().fetchUncompletedTree();
  return todoList;
}

@Riverpod(keepAlive: false)
class TodoCompletedList extends _$TodoCompletedList {
  @override
  List<Todo>? build() {
    return [];
  }

  Future<void> fetch() async {
    final todoList = await TodoRepository().fetchCompletedTree();
    state = todoList;
  }

  void removeIndex(int i) {
    state?.removeAt(i);
    state = state != null ? [...state!] : [];
  }

  List<Todo> realign(int oldIndex, int newIndex) {
    if (state == null) return [];

    final newList = List<Todo>.from(state!.toList());
    if (oldIndex < newIndex) newIndex -= 1;
    final item = newList.removeAt(oldIndex);
    newList.insert(newIndex, item);

    state = newList;
    return newList;
  }
}

@Riverpod(keepAlive: false)
class TodoUncompletedList extends _$TodoUncompletedList {
  @override
  List<Todo>? build() {
    return [];
  }

  Future<void> fetch() async {
    final todoList = await TodoRepository().fetchUncompletedTree();
    state = todoList;
  }

  void removeIndex(int i) {
    state?.removeAt(i);
    state = state != null ? [...state!] : [];
  }

  List<Todo> realign(int oldIndex, int newIndex) {
    if (state == null) return [];

    final newList = List<Todo>.from(state!.toList());
    if (oldIndex < newIndex) newIndex -= 1;
    final item = newList.removeAt(oldIndex);
    newList.insert(newIndex, item);

    state = newList;
    return newList;
  }
}

@riverpod
class SelectedParentTodoId extends _$SelectedParentTodoId {
  @override
  String? build() => null;

  void set(String? id) {
    state = id;
  }
}
