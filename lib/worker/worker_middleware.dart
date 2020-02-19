import 'package:meowflux/core/action.dart';
import 'package:meowflux/core/dispatcher.dart';
import 'package:meowflux/core/middleware.dart';
import 'package:meowflux/extensions/channel.dart';
import 'package:meowflux/worker/watcher.dart';
import 'package:meowflux/worker/worker_context.dart';
 
Middleware WorkerMiddleware<S>(
  List<Watcher<Action, S>> watchers
) => (
  Dispatcher dispatcher,
  Function() getState,
  Dispatcher next
) {
  final context = WorkerContext<S>(
    dispatcher: dispatcher,
    state: getState
  );
  final channel = StateChannel<Action>();
  
  watchers.forEach((Watcher<Action, S> watcher) {
    watcher.watch(channel.asStream(shouldEmitPreviousData: false), context);
  });

  return (Action action) {
    channel.send(action);
    next(action);
  };
};