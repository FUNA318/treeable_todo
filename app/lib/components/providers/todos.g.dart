// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todoListHash() => r'a9d74f8685c45bc28f13ece04c59421ba5a51db0';

/// See also [todoList].
@ProviderFor(todoList)
final todoListProvider = AutoDisposeFutureProvider<List<Todo>>.internal(
  todoList,
  name: r'todoListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$todoListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodoListRef = AutoDisposeFutureProviderRef<List<Todo>>;
String _$todoCompletedListHash() => r'cd55493b08485deee56f6ed3c5af076b00b18c04';

/// See also [TodoCompletedList].
@ProviderFor(TodoCompletedList)
final todoCompletedListProvider =
    AutoDisposeNotifierProvider<TodoCompletedList, List<Todo>?>.internal(
      TodoCompletedList.new,
      name: r'todoCompletedListProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$todoCompletedListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TodoCompletedList = AutoDisposeNotifier<List<Todo>?>;
String _$todoUncompletedListHash() =>
    r'e473bf5e01d50e3934963f17ea1e0a7ffe9cd74c';

/// See also [TodoUncompletedList].
@ProviderFor(TodoUncompletedList)
final todoUncompletedListProvider =
    AutoDisposeNotifierProvider<TodoUncompletedList, List<Todo>?>.internal(
      TodoUncompletedList.new,
      name: r'todoUncompletedListProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$todoUncompletedListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TodoUncompletedList = AutoDisposeNotifier<List<Todo>?>;
String _$selectedParentTodoIdHash() =>
    r'8c8c59c48a7d2518af9cd1b39c474d75be0338d3';

/// See also [SelectedParentTodoId].
@ProviderFor(SelectedParentTodoId)
final selectedParentTodoIdProvider =
    AutoDisposeNotifierProvider<SelectedParentTodoId, String?>.internal(
      SelectedParentTodoId.new,
      name: r'selectedParentTodoIdProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedParentTodoIdHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedParentTodoId = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
