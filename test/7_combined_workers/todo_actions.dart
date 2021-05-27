import 'package:meowchannel/meowchannel.dart';

import 'todo_store.dart';

class TodoAction {}

class TodoListAction extends TodoAction {}

class TodoGetAction extends TodoAction {
  final int id;

  TodoGetAction({
    required this.id
  });
}

class TodoAddAction extends TodoAction {
  final int id;
  final String title;
  final String text;

  TodoAddAction({
    required this.id,
    required this.title,
    required this.text
  });
}

class TodoEditAction extends TodoAction {
  final int id;
  final String? title;
  final String? text;

  TodoEditAction({
    required this.id,
    this.title,
    this.text
  });
}

class TodoRemoveAction extends TodoAction {
  final int id;

  TodoRemoveAction({
    required this.id
  });
}

class TodoUiAction extends Action {}

class TodoUpdateUiAction extends TodoUiAction {
  final List<Todo> todos;

  TodoUpdateUiAction({
    required this.todos
  });
}

class TodoAddUiAction extends TodoUiAction {
  final Todo todo;

  TodoAddUiAction({
    required this.todo
  });
}

class TodoEditUiAction extends TodoUiAction {
  final int id;
  final Todo todo;

  TodoEditUiAction({
    required this.id,
    required this.todo
  });
}

class TodoRemoveUiAction extends TodoUiAction {
  final int id;

  TodoRemoveUiAction({
    required this.id
  });
}
