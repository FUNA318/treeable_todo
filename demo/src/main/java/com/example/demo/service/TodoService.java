package com.example.demo.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Service;

import com.example.demo.model.Todo;
import com.example.demo.model.TodoRepository;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.Predicate;

@Service
public class TodoService {

    private final TodoRepository repository;

    public TodoService(TodoRepository repository) {
        this.repository = repository;
    }

    public List<Todo> findPermittedByIds(String userId, List<String> idList) {
      return repository.findAll((root, query, cb) -> {
          List<Predicate> predicates = new ArrayList<>();
          predicates.add(cb.equal(
            root.get("user").get("id"), userId));

          if (idList != null && !idList.isEmpty()) {
            CriteriaBuilder.In<String> inClause = cb.in(root.get("id"));
            for (String id : idList) {
                inClause.value(id);
            }
            predicates.add(inClause);
          }

          query.orderBy(cb.desc(root.get("priority")));

          return cb.and(predicates.toArray(new Predicate[0]));
      });
  }

    public List<Todo> findByStatusFilter(String userId, String status) {
        return repository.findAll((root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(
              root.get("user").get("id"), userId));
            if (status != null) {
              // status カラムを annotation しても良いが、Index が効かないため不可
              if("completed".equals(status)){
                predicates.add(cb.greaterThan(
                  root.get("completedAt"), new Date()));
              }else if("uncompleted".equals(status)){
                predicates.add(cb.or(
                  cb.lessThan(
                    root.get("completedAt"), new Date()
                  ),
                  cb.isNull(root.get("completedAt"))
                ));
              }
            }

            query.orderBy(cb.desc(root.get("priority")));

            return cb.and(predicates.toArray(new Predicate[0]));
        });
    }
}
