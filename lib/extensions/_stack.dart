
import 'dart:collection';

//
// Like really?
// This lang does not have stack implementation?!
//

class Stack<T> {
  final int cachedItems;

  Stack({
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

  T beforeTop() {
    return _list.length >= 2?
    _list.elementAt(_list.length - 2)
        : null;
  }
}