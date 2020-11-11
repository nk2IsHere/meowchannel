import 'package:meowchannel/worker/worker.dart';

Worker<A, S> typedWorker<A, TA extends A, S>(
  Worker<TA, S> _worker
) => worker((context, action) async {
  if(action is TA) await _worker.work(context, action);
});