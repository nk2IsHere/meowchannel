import 'package:meowchannel/core/dispatcher.dart';
import 'package:worker_manager/worker_manager.dart';

class WorkerContext<S> {
  final Dispatcher _dispatcher;
  final S Function() _state;
  
  WorkerContext(
    this._dispatcher,
    this._state
  );

  Future<T> compute1<A, T>(Future<T> Function(A) computable, A a) async {
    return Executor().execute(priority: WorkPriority.immediately, arg1: a, fun1: computable);
  }

  Future<T> compute2<A, B, T>(Future<T> Function(A, B) computable, A a, B b) async {
    return Executor().execute(priority: WorkPriority.immediately, arg1: a, arg2: b, fun2: computable);
  }

  Future<T> compute3<A, B, C, T>(Future<T> Function(A, B, C) computable, A a, B b, C c) async {
    return Executor().execute(priority: WorkPriority.immediately, arg1: a, arg2: b, arg3: c, fun3: computable);
  }

  Future<T> compute4<A, B, C, D, T>(Future<T> Function(A, B, C, D) computable, A a, B b, C c, D d) async {
    return Executor().execute(priority: WorkPriority.immediately, arg1: a, arg2: b, arg3: c, arg4: d, fun4: computable);
  }

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