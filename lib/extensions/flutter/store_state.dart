import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meowchannel/extensions/flutter/store_initializer.dart';
import 'package:meowchannel/extensions/flutter/store_repeater.dart';
import 'package:meowchannel/meowchannel.dart';
import 'package:meowchannel/utils/iterable_utils.dart';
import 'package:meowchannel/utils/type_utils.dart';

abstract class StoreState<W extends StatefulWidget> extends State<W> {
  final Map<String, Store> _storeByType = Map();
  final Map<String, dynamic> _stateByType = Map();
  final List<StreamSubscription> _subscriptions = [];

  final List<StoreInitializer> _storeInitializers = [];
  final Map<String, List<StoreHook>> _storeHooks = Map();
  final List<StoreRepeater> _storeRepeatedHooks = [];

  @protected final List<StoreHook> mixinGlobalHooks = [];

  @override
  void initState() {
    super.initState();

    _storeHooks.addAll(
      requireHooks(context)
        .groupBy((e) => e.storeType)
    );

    requireStores(context).forEach((store) {
      _storeByType.putIfAbsent(store.runtimeType.toString(), () => store);

      if(store.getStateUnsafe() != null) {
        _stateByType.putIfAbsent(
          store.initialState.runtimeType.toString(),
          () => store.getStateUnsafe().state
        );
      } else if(store.initialState != null) {
        _stateByType.putIfAbsent(
          store.initialState.runtimeType.toString(),
          () => store.initialState
        );
      }
      _storeHooks.putIfAbsent(store.runtimeType.toString(), () => []);

      _subscriptions.add(
        store.channel.listen((state) {
          if(this.mounted) {
            setState(() {
              _stateByType.update(
                state.state.runtimeType.toString(),
                (_) => state.state,
                ifAbsent: () => state.state
              );
            });

            _storeHooks[store.runtimeType.toString()]?.forEach((hook) {
              hook.apply(store, state.state, state.action);
            });
            mixinGlobalHooks.forEach((hook) {
              hook.apply(store, state.state, state.action);
            });
          }
        })
      );
    });

    _storeInitializers.addAll(
      requireInitializers(context)
        .map((e) => e..apply(_storeByType[e.storeType]))
    );

    _storeRepeatedHooks.addAll(
      requireRepeatedHooks(context)
        .map((e) => e..apply(_storeByType[e.storeType], () => _stateByType[e.stateType]))
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


  S getState<S>() => _stateByType[typeOf<S>().toString()];
  Store<S> getStore<S>() => _storeByType[typeOf<Store<S>>().toString()];

  List<Store> requireStores(BuildContext context);

  List<StoreInitializer> requireInitializers(BuildContext context) => [];
  List<StoreHook> requireHooks(BuildContext context) => [];
  List<StoreRepeater> requireRepeatedHooks(BuildContext context) => [];
}