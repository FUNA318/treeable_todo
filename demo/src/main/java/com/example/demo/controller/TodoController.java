package com.example.demo.controller;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.auth.LoginUserDetails;
import com.example.demo.form.TodoBulkForm;
import com.example.demo.form.TodoForm;
import com.example.demo.model.Todo;
import com.example.demo.model.TodoRepository;
import com.example.demo.projection.TodoMaxPriority;
import com.example.demo.projection.TodoWithDepth;
import com.example.demo.response.TodoResponse;
import com.example.demo.response.TodoSimpleResponse;
import com.example.demo.service.TodoService;

@CrossOrigin(
    origins = "*",
    methods = { RequestMethod.GET, RequestMethod.POST, RequestMethod.PUT, RequestMethod.DELETE }
)
@RestController
@RequestMapping("/api/todos")
public class TodoController {

    private final TodoRepository _todoRepository;
    private final TodoService _todoService;

    public TodoController(TodoRepository todoRepository, TodoService todoService) {
        _todoRepository = todoRepository;
        _todoService = todoService;
    }

    @GetMapping("/")
    public List<TodoSimpleResponse> list(
        @AuthenticationPrincipal LoginUserDetails userDetails
    ) {
        List<Todo> todos = _todoRepository.findAllByUserId(userDetails.getId());
        return todos.stream()
        .map(todo -> new TodoSimpleResponse(
            todo.getId(),
            todo.getContent(),
            todo.getParentTodo() != null ? todo.getParentTodo().getId() : null,
            todo.getCreatedAt(),
            todo.getCompletedAt(),
            todo.getPriority()
        ))
        .toList();
    }

    @GetMapping("/completed")
    public List<TodoResponse> getAllCompleted(
        @AuthenticationPrincipal LoginUserDetails userDetails
    ) {
        List<TodoWithDepth> todos = _todoRepository.listTreeCompleted(userDetails.getId());
        return todos.stream()
            .map(todo -> new TodoResponse(
                todo.getId(),
                todo.getContent(),
                todo.getParentTodoId(),
                todo.getCreatedAt(),
                todo.getCompletedAt(),
                todo.getPriority(),
                todo.getDepth()
            ))
            .toList();
    }

    @GetMapping("/uncompleted")
    public List<TodoResponse> getAllUnCompleted(
        @AuthenticationPrincipal LoginUserDetails userDetails
    ) {
        List<TodoWithDepth> todos = _todoRepository.listTreeUncompleted(userDetails.getId());
        return todos.stream()
            .map(todo -> new TodoResponse(
                todo.getId(),
                todo.getContent(),
                todo.getParentTodoId(),
                todo.getCreatedAt(),
                todo.getCompletedAt(),
                todo.getPriority(),
                todo.getDepth()
            ))
            .toList();
    }

    @GetMapping("/{id}")
    public Optional<Todo> get(
        @AuthenticationPrincipal LoginUserDetails userDetails, 
        @PathVariable String id
    ) {
        Optional<Todo> todo = _todoRepository.findPermittedById(id, userDetails.getId());
        return todo;
    }

    @PostMapping
    public ResponseEntity<Todo> create(
        @AuthenticationPrincipal LoginUserDetails userDetails, 
        @RequestBody TodoForm requestTodo
    ) {
        TodoMaxPriority todoPriority = _todoRepository.findMaxPriorityByUserId(userDetails.getId());
        Integer oldTodoPriority = todoPriority.getPriority();

        if(oldTodoPriority == null){
            oldTodoPriority = 0;
        }

        Todo todo = new Todo();
        todo.setCreatedAt(new Date());
        todo.setUser(userDetails.getUser());
        todo.setContent(requestTodo.getContent());
        todo.setPriority(oldTodoPriority + 1);

        String partentTodoId = requestTodo.getParentTodoId();
        if(partentTodoId != null){
            Optional<Todo> exist = _todoRepository.findPermittedById(partentTodoId, userDetails.getId());
            if (exist.isPresent()) {
                Todo target = exist.get();
                todo.setParentTodo(target);
            }
        }
        return new ResponseEntity<Todo>(_todoRepository.save(todo), HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public Todo update(
        @AuthenticationPrincipal LoginUserDetails userDetails, 
        @PathVariable String id, 
        @RequestBody TodoForm todo
    ) {
        Optional<Todo> exist = _todoRepository.findPermittedById(id, userDetails.getId());
        if (exist.isPresent()) {
            Todo target = exist.get();
            String content = todo.getContent();
            Date completedAt = todo.getCompletedAt();
            target.setContent(content);
            target.setCompletedAt(completedAt);

            String partentTodoId = todo.getParentTodoId();
            if(partentTodoId != null){
                Optional<Todo> parentIsExist = _todoRepository.findPermittedById(
                    partentTodoId, userDetails.getId()
                );
                if (parentIsExist.isPresent()) {
                    Todo parentTarget = parentIsExist.get();
                    target.setParentTodo(parentTarget);
                }
            }else{
                target.setParentTodo(null);
            }

            return _todoRepository.save(target);
        }
        return null;
    }

    @PutMapping("/bulk")
    public List<Todo> bulkUpdatePriority(
        @AuthenticationPrincipal LoginUserDetails userDetails, 
        @RequestBody TodoBulkForm request
    ) {
        List<Todo> todos = _todoService.findPermittedByIds(
            userDetails.getId(),
            request.getIds()
        );

        Map<String, Todo> todoMap = todos.stream().collect(Collectors.toMap(
            Todo::getId,
            Function.identity() 
        ));

        int i = 0;
        for (String todoId : request.getIds()) {
            Todo target = todoMap.get(todoId);
            target.setPriority(i);
            i += 1;
        }

        return _todoRepository.saveAll(todos);
    }

    @PatchMapping("/{id}")
    public Todo partialUpdate(
        @AuthenticationPrincipal LoginUserDetails userDetails, 
        @PathVariable String id, 
        @RequestBody TodoForm todo
    ) {
        Optional<Todo> exist = _todoRepository.findPermittedById(id, userDetails.getId());
        if (exist.isPresent()) {
            Todo target = exist.get();
            String content = todo.getContent();
            Date completedAt = todo.getCompletedAt();
            if(content != null){
                target.setContent(content);
            }
            if(completedAt != null){
                target.setCompletedAt(completedAt);
            }

            String partentTodoId = todo.getParentTodoId();
            if(partentTodoId != null){
                Optional<Todo> parentIsExist = _todoRepository.findPermittedById(
                    partentTodoId, userDetails.getId()
                );
                if (parentIsExist.isPresent()) {
                    Todo parentTarget = parentIsExist.get();
                    target.setParentTodo(parentTarget);
                }
            }
            return _todoRepository.save(target);
        }
        return null;
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable String id) {
        _todoRepository.deleteById(id);
    }
}