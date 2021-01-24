import 'package:meowchannel/core/dispatcher.dart';
import 'package:worker_manager/worker_manager.dart';

class WorkerContext<S> {
  final Dispatcher _dispatcher;
  final S Function() _state;
  
  WorkerContext(
    this._dispatcher,
    this._state
  );

  Future<T> compute0<T>(Future<T> Function() computable) async {
    return Executor().execute(arg1: <dynamic>[], fun1: (List<dynamic> params) async {
      return await computable();
    });
  }

  Future<T> compute1<A, T>(Future<T> Function(A) computable, A a) async {
    return Executor().execute(arg1: <dynamic>[a], fun1: (List<dynamic> params) async {
      return await computable(params[0] ?? null);
    });
  }

  Future<T> compute2<A, B, T>(Future<T> Function(A, B) computable, A a, B b) async {
    return Executor().execute(arg1: <dynamic>[a, b], fun1: (List<dynamic> params) async {
      return await computable(params[0] ?? null, params[1] ?? null);
    });
  }

  Future<T> compute3<A, B, C, T>(Future<T> Function(A, B, C) computable, A a, B b, C c) async {
    return Executor().execute(arg1: <dynamic>[a, b, c], fun1: (List<dynamic> params) async {
      return await computable(params[0] ?? null, params[1] ?? null, params[2] ?? null);
    });
  }

  Future<T> compute4<A, B, C, D, T>(Future<T> Function(A, B, C, D) computable, A a, B b, C c, D d) async {
    return Executor().execute(arg1: <dynamic>[a, b, c, d], fun1: (List<dynamic> params) async {
      return await computable(params[0] ?? null, params[1] ?? null, params[2] ?? null, params[3] ?? null);
    });
  }

  Future<T> compute5<A, B, C, D, E, T>(Future<T> Function(A, B, C, D, E) computable, A a, B b, C c, D d, E e) async {
    return Executor().execute(arg1: <dynamic>[a, b, c, d, e], fun1: (List<dynamic> params) async {
      return await computable(params[0] ?? null, params[1] ?? null, params[2] ?? null, params[3] ?? null, params[4] ?? null);
    });
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