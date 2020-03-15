
import 'package:dataclass/dataclass.dart';
import 'package:meowchannel/extensions/combined_reducer.dart';
import 'package:meowchannel/extensions/typed_reducer.dart';

import '_cache_action.dart';

part 'cache_state.g.dart';

@dataClass
class CacheState extends _$CacheState {
  final Map<List<String>, DateTime> caches;
  
  CacheState({
    this.caches = const {}
  });
}

final cacheReducer = combinedReducer<CacheState>([
  typedReducer<SetCacheAction, CacheState>(
    (action, previousState) => 
      previousState.copyWith(
        caches: Map.fromIterable(previousState.caches.entries.toList() + [MapEntry(action.key, action.validUntil)])
      ), 
      initialState: CacheState()
  ),
  typedReducer<RemoveCacheAction, CacheState>(
    (action, previousState) => 
      previousState.copyWith(
        caches: Map.fromIterable(previousState.caches.entries.where((entry) => entry.key != action.key))
      ), 
      initialState: CacheState()
  ),
]);