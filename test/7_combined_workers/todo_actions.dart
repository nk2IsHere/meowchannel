import 'package:meowchannel/meowchannel.dart';

import 'todo_store.dart';

class TodoAction {}

class TodoListAction extends TodoAction {}

class TodoGetAction extends TodoAction {
  final int id;

  TodoGetAction({
    this.id
  }): assert(id != null);
}

class TodoAddAction extends TodoAction {
  final int id;
  final String title;
  final String text;

  TodoAddAction({
    this.id,
    this.title,
    this.text
  }): assert(id != null),
    assert(title != null),
    assert(text != null);
}

class TodoEditAction extends TodoAction {
  final int id;
  final String title;
  final String text;

  TodoEditAction({
    this.id,
    this.title,
    this.text
  }): assert(id != null);
}

class TodoRemoveAction extends TodoAction {
  final int id;

  TodoRemoveAction({
    this.id
  }): assert(id != null);
}

class TodoUiAction extends Action {}

class TodoUpdateUiAction extends TodoUiAction {
  final List<Todo> todos;

  TodoUpdateUiAction({
    this.todos
  }): assert(todos != null);
}

class TodoAddUiAction extends TodoUiAction {
  final Todo todo;

  TodoAddUiAction({
    this.todo
  }): assert(todo != null);
}

class TodoEditUiAction extends TodoUiAction {
  final int id;
  final Todo todo;

  TodoEditUiAction({
    this.id,
    this.todo
  }): assert(id != null),
    assert(todo != null);
}

class TodoRemoveUiAction extends TodoUiAction {
  final int id;

  TodoRemoveUiAction({
    this.id
  }): assert(id != null);
}