import 'package:dataclass/dataclass.dart';
import 'package:meowflux/core/action.dart';
import 'package:meowflux/core/dispatcher.dart';

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

  void put(Action action) {
    dispatcher(action);
  }
}