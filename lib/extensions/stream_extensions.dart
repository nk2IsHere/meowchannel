import 'package:meowflux/core/action.dart';
import 'package:meowflux/worker/worker.dart';
import 'package:meowflux/worker/worker_context.dart';

Future applyWorker<A extends Action, S>(
  Stream<A> actionStream,
  WorkerContext<S> context,
  Worker<A, S> worker
) async {
  await actionStream.forEach((action) async {
    await worker.work(context, action);
  });
}