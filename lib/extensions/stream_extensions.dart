import 'package:meowflux/core/action.dart';
import 'package:meowflux/worker/worker.dart';
import 'package:meowflux/worker/worker_context.dart';

void applyWorker<A extends Action, S>(
  Stream<A> actionStream,
  WorkerContext<S> context,
  Worker<A, S> worker
) {
  actionStream.forEach((action) {
    worker.work(context, action);
  });
}