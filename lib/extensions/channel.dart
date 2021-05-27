import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:rxdart/subjects.dart';

import '_stack.dart';

const _kDefaultCachedStates = 5;

abstract class StateChannel<T> {
  T? previousValueOrNull();
  T? valueOrNull();
  Future<T> receive();
  Stream<T> asStream();
}

abstract class MutableStateChannel<T> extends StateChannel<T> {
  void send(T value);
  void close();
}

class ChannelException implements IOException {

  final String message;
  const ChannelException(this.message);

  const ChannelException.closed()
      : message = 'Channel has been closed';

  String toString() {
    StringBuffer sb = new StringBuffer();
    sb.write("ChannelException");
    if (message.isNotEmpty) {
      sb.write(": $message");
    }
    return sb.toString();
  }
}

class StateChannelImpl<T> extends MutableStateChannel<T> {
  final _data = Stack<T>(
    cachedItems: _kDefaultCachedStates
  );
  final _completers = Queue<Completer<T>>();
  final _streams = Queue<StreamController<T>>();

  bool _isClosed = false;
  bool get isClosed => _isClosed;

  void _send() {
    if (_data.isEmpty) return;

    _streams.forEach((controller) { 
      controller.add(_data.top());
    });

    for (int i = 0; i < _completers.length; i++) {
      final completer = _completers.removeFirst();
      final data = _data.top();
      completer.complete(data);
    }
  }

  @override void send(T value) {
    if (isClosed) throw ChannelException.closed();
    _data.push(value);
    _send();
  }

  @override T? previousValueOrNull() {
    return _data.beforeTop();
  }

  @override T? valueOrNull() {
    return _data.top();
  }

  @override Future<T> receive() async {
    if (_isClosed && _data.isEmpty) {
      throw ChannelException.closed();
    }

    if (_data.isNotEmpty) {
      return _data.top();
    }

    final completer = Completer<T>();
    _completers.add(completer);
    
    return completer.future;
  }

  @override Stream<T> asStream() {
    StreamController<T> controller = BehaviorSubject();

    this._streams.add(controller);
    return controller.stream;
  }

  @override void close() {
    _isClosed = true;
    _send();

    while (_completers.isNotEmpty) {
      final completer = _completers.removeFirst();
      completer.complete(
        _data.isNotEmpty? _data.top()
          : null
      );
    }
    
    while(_streams.isNotEmpty) {
      final controller = _streams.removeFirst();
      controller.close();
    }
  }
}
