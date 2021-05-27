
import 'package:meowchannel/core/store.dart';
import 'package:meowchannel/utils/type_utils.dart';

class StoreRepeater<S> {
  final Function(Store<S>, S) _closure;
  final Duration _duration;

  bool _shouldStop = false;

  StoreRepeater(this._closure, this._duration);

  Type get storeType => typeOf<Store<S>>();
  Type get stateType => typeOf<S>();

  void stop() => _shouldStop = true;

  Future<void> apply(Store<S> store, dynamic Function() state) async {
    while(!_shouldStop) {
      _closure(store, state() as S);
      await Future.delayed(_duration);
    }
  }
}
