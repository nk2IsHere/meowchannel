
import 'package:meowchannel/core/store.dart';
import 'package:meowchannel/utils/type_utils.dart';

class StoreInitializer<S> {

  final Function(Store<S>) _closure;

  StoreInitializer(this._closure);

  Type get storeType => typeOf<Store<S>>();
  Type get stateType => typeOf<S>();

  void apply(Store<S> store) => _closure(store);
}
