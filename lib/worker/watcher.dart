import 'package:meowflux/core/action.dart';
import 'package:meowflux/extensions/stream_extensions.dart';
import 'package:meowflux/worker/worker.dart';
import 'package:meowflux/worker/worker_context.dart';

typedef _Watch<A extends Action, S> = Function(Stream<A> actionStream, WorkerContext<S> context);

class Watcher<A extends Action, S> {
  _Watch<A, S> watch;
}

Watcher<A, S> watcher<A extends Action, S>(
  Worker<A, S> worker,
  Stream<A> Function(Stream<A> actionStream, WorkerContext<S> context) select 
) => Watcher()
  ..watch = (Stream<A> actionStream, WorkerContext<S> context) {
    applyWorker(
      select(actionStream, context), 
      context, 
      worker
    );
  };