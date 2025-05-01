// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TodoImpl _$$TodoImplFromJson(Map<String, dynamic> json) => $checkedCreate(
  r'_$TodoImpl',
  json,
  ($checkedConvert) {
    final val = _$TodoImpl(
      id: $checkedConvert('id', (v) => v as String),
      content: $checkedConvert('content', (v) => v as String),
      createdAt: $checkedConvert(
        'created_at',
        (v) => DateTime.parse(v as String),
      ),
      depth: $checkedConvert('depth', (v) => (v as num?)?.toInt()),
      parentTodo: $checkedConvert('parent_todo', (v) => v as String?),
      priority: $checkedConvert('priority', (v) => (v as num?)?.toInt()),
      completedAt: $checkedConvert(
        'completed_at',
        (v) => v == null ? null : DateTime.parse(v as String),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'createdAt': 'created_at',
    'parentTodo': 'parent_todo',
    'completedAt': 'completed_at',
  },
);

Map<String, dynamic> _$$TodoImplToJson(_$TodoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'depth': instance.depth,
      'parent_todo': instance.parentTodo,
      'priority': instance.priority,
      'completed_at': instance.completedAt?.toIso8601String(),
    };
