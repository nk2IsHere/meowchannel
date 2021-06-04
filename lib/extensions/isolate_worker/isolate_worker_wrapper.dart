
import 'dart:async';

import 'package:meowchannel/extensions/isolate_worker/isolate_events.dart';
import 'package:meowchannel/extensions/isolate_worker/isolate_functions.dart';

typedef EventReceiver = void Function(Event event);

class IsolateWorkerWrapper<A, S> extends Stream<Event> implements Sink<Event> {

  final EventReceiver _eventReceiver;
  final IsolateWorkerKiller _onClose;
  String? _workerId;

  final _unsentEvents = <WorkerEvent>[];
  final _controller = StreamController<Event>.broadcast();
  late final StreamSubscription<Event> _eventReceiverSubscription;

  IsolateWorkerWrapper(
    this._eventReceiver,
    this._onClose,
  ) {
    _eventReceiverSubscription = _controller.stream
      .where((event) => event is WorkerEvent)
      .cast<WorkerEvent>()
      .listen((event) {
        if (_workerId != null) {
          _eventReceiver(event.withId(_workerId!));
        } else {
          _unsentEvents.add(event);
        }
      });
  }

  @override
  void add(Event data) {
    _controller.add(data);
  }

  @override
  void close() {
    if(_workerId != null) {
      _onClose(_workerId!);
    }

    _eventReceiverSubscription.cancel();
    _controller.close();
  }

  @override
  bool get isBroadcast => _controller.stream.isBroadcast;

  void connectToWorker(String id) {
    _workerId = id;
    while (_unsentEvents.isNotEmpty) {
      _eventReceiver(
        _unsentEvents.removeAt(0)
          .withId(_workerId!)
      );
    }
  }

  @override
  StreamSubscription<Event> listen(void Function(Event event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _controller.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
