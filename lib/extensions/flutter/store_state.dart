import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meowchannel/meowchannel.dart';

Type _typeOf<T>() => T;

abstract class StoreState<W extends StatefulWidget> extends State<W> {
  final Map<String, Store> _storeByType = Map();
  final Map<String, dynamic> _stateByType = Map();
  final List<StreamSubscription> _subscriptions = [];
  final Map<String, List<StoreHook>> _storeHooks = Map();

  @override
  void initState() {
    super.initState();

    requireStores(context).forEach((store) {
      _storeByType.putIfAbsent(store.runtimeType.toString(), () => store);

      if(store.getStateUnsafe() != null) {
        _stateByType.putIfAbsent(
          store.initialState.runtimeType.toString(),
          () => store.getStateUnsafe()
        );
      } else if(store.initialState != null) {
        _stateByType.putIfAbsent(
          store.initialState.runtimeType.toString(),
          () => store.initialState
        );
      }
      _storeHooks.putIfAbsent(store.runtimeType.toString(), () => []);

      _subscriptions.add(
          store.channel
              .listen((state) {
            if(this.mounted) {
              setState(() {
                _stateByType.update(
                  state.runtimeType.toString(),
                  (_) => state,
                  ifAbsent: () => state
                );
              });

              _storeHooks[store.runtimeType.toString()]?.forEach((hook) {
                hook(store, state);
              });
            }
          })
      );
    });
  }

  @override
  void dispose() {
    while(_subscriptions.isNotEmpty) {
      final subscription = _subscriptions.removeLast();
      subscription.cancel();
    }

    super.dispose();
  }


  S getState<S>() {
    return _stateByType[_typeOf<S>().toString()];
  }

  Store<S> getStore<S>() {
    return _storeByType[_typeOf<Store<S>>().toString()];
  }

  void hookTo<S>(StoreHook<S> hook) {
    final hooks = _storeHooks[_typeOf<Store<S>>().toString()];

    if(hooks == null) {
      throw FlutterError("""
        Store<$S> is not loaded at the current moment.
        This means that you are running this function before initState() is called
        Be sure to check this!
      """);
    } else {
      hooks.add((store, state) {
        hook(store, state);
      });
    }
  }

  List<Store> requireStores(BuildContext context);
}