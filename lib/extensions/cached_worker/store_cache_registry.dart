import 'package:meowchannel/core/dispatcher.dart';
import 'package:meowchannel/extensions/cached_worker/_cache_action.dart';
import 'package:meowchannel/extensions/cached_worker/cache_registry.dart';
import 'package:meowchannel/extensions/cached_worker/cache_state.dart';

class StoreCacheRegistry extends CacheRegistry {

  StoreDispatcher _dispatcher;
  CacheState Function() _state;

  void bind(
    StoreDispatcher dispatcher,
    CacheState Function() state
  ) {
    this._dispatcher = dispatcher;
    this._state = state;
  }
  
  @override
  bool get(String key) =>
    getAll([key]);

  @override
  bool getAll(List<String> key) {
    final validUntil = _state().caches[key];
    return !(validUntil == null || validUntil.isBefore(DateTime.now()));
  }

  @override
  void set(String key, { Duration expireIn = CacheRegistry.DEFAULT_VALID_DURATION }) =>
    setAll([key], expireIn: expireIn);

  @override
  void setAll(List<String> key, { Duration expireIn = CacheRegistry.DEFAULT_VALID_DURATION }) =>
    _dispatcher.dispatch(SetCacheAction(key: key, validUntil: DateTime.now().add(expireIn)));

  @override
  void remove(String key) =>
    removeAll([key]);

  @override
  void removeAll(List<String> key) =>
    _dispatcher.dispatch(RemoveCacheAction(key: key));

}