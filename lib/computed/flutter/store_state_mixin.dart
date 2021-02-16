
import 'package:flutter/widgets.dart';
import 'package:meowchannel/computed/computed_actions.dart';
import 'package:meowchannel/extensions/flutter/store_hook.dart';
import 'package:meowchannel/extensions/flutter/store_state.dart';
import 'package:meowchannel/utils/type_utils.dart';

mixin ComputedStoreStateMixin<W extends StatefulWidget> on StoreState<W> {
  Map<String, Map<String, dynamic>> _computedLocalStorage = Map();

  @override
  void initState() {
    mixinGlobalHooks.addAll([
      StoreHook((store, state, action) {
        if(action is ComputedStorageUpdateAction) setState(() {
          _computedLocalStorage[state.runtimeType.toString()] = action.data;
        });
      })
    ]);
    super.initState();
  }

  T getComputed<S, T>(String id) {
    final storeType = typeOf<S>().toString();

    final localStorageForStore = _computedLocalStorage[storeType];
    if(localStorageForStore != null)
      return localStorageForStore[id] as T;

    final initialLocalStorageForStore = getStore<S>().getInitialValueForModule('computedModule');
    if(initialLocalStorageForStore != null)
      return initialLocalStorageForStore[id] as T;

    return null;
  }
}
