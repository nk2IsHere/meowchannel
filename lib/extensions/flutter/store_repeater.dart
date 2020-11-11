
import 'package:meowchannel/core/store.dart';
import 'package:meowchannel/utils/type_utils.dart';

class StoreRepeater<S> {
  final Function(Store<S>) _closure;
  final int _millis;

  bool _shouldStop = false;

  StoreRepeater(this._closure, this._millis):
    assert(_closure != null),
    assert(_millis != null);

  String get type => typeOf<S>().toString();

  void stop() => _shouldStop = true;

  Future<void> apply(Store<S> store) async {
    while(!_shouldStop) {
      _closure(store);
    }
    await Future.delayed(Duration(milliseconds: _millis));
  }
}