package com.example.demo.model;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

import com.example.demo.projection.TodoMaxPriority;
import com.example.demo.projection.TodoWithDepth;

public interface TodoRepository extends JpaRepository<Todo, String>, JpaSpecificationExecutor<Todo> {
  @Query(value = "SELECT * FROM todos WHERE todos.user_id = :userId", nativeQuery = true)
  List<Todo> findAllByUserId(String userId);

  @Query(value = "SELECT * FROM todos WHERE todos.id = :id AND todos.user_id = :userId LIMIT 1", nativeQuery = true)
  Optional<Todo> findPermittedById(String id, String userId);

  @Query(value = "SELECT MAX(todos.priority) AS priority FROM todos WHERE todos.user_id = :userId", nativeQuery = true)
  TodoMaxPriority findMaxPriorityByUserId(String userId);

  @Query(value = """
  WITH RECURSIVE permitted_todos AS (
      SELECT * FROM todos WHERE (
        todos.user_id = :userId AND todos.completed_at > CURRENT_TIMESTAMP
      ) ORDER BY todos.priority
    ),
    todos_tree AS (
        SELECT 
          id, 
          user_id, 
          content, 
          parent_todo_id, 
          created_at, 
          completed_at, 
          priority, 
          0 AS depth
        FROM permitted_todos 
        WHERE permitted_todos.parent_todo_id IS NULL
      UNION ALL
        SELECT 
          permitted_todos.id, 
          permitted_todos.user_id,
          permitted_todos.content, 
          permitted_todos.parent_todo_id, 
          permitted_todos.created_at, 
          permitted_todos.completed_at, 
          permitted_todos.priority,
          todos_tree.depth + 1 AS depth
        FROM todos_tree
        INNER JOIN permitted_todos
        ON todos_tree.id = permitted_todos.parent_todo_id
    )
  SELECT * FROM todos_tree;
  """, nativeQuery = true)
  List<TodoWithDepth> listTreeCompleted(String userId);

  @Query(value = """
  WITH RECURSIVE permitted_todos AS (
      SELECT 
        id, 
        user_id, 
        content, 
        parent_todo_id, 
        created_at, 
        completed_at, 
        priority,
        CASE WHEN todos.completed_at > CURRENT_TIMESTAMP THEN 'completed'
        ELSE 'uncompleted'
        END AS status
      FROM todos 
      WHERE todos.user_id = :userId ORDER BY todos.priority
    ),
    todos_tree AS (
        SELECT 
          id, 
          user_id, 
          content, 
          parent_todo_id, 
          created_at, 
          completed_at, 
          priority, 
          0 AS depth
        FROM permitted_todos
        WHERE (
          permitted_todos.parent_todo_id IS NULL AND permitted_todos.status = 'uncompleted'
        )
      UNION ALL
        SELECT 
          child.id, 
          child.user_id, 
          child.content, 
          child.parent_todo_id, 
          child.created_at, 
          child.completed_at, 
          child.priority, 
          0 AS depth
        FROM permitted_todos parent
        LEFT OUTER JOIN permitted_todos child ON parent.id = child.parent_todo_id
        WHERE parent.status = 'completed' AND child.status = 'uncompleted'
      UNION ALL
        SELECT 
          permitted_todos.id, 
          permitted_todos.user_id,
          permitted_todos.content, 
          permitted_todos.parent_todo_id, 
          permitted_todos.created_at, 
          permitted_todos.completed_at, 
          permitted_todos.priority,
          todos_tree.depth + 1 AS depth
        FROM todos_tree
        INNER JOIN permitted_todos
        ON (
          todos_tree.id = permitted_todos.parent_todo_id 
          AND permitted_todos.status = 'uncompleted'
        )
    )
  SELECT * FROM todos_tree ORDER BY todos_tree.priority;
  """, nativeQuery = true)
  List<TodoWithDepth> listTreeUncompleted(String userId);
}
