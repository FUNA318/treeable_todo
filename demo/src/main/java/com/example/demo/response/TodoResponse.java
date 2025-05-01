package com.example.demo.response;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class TodoResponse {
    private String id;
    private String content;
    private String parent_todo;
    private Date created_at;
    private Date completed_at;
    private Integer priority;
    private Integer depth;
}