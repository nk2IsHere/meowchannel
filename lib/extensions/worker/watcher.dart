import 'package:meowchannel/extensions/stream_extensions.dart';
import 'package:meowchannel/extensions/worker/worker.dart';
import 'package:meowchannel/extensions/worker/worker_context.dart';

typedef _Watch<A, S> = Future<Null> Function(Stream<A> actionStream, WorkerContext<S> context);

class Watcher<A, S> {
  final _Watch<dynamic, S> watch;

  Watcher({
    required this.watch
  });
}

Watcher<A, S> watcher<A, S>(
  Worker<A, S> worker,
  Stream<A> Function(Stream<dynamic> actionStream, WorkerContext<S> context) select
) => Watcher<A, S>(
    watch: (Stream<dynamic> actionStream, WorkerContext<S> context) async {
      await applyWorker<A, S>(
          select(actionStream, context),
          context,
          worker
      );
    }
);
