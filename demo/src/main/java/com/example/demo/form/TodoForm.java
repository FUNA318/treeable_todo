package com.example.demo.form;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class TodoForm {
    private String content;

    @JsonProperty("completed_at")
    private Date completedAt;

    @JsonProperty("patent_todo_id")
    private String parentTodoId;
}