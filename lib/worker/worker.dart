import 'package:meowflux/core/action.dart';
import 'package:meowflux/worker/worker_context.dart';

typedef _Work<A extends Action, S> = Function(WorkerContext<S> workerContext, A action);

class Worker<A extends Action, S> {
  _Work<A, S> work;
}

Worker<A, S> worker<A extends Action, S>(
  _Work<A, S> work
) => Worker<A, S>()
  ..work = work;