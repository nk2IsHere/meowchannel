// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_store.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

abstract class _$Todo {
  const _$Todo();

  int get id;
  String get title;
  String get text;
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! Todo) return false;

    return true &&
        this.id == other.id &&
        this.title == other.title &&
        this.text == other.text;
  }

  int get hashCode {
    return mapPropsToHashCode([id, title, text]);
  }

  String toString() {
    return 'Todo(id=${this.id},title=${this.title},text=${this.text},)';
  }

  Todo copyWith({int id, String title, String text}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
    );
  }
}

abstract class _$TodoState {
  const _$TodoState();

  List<Todo> get todos;
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! TodoState) return false;

    return true && this.todos == other.todos;
  }

  int get hashCode {
    return mapPropsToHashCode([todos]);
  }

  String toString() {
    return 'TodoState(todos=${this.todos},)';
  }

  TodoState copyWith({List<Todo> todos}) {
    return TodoState(
      todos: todos ?? this.todos,
    );
  }
}
