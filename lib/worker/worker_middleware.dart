import 'package:meowchannel/core/dispatcher.dart';
import 'package:meowchannel/core/middleware.dart';
import 'package:meowchannel/extensions/channel.dart';
import 'package:meowchannel/meowchannel.dart';
import 'package:meowchannel/worker/watcher.dart';
import 'package:meowchannel/worker/worker_context.dart';
 
Middleware workerMiddleware<S>(
  List<Watcher<dynamic, S>> watchers
) => (
  Dispatcher dispatcher,
  Function() getState,
  Dispatcher next
) {
  final context = WorkerContext<S>(
    dispatcher: dispatcher,
    state: getState
  );
  final channel = StateChannel<dynamic>();
  
  watchers.forEach((Watcher<dynamic, S> watcher) {
    watcher.watch(channel.asStream(), context);
  });

  return (dynamic action) async {
    if(action is MeowChannelClose)
      channel.close();
    else
      channel.send(action);
      
    await next(action);
  };
};