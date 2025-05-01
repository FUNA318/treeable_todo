import 'dart:async';
import 'dart:convert';

import '../models/todo.dart';
import 'http_client.dart';
import 'local_config.dart';

enum TodoStatus { all, completed, uncompleted }

abstract class TodoApiRepository {
  Future<List<Todo>> fetchCompletedTree();
  Future<List<Todo>> fetchUncompletedTree();
  Future<Todo?> create({required String content});
  Future<Todo?> partialUpdate(
    String id, {
    String? content,
    DateTime? completedAt,
  });
  Future<Todo?> update(
    String id, {
    required String content,
    required DateTime completedAt,
  });
  Future<List<Todo>> bulkUpdate(List<String> idList);
  Future<void> delete(String id);
}

class TodoRepository extends TodoApiRepository {
  TodoRepository();

  static final client = CustomHttpClient();
  static const baseURL = '$apiHost/api/todos';

  @override
  Future<Todo?> create({required String content, String? parentTodoId}) async {
    final response = await client.post(
      Uri.parse(baseURL),
      body: json.encode({'content': content, 'patent_todo_id': parentTodoId}),
    );
    if (response.statusCode == 201) {
      return Todo.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  @override
  Future<Todo?> update(
    String id, {
    required String? content,
    required DateTime? completedAt,
  }) async {
    final body = {
      'content': content,
      'completed_at': completedAt?.toIso8601String(),
    };

    final response = await client.put(
      Uri.parse('$baseURL/$id'),
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  @override
  Future<Todo?> partialUpdate(
    String id, {
    String? content,
    DateTime? completedAt,
    String? parentTodoId,
  }) async {
    final body = {
      'patent_todo_id': parentTodoId,
      if (content != null) 'content': content,
      if (completedAt != null) 'completed_at': completedAt.toIso8601String(),
    };

    final response = await client.patch(
      Uri.parse('$baseURL/$id'),
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return Todo.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  @override
  Future<List<Todo>> bulkUpdate(Iterable<String> idList) async {
    final body = {'ids': idList.toList()};

    final response = await client.put(
      Uri.parse('$baseURL/bulk'),
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final content = jsonDecode(response.body) as List<dynamic>;
      return content
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return [];
  }

  @override
  Future<List<Todo>> fetchCompletedTree() async {
    final response = await client.getWithCheck(Uri.parse('$baseURL/completed'));
    if (response.statusCode == 200) {
      final content = jsonDecode(response.body) as List<dynamic>;
      return content
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<List<Todo>> fetchUncompletedTree() async {
    final response = await client.getWithCheck(
      Uri.parse('$baseURL/uncompleted'),
    );
    if (response.statusCode == 200) {
      final content = jsonDecode(response.body) as List<dynamic>;
      return content
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<void> delete(String id) async {
    await client.delete(Uri.parse('$baseURL/$id'));
  }
}
