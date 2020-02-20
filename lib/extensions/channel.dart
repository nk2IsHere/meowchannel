import 'dart:async';
import 'dart:collection';
import 'dart:math';

//
// Based on top of https://github.com/desktop-dart/channel
//

const _kDefaultCachedStates = 5;

class StateChannel<T> {
  final _data = _Stack<T>(
    cachedItems: _kDefaultCachedStates
  );
  final _completers = Queue<Completer<T>>();
  final _streams = Queue<StreamController<T>>();

  bool _isClosed = false;
  bool get isClosed => _isClosed;

  void _send() {
    if (_data.isEmpty) return;

    _streams.forEach((stream) { 
      stream.add(_data.top());
    });

    for (int i = 0; i < _completers.length; i++) {
      final completer = _completers.removeFirst();
      final data = _data.top();
      completer.complete(data);
    }
  }

  void send(T value) {
    if (isClosed) throw Exception('Channel is closed');
    _data.push(value);
    _send();
  }

  T valueOrNull() {
    return _data.top();
  }

  Future<T> receive() async {
    if (_isClosed && _data.isEmpty) {
      return null;
    }

    if (_data.isNotEmpty) {
      return _data.top();
    }

    final completer = Completer<T>();
    _completers.add(completer);
    
    return completer.future;
  }

  Stream<T> asStream({ bool shouldEmitPreviousData = false }) {
    StreamController<T> controller;
    controller = StreamController<T>.broadcast(onListen: () {
      if(shouldEmitPreviousData) {
        this._data.data.forEach((T item) {
          controller.add(item);
        });
      }
    }, onCancel: () {
      this._streams.remove(controller);
    });

    this._streams.add(controller);
    return controller.stream;
  }

  void close() {
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

//
//Like really? 
//This lang does not have stack implementation?!
//
class _Stack<T> {
  final int cachedItems;
  
  _Stack({
    this.cachedItems = -1
  });

  final ListQueue<T> _list = ListQueue();

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  List<T> get data => _list.toList();

  void push(T e) {
    _list.addLast(e);

    if(this.cachedItems != -1 && _list.length > this.cachedItems) {
      this._list.removeFirst();
    }
  }
  
  T pop() {
    T res = _list.last;
    _list.removeLast();
    return res;
  }

  T top() {
    return _list.last;
  }
}