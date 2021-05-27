
abstract class StoreDispatcher {
  Future<void> dispatch(dynamic action);
}

typedef Dispatcher = Future<void> Function(dynamic action);
