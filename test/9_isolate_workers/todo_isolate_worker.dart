
import 'package:meowchannel/extensions/isolate_worker/isolate_worker.dart';

import '../7_combined_workers/todo_actions.dart';
import '../7_combined_workers/todo_store.dart';

class TodoIsolateAction {}

class TodoIsolateGenerateAction extends TodoIsolateAction {}

List<IsolateWorker> initializeIsolateWorkers() => [
  TodoIsolateWorker()
];

class TodoIsolateWorker extends IsolateWorker<TodoIsolateAction, TodoState> {

  @override
  Future<void> execute(TodoIsolateAction action) async {
    for(int i = 0; i < 10; i++) {
      await put(TodoAddUiAction(
        todo: Todo(
          id: i,
          title: "Title: $i",
          text: "Text: $i",
        )
      ));
    }
  }
}
