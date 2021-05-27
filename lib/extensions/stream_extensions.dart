import 'package:meowchannel/extensions/worker/worker.dart';
import 'package:meowchannel/extensions/worker/worker_context.dart';

Future applyWorker<A, S>(
  Stream<A> actionStream,
  WorkerContext<S> context,
  Worker<A, S> worker
) async {
  await actionStream.forEach((action) async {
    await worker.work(context, action);
  });
}
