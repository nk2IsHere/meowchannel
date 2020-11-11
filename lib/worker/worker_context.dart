import 'package:dataclass_beta/dataclass_beta.dart';
import 'package:meowchannel/core/dispatcher.dart';

part 'worker_context.g.dart';

@DataClass()
class WorkerContext<S> extends _$WorkerContext {
  final Dispatcher dispatcher;
  final S Function() state;
  
  WorkerContext({
    this.dispatcher,
    this.state
  });

  T select<T>(T Function<T>(S) selector) {
    return selector(state());
  }

  Future<void> put(dynamic action) async {
    await dispatcher(action);
  }
}