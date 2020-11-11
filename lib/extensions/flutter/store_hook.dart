import 'package:meowchannel/meowchannel.dart';
import 'package:meowchannel/utils/type_utils.dart';

class StoreHook<S> {
  final Function(Store<S>, S) _closure;

  StoreHook(this._closure):
    assert(_closure != null);

  String get type => typeOf<S>().toString();
  void apply(Store<S> store, S state) => _closure(store, state);

}