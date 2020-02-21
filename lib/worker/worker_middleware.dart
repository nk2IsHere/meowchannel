import 'package:meowchannel/core/action.dart';
import 'package:meowchannel/core/dispatcher.dart';
import 'package:meowchannel/core/middleware.dart';
import 'package:meowchannel/extensions/channel.dart';
import 'package:meowchannel/meowchannel.dart';
import 'package:meowchannel/worker/watcher.dart';
import 'package:meowchannel/worker/worker_context.dart';
 
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
    watcher.watch(channel.asStream(), context);
  });

  return (Action action) {
    if(action is MeowChannelClose)
      channel.close();
    else
      channel.send(action);
      
    next(action);
  };
};