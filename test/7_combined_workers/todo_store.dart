import 'package:dataclass_beta/dataclass_beta.dart';
import 'package:meowchannel/meowchannel.dart';

import 'todo_actions.dart';
import 'todo_fakes.dart';

part 'todo_store.g.dart';

@DataClass()
class Todo with _$Todo {
  final int id;
  final String title;
  final String text;

  Todo({
    this.id,
    this.title,
    this.text
  });
}

@DataClass()
class TodoState with _$TodoState {
  final List<Todo> todos;

  TodoState({
    this.todos = const <Todo>[]
  });
}

final Reducer<TodoState> todoReducer = combinedReducer<TodoState>([
  typedReducer<TodoUpdateUiAction, TodoState>(syncedReducer<TodoUpdateUiAction, TodoState>(
    (action, previousState) => previousState.copyWith(
      todos: action.todos
    )
  )),
  typedReducer<TodoAddUiAction, TodoState>(syncedReducer<TodoAddUiAction, TodoState>(
    (action, previousState) => previousState.copyWith(
      todos: [action.todo] + previousState.todos
    )
  )),
  typedReducer<TodoEditUiAction, TodoState>(syncedReducer<TodoEditUiAction, TodoState>(
    (action, previousState) => previousState.copyWith(
      todos: previousState.todos.map((todo) => todo.id == action.id? action.todo : todo)
        .toList()
    )
  )),
  typedReducer<TodoRemoveUiAction, TodoState>(syncedReducer<TodoRemoveUiAction, TodoState>(
    (action, previousState) => previousState.copyWith(
      todos: previousState.todos.where((todo) => todo.id != action.id)
        .toList()
    )
  )),
]);

Watcher<TodoAction, TodoState> todoWatcher(
  Worker<TodoAction, TodoState> worker
) =>
  watcher(worker, (actionStream, context) {
    return actionStream.where((action) => action is TodoAction)
      .cast<TodoAction>();
  });

Worker<TodoAction, TodoState> todoWorker(
  TodoRepository todoRepository
) =>
  combinedWorker([
    typedWorker<TodoAction, TodoListAction, TodoState>(worker((context, action) async {
      final todos = await todoRepository.list();

      await context.put(TodoUpdateUiAction(
        todos: todos
      ));
    })),
    typedWorker<TodoAction, TodoAddAction, TodoState>(worker((context, action) async {
      final todo = await todoRepository.add(
        id: action.id,
        title: action.title,
        text: action.text
      );

      await context.put(TodoAddUiAction(
        todo: todo
      ));
    })),
    typedWorker<TodoAction, TodoEditAction, TodoState>(worker((context, action) async {
      final todo = await todoRepository.edit(
        id: action.id,
        title: action.title,
        text: action.text
      );

      await context.put(TodoEditUiAction(
        id: action.id,
        todo: todo
      ));
    })),
    typedWorker<TodoAction, TodoRemoveAction, TodoState>(worker((context, action) async {
      await todoRepository.remove(
        id: action.id
      );

      await context.put(TodoRemoveUiAction(
        id: action.id
      ));
    }))
  ]);