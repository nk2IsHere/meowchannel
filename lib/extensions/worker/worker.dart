import 'package:meowchannel/extensions/worker/worker_context.dart';

typedef _Work<A, S> = Future<Null> Function(WorkerContext<S> workerContext, A action);

class Worker<A, S> {
  final _Work<A, S> work;

  Worker({
    required this.work
  });
}

Worker<A, S> worker<A, S>(_Work<A, S> work) => Worker<A, S>(work: work);
