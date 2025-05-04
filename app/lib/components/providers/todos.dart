import 'package:app/models/todo.dart';
import 'package:app/repositories/todo.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todos.g.dart';

@riverpod
Future<List<Todo>> todoList(Ref ref) async {
  final todoList = await TodoRepository().list();
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

  List<Todo> realign(
    int depth,
    int oldIndex,
    int newIndex,
    String? parentTodoId,
  ) {
    if (state == null) return [];

    final stateList = state ?? [];

    final newList = List<Todo>.from(
      stateList.where((e) => e.depth == depth).toList(),
    );
    if (oldIndex < newIndex) newIndex -= 1;
    final item = newList.removeAt(oldIndex);
    newList.insert(newIndex, item);

    if (parentTodoId != null) {
      state = [
        ...stateList.where((e) {
          return !newList.map((el) => el.id).contains(e.id);
        }),
        ...newList,
      ];
    } else {
      state = [...newList, ...stateList.where((e) => e.depth != 0)];
    }

    return state ?? [];
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

  List<Todo> realign(
    int depth,
    int oldIndex,
    int newIndex,
    String? parentTodoId,
  ) {
    if (state == null) return [];

    final stateList = state ?? [];

    final newList = List<Todo>.from(
      stateList
          .where(
            (e) =>
                parentTodoId == null
                    ? e.depth == depth
                    : e.depth == depth && e.parentTodo == parentTodoId,
          )
          .toList(),
    );
    if (oldIndex < newIndex) newIndex -= 1;
    final item = newList.removeAt(oldIndex);
    newList.insert(newIndex, item);

    if (parentTodoId != null) {
      state = [
        ...stateList.where((e) {
          return !newList.map((el) => el.id).contains(e.id);
        }),
        ...newList,
      ];
    } else {
      state = [...newList, ...stateList.where((e) => e.depth != 0)];
    }

    return state ?? [];
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
