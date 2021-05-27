import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meowchannel/extensions/flutter/store_exception.dart';
import 'package:meowchannel/extensions/flutter/store_initializer.dart';
import 'package:meowchannel/extensions/flutter/store_repeater.dart';
import 'package:meowchannel/meowchannel.dart';
import 'package:meowchannel/utils/iterable_utils.dart';
import 'package:meowchannel/utils/type_utils.dart';

abstract class StoreState<W extends StatefulWidget> extends State<W> {
  final Map<Type, Store> _storeByType = Map();
  final Map<Type, dynamic> _stateByType = Map();
  final List<StreamSubscription> _subscriptions = [];

  final List<StoreInitializer> _storeInitializers = [];
  final Map<Type, List<StoreHook>> _storeHooks = Map();
  final List<StoreRepeater> _storeRepeatedHooks = [];

  @protected final Map<Type, StoreHook> mixinGlobalHooks = {};

  @override
  void initState() {
    super.initState();

    _storeHooks.addAll(
      requireHooks(context)
        .groupBy((e) => e.storeType)
    );

    requireStores(context).forEach((store) {
      _storeByType.putIfAbsent(store.runtimeType, () => store);

      if(store.getStateUnsafe() != null) {
        _stateByType.putIfAbsent(
          store.initialState.runtimeType,
          () => store.getStateUnsafe()?.state
        );
      } else if(store.initialState != null) {
        _stateByType.putIfAbsent(
          store.initialState.runtimeType,
          () => store.initialState
        );
      }
      _storeHooks.putIfAbsent(store.runtimeType, () => []);

      _subscriptions.add(
        store.channel.listen((stateAction) {
          if(mixinGlobalHooks[stateAction.action.runtimeType] != null) {
            mixinGlobalHooks[stateAction.action.runtimeType]?.apply(store, stateAction.state, stateAction.action);
            return;
          }

          if(this.mounted) {
            setState(() {
              _stateByType.update(
                stateAction.state.runtimeType,
                (_) => stateAction.state,
                ifAbsent: () => stateAction.state
              );
            });

            _storeHooks[store.runtimeType]?.forEach((hook) {
              hook.apply(store, stateAction.state, stateAction.action);
            });
          }
        })
      );
    });

    _storeInitializers.addAll(
      requireInitializers(context)
        .map((e) => e..apply(_getStoreByType(e.storeType)))
    );

    _storeRepeatedHooks.addAll(
      requireRepeatedHooks(context)
        .map((e) => e..apply(_getStoreByType(e.storeType), () => _stateByType[e.stateType]))
    );
  }

  @override
  void dispose() {
    while(_subscriptions.isNotEmpty) {
      final subscription = _subscriptions.removeLast();
      subscription.cancel();
    }

    _storeRepeatedHooks.forEach((e) => e.stop());

    super.dispose();
  }


  S getState<S>() => _stateByType[typeOf<S>()];

  Store<S> _getStoreByType<S>(Type storeType) {
    final Store? store = _storeByType[storeType];

    if(store == null)
      throw StoreException.noStoreFound(storeType);

    return store as Store<S>;
  }

  Store<S> getStore<S>() => _getStoreByType(typeOf<Store<S>>());

  List<Store> requireStores(BuildContext context);

  List<StoreInitializer> requireInitializers(BuildContext context) => [];
  List<StoreHook> requireHooks(BuildContext context) => [];
  List<StoreRepeater> requireRepeatedHooks(BuildContext context) => [];
}
