import 'package:meowchannel/meowchannel.dart';
import 'package:meowchannel/utils/type_utils.dart';

class StoreHook<S> {

  final Function(Store<S> store, S state, dynamic action) _closure;

  StoreHook(this._closure):
    assert(_closure != null);

  String get storeType => typeOf<Store<S>>().toString();
  String get stateType => typeOf<S>().toString();

  void apply(Store<S> store, S state, dynamic action) => _closure(store, state, action);
}