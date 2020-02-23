import 'todo_store.dart';

class TodoRepository {
  List<Todo> _todos = [];


  Future<List<Todo>> list() async {
    return _todos;
  }

  Future<Todo> getTodo({
    int id
  }) async {
    return _todos.firstWhere(
      (todo) => todo.id == id,
      orElse: () => null
    );
  }

  Future<Todo> add({
    int id,
    String title,
    String text
  }) async {
    final todo = Todo(
      id: id,
      title: title,
      text: text
    );
    _todos.add(todo);

    return todo;
  }

  Future<Todo> edit({
    int id,
    String title,
    String text
  }) async {
    final oldTodo = await this.getTodo(
      id: id
    );
    final todo = Todo(
      id: id,
      title: title ?? oldTodo.title,
      text: text ?? oldTodo.text
    );
    _todos = _todos.map((_todo) => _todo.id == id? todo : _todo)
      .toList();

    return todo;
  }

  Future<Null> remove({
    int id
  }) async {
    _todos = _todos.where((_todo) => _todo.id != id)
      .toList();
  }
}