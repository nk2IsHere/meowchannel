
import 'dart:async';

import 'package:meowchannel/extensions/isolate_worker/isolate_events.dart';


class IsolateMessenger extends Stream<Event> implements Sink {

  final Stream<Event> _fromIsolateStream;
  final void Function(Event message) _toIsolate;
  Event? _lastMessage;

  IsolateMessenger(this._fromIsolateStream, this._toIsolate) {
    _fromIsolateStream.listen((message) => _lastMessage = message);
  }

  @override
  void add(message) => _toIsolate(message);

  @override
  StreamSubscription<Event> listen(void Function(Event event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _behaviourSubject.listen(
      onData,
      onDone: onDone,
      onError: onError,
      cancelOnError: cancelOnError,
    );
  }

  Stream<Event> get _behaviourSubject async* {
    if (_lastMessage != null) {
      yield _lastMessage!;
    }
    yield* _fromIsolateStream;
  }

  @override
  void close() {}
}
