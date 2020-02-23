import 'package:meowchannel/core/action.dart';
import 'package:meowchannel/worker/worker.dart';

Worker<A, S> TypedWorker<A extends Action, TypedA extends A, S>(
  Worker<TypedA, S> _worker
) => worker((context, action) async {
  if(action is TypedA) await _worker.work(context, action);
});