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

  bool _isClosed = false;

  @override
  void send(T value) {
    if (isClosed) throw Exception('Channel is closed');
    _data.push(value);
    _send();
  }

  @override
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

  @override
  Stream<T> asStream() {
    final controller = StreamController<T>();

    void loop() async {
      bool isCancelled = false;
      controller.onCancel = () {
        isCancelled = true;
      };

      while (true) {
        if (_data.isEmpty && _isClosed) {
          await controller.close();
          break;
        }

        final data = await receive();
        if (isCancelled) {
          await controller.close();
          break;
        }
        controller.add(data);
      }
    }

    loop();

    return controller.stream;
  }

  @override
  bool get isClosed => _isClosed;

  @override
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
  }

  void _send() {
    if (_data.isEmpty || _completers.isEmpty) return;

    for (int i = 0; i < _completers.length; i++) {
      final completer = _completers.removeFirst();
      final data = _data.top();
      completer.complete(data);
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