import 'package:meowchannel/core/module.dart';
import 'package:meowchannel/extensions/channel.dart';
import 'package:meowchannel/meowchannel.dart';
import 'package:meowchannel/extensions/worker/watcher.dart';
import 'package:meowchannel/extensions/worker/worker_context.dart';

class SetWatchersAction<S> {
  List<Watcher<dynamic, S>> watchers;

  SetWatchersAction(this.watchers);
}

Module<S> workerModule<S>(
  List<Watcher<dynamic, S>> watchers
) => Module('workerModule', (dispatcher, initialize, state, next) {
  final context = WorkerContext<S>(dispatcher, () => state.valueOrNull()?.state as S);
  final MutableStateChannel<dynamic> channel = StateChannelImpl<dynamic>();

  watchers.forEach((Watcher<dynamic, S> watcher) {
    watcher.watch(channel.asStream(), context);
  });

  return (dynamic action) async {
    if(action is MeowChannelClose) {
      channel.close();
    } else {
      channel.send(action);
    }

    await next(action);
  };
});
