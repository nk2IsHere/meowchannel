
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_events.dart';
import 'package:meowchannel/extensions/isolate_worker/isolated_worker_manager.dart';
import 'package:uuid/uuid.dart';

abstract class IsolateWorker<A, S> extends Stream<Event> implements Sink<Event> {

  final String id = Uuid().v4();

  final _controller = StreamController<Event>.broadcast();

  S? _state;
  List<Completer<S>> _stateCompleters = [];
  late StreamSubscription<IsolateWorkerStateEvent<S>> _stateSubscription;
  late StreamSubscription<IsolateWorkerInActionEvent<A>> _inActionSubscription;

  IsolateWorker() {
    _stateSubscription = _controller.stream
      .where((event) => event is IsolateWorkerStateEvent<S>)
      .cast<IsolateWorkerStateEvent<S>>()
      .listen((nextState) {
        _state = nextState.state;
        for(final completer in _stateCompleters) {
          completer.complete(_state);
          _stateCompleters.remove(completer);
        }
      });
    
    _inActionSubscription = _controller.stream
      .where((event) => event is IsolateWorkerInActionEvent<A>)
      .cast<IsolateWorkerInActionEvent<A>>()
      .listen((event) {
        execute(event.action);
      });
  }

  @protected
  T provide<T>() {
    final dependency = IsolatedWorkerManager.instance?.dependencies[T];
    assert(
      dependency != null,
      'Dependency $T is not found'
    );

    return dependency!;
  }

  @protected
  Future<void> put(action) async {
    _controller.add(IsolateWorkerOutActionEvent(id, action));
  }

  @protected
  FutureOr<S> state() async {
    if(_state == null) {
      final completer = Completer<S>();
      _stateCompleters.add(completer);
      return await completer.future;
    }

    return _state!;
  }

  @override
  void add(Event event) {
    _controller.add(event);
  }

  @override
  Future<void> close() async {
    await _stateSubscription.cancel();
    await _inActionSubscription.cancel();
    await _controller.close();
  }

  @override
  StreamSubscription<Event> listen(void Function(Event event)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _controller.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  Future<void> execute(A action);
}
