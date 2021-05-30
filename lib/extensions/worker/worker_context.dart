import 'package:meowchannel/core/dispatcher.dart';

class WorkerContext<S> {
  final Dispatcher _dispatcher;
  final S Function() _state;
  
  WorkerContext(
    this._dispatcher,
    this._state
  );

  S state() {
    return _state();
  }

  T select<T>(T Function<T>(S) selector) {
    return selector(_state());
  }

  Future<void> put(dynamic action) async {
    await _dispatcher(action);
  }
}
