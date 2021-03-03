import 'package:meowchannel/meowchannel.dart';
import 'package:meowchannel/utils/type_utils.dart';

typedef StoreHookBody<S> = Function(Store<S> store, S state, dynamic action);

class StoreHook<S> {

  final StoreHookBody<S> _closure;

  StoreHook(this._closure):
    assert(_closure != null);

  String get storeType => typeOf<Store<S>>().toString();
  String get stateType => typeOf<S>().toString();

  void apply(Store<S> store, S state, dynamic action) => _closure(store, state, action);
}

typedef StoreHookPreviousStateBody<S> = Function(S previousState, S state, dynamic action);

class StoreHookPreviousState<S> extends StoreHook<S> {

  StoreHookPreviousState(StoreHookPreviousStateBody<S> closure) : super(
    (store, state, action) => closure(store.getPreviousStateUnsafe().state, state, action)
  );
}