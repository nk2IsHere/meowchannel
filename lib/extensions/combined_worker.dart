import 'package:meowchannel/core/action.dart';
import 'package:meowchannel/worker/worker.dart';

Worker<A, S> combinedWorker<A extends Action, S>(
  Iterable<Worker<A, S>> workers
) => worker((context, action) async {
  for (Worker<A, S> worker in workers) {
    await worker.work(context, action);
  }
});