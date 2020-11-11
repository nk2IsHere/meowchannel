
import 'package:meowchannel/core/store.dart';
import 'package:meowchannel/utils/type_utils.dart';

class StoreInitializer<S> {

  final Function(Store<S>) _closure;

  StoreInitializer(this._closure):
        assert(_closure != null);

  String get storeType => typeOf<Store<S>>().toString();
  String get stateType => typeOf<S>().toString();

  void apply(Store<S> store) => _closure(store);
}