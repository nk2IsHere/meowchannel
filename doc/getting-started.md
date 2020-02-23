# meowchannel

Lightweight [Redux](https://redux.js.org/) implementation for Flutter with workers  
... and *cats*! 😼

## Overview
<img src="https://raw.githubusercontent.com/nk2IsHere/meowchannel/master/doc/overview.png"/>

### **Where:**   
**Actions** - Payloads with data sent from **view** to **Store** or from **Middleware** to **Store** describing the fact that something happened. You can send them using `dispatch(action)`.  
Every action must extend from `Action` class.  

**State** - Single structure describing everything required by the application to show its `views` to user.  

**Reducer** - Pure function that takes latest dispatched `Action` and previous `State` and creates (not modifies!) a new `State`  
In pseudo-code:  
```Reducer stateReducer = (Action action, State previousState) => newState```  
It is really important to understand that:
- `Reducer` is a **pure** function: no side-effects, like calling api or any other external non-pure functions should be present
- `Reducer` is not called in async thread: no long and complex tasks should be done in it (use `Worker` for this!)
- `State` is immutable: every action `Reducer` should produce a modified copy of previous `State` or return old one without mutations

**Middleware** - Function that intercepts `Actions` before they reach `Reducer`. It is **not** pure - it can produce side-effects including dispatching other `Actions`.
In pseudo-code:   
```
Middleware<State> example = (Dispatcher dispatcher, Function<State> getState, Dispatcher next) => (Action action) {
 doSomething();
 next(action);
}
```

- `Middleware` itself is not called in async thread, but it can create any side-effect including new threads

- `WorkerMiddleware` is an extension to `Store` bringing asynchronous `Workers` to consume actions, do some work and dispatch new actions with results

  In pseudo-code:
  ```
  Worker<Action, State> example = worker<Action, State>((context, action) async {
    await doSomething();
    context.put(ResultAction());
  })
  ```

**Store** - Object that combines `Actions` and `Dispatcher` (aka `Middlewares`->`Reducer`) and also:

- Holds `State` and its `channel` which application can listen
- Allows `Actions` to be dispatcher via `dispatch(action)`
- Allows direct access to current `State` via the `getState()`
- Dispatches MeowChannelInit and MeowChannelClose as a lifecycle-related `Actions`

**Important:**  
- It is allowed to create multiple `Stores` with unique `State`  
- It is **not** allowed to have two or more `Stores` with the same `State` type

## Example:
Let's build a todos app!

First, we definitely need a model of our TODO
```
//I use https://pub.dev/packages/dataclass to define  .== and .copyWith and other useful functions on entity (just like kotlin data class!)
@dataClass 
class Todo {
  final int id;
  final String title;
  final String text;

  Todo({
    this.id,
    this.title,
    this.text
  });
}
```

Next, we will need to define some `Actions`

```
//Every action must extend Action 

//These actions are going to be data-related
class TodoAction extends Action {}

class TodoListAction extends TodoAction {}

class TodoGetAction extends TodoAction {
  final int id;

  TodoGetAction({
    this.id
  }): assert(id != null);
}

class TodoAddAction extends TodoAction {
  final String title;
  final String text;

  TodoAddAction({
    this.title,
    this.text
  }): assert(title != null),
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

//These actions are going to be ui-related
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
```

And then we should thing about state  
But in this case it will be just a data class with list of todos 

```
@dataClass
class TodoState {
  final List<Todo> todos;

  TodoState({
    this.todos = const <Todo>[]
  });
}
```

Now we should create 3 things:
- `Reducer`
- `Watcher` and `Worker` pair

```
/// Reducer is going to be a stack of TypedReducers<ActionType, State> (basically reducers which say: if this Action is ActionType then make new state else just pass) what will replace if-else hell
fi
final Reducer<TodoState> TodoReducer = CombinedReducer<TodoState>([
  TypedReducer<TodoUpdateUiAction, TodoState>(
    (action, previousState) => previousState.copyWith(
      todos: action.todos
    )
  ),
  TypedReducer<TodoAddUiAction, TodoState>(
    (action, previousState) => previousState.copyWith(
      todos: [action.todo] + previousState.todos
    )
  ),
  TypedReducer<TodoEditUiAction, TodoState>(
    (action, previousState) => previousState.copyWith(
      todos: previousState.todos.map((todo) => todo.id == action.id? action.todo : todo)
        .toList()
    )
  ),
  TypedReducer<TodoRemoveUiAction, TodoState>(
    (action, previousState) => previousState.copyWith(
      todos: previousState.todos.where((todo) => todo.id != action.id)
        .toList()
    )
  ),
]);
```

```
/// Watcher is a distinct stream manipulator which then will be send to Worker
/// Its job is to filter and cast stream of Actions to match this specific Worker
Watcher<TodoAction, TodoState> TodoWatcher(
  Worker<TodoAction, TodoState> worker
) =>
  watcher(worker, (actionStream, context) {
    return actionStream.where((action) => action is TodoAction)
      .cast<TodoAction>();
  });

/// Worker can have side-effects and handle complex tasks
/// because it is async!
/// CombinedWorker is logically same as CombinedReducer, but for workers
Worker<TodoAction, TodoState> TodoWorker(
  TodoRepository todoRepository
) =>
  CombinedWorker([
    TypedWorker<TodoAction, TodoListAction, TodoState>(worker((context, action) async {
      final todos = await todoRepository.list();

      context.put(TodoUpdateUiAction(
        todos: todos
      ));
    })),
    TypedWorker<TodoAction, TodoAddAction, TodoState>(worker((context, action) async {
      final todo = await todoRepository.add(
        title: action.title,
        text: action.text
      );

      context.put(TodoAddUiAction(
        todo: todo
      ));
    })),
    TypedWorker<TodoAction, TodoEditAction, TodoState>(worker((context, action) async {
      final todo = await todoRepository.edit(
        id: action.id,
        title: action.title,
        text: action.text
      );

      context.put(TodoEditUiAction(
        id: action.id,
        todo: todo
      ));
    })),
    TypedWorker<TodoAction, TodoRemoveAction, TodoState>(worker((context, action) async {
      await todoRepository.remove(
        id: action.id
      );

      context.put(TodoRemoveUiAction(
        id: action.id
      ));
    }))
  ]);
```

Finally, let's create Store and StoreProvider

```
runApp(
  StoreProvider<TodoState>(
    create: (context) =>
      /// To provide multiple stores to children use MultiStoreProvider
      Store<TodoState>(
        reducer: TodoReducer,
        initialState: TodoState(),
        middleware: [
          /// For the Workers to be able to intercept Actions, it is required to create WorkerMiddleware
          WorkerMiddleware([
            TodoWatcher(TodoWorker(
              TodoRepository()
            ))
          ])
        ]
      ),
    child: MaterialApp(
      home: ...,
    )
  )
);
```

How to access Store and State in Widgets?

```
/// For any Widget you can use StoreProvider.of<Store<StateType>>()
/// to get Store of desired state

/// For any StatefulWidget that needs to be rebuilt on each new state arrival
class TodoApplicationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
    _TodoApplicationWidgetState();

}


/// You should extend from StoreState and use WidgetStoreProviderMixin
class _TodoApplicationWidgetState extends StoreState<CombinedApplicationWidget> with WidgetStoreProviderMixin {

  /// Here all Stores which are required by the Widget can be specified
  @override
  List<Store> requireStores(BuildContext context) => [
    StoreProvider.of<Store<TodoState>>(context)
  ];

  @override
  Widget build(BuildContext context) {
    /// Every new State from each of specified Store the Wiget will be rebuilt
    final store = getStore<TodoState>(); /// To get access to store
    final state = getState<TodoState>(); /// To get access to current state

    ...
    /// Here goes your creativity!
  }
}

```

## Credits:

This page has many connections with [Redux docs](https://redux.js.org/basics/actions)
