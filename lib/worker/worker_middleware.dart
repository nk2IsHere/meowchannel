import 'package:meowflux/core/action.dart';
import 'package:meowflux/core/dispatcher.dart';
import 'package:meowflux/core/middleware.dart';
import 'package:meowflux/extensions/channel.dart';
import 'package:meowflux/worker/watcher.dart';
import 'package:meowflux/worker/worker_context.dart';
 
Middleware<S> WorkerMiddleware<S>(
  List<Watcher<Action, S>> watchers
) => (
  Dispatcher dispatcher,
  S Function() getState,
  Dispatcher next
) {
  final context = WorkerContext(
    dispatcher: dispatcher,
    state: getState
  );
  final channel = StateChannel<Action>();
  final actionStream = channel.asStream();
  
  watchers.forEach((watcher) async {
    await watcher.watch(actionStream, context);
  });

  return (Action action) {
    next(action);
  };
};