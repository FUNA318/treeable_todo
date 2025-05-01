package com.example.demo.projection;

import java.util.Date;

public interface TodoWithDepth {
  String getId();
  String getContent();
  String getParentTodoId();
  Integer getPriority();
  Date getCreatedAt();
  Date getCompletedAt();
  Integer getDepth();
}
