import 'package:meowflux/core/action.dart';
import 'package:meowflux/extensions/stream_extensions.dart';
import 'package:meowflux/worker/watcher.dart';
import 'package:meowflux/worker/worker.dart';
import 'package:meowflux/worker/worker_context.dart';

class CachedAction extends Action {
  final bool skipCache;

  CachedAction({
    this.skipCache = false
  });
}

Watcher<A, S> cachedWatcher<A extends Action, S>(
  Worker<A, S> worker,
  Stream<A> Function(Stream<A> actionStream, WorkerContext<S> context) select,
  { Duration expireIn = const Duration(minutes: 5) }
) {
  DateTime validUntil;
  
  return Watcher<A, S>()
    ..watch = (Stream<A> actionStream, WorkerContext<S> context) {
      applyWorker(
        select(
          actionStream
            .where((action) => action != null && action is CachedAction)
            .where((action) => validUntil == null || validUntil.add(expireIn).isBefore(DateTime.now()) || (action as CachedAction).skipCache),
          context
        ).map((action) {
          validUntil = DateTime.now();
          return action;
        }), 
        context, 
        worker
      );
    };
}