
import 'package:meowchannel/core/store.dart';
import 'package:meowchannel/utils/type_utils.dart';

class StoreRepeater<S> {
  final Function(Store<S>) _closure;
  final Duration _duration;

  bool _shouldStop = false;

  StoreRepeater(this._closure, this._duration):
    assert(_closure != null),
    assert(_duration != null);

  String get type => typeOf<S>().toString();

  void stop() => _shouldStop = true;

  Future<void> apply(Store<S> store) async {
    while(!_shouldStop) {
      _closure(store);
    }
    await Future.delayed(_duration);
  }
}