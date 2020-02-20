import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:meowflux/core/store.dart';

Type _typeOf<T>() => T;

abstract class StoreState<W extends StatefulWidget> extends State<W> {
  List<Store> requireStores(BuildContext context);
}

mixin WidgetStoreProviderMixin<W extends StatefulWidget> on StoreState<W> {
  final Map<String, Store> _storeByType = Map();
  final Map<String, dynamic> _stateByType = Map();
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();

    requireStores(context).forEach((store) { 
      _storeByType.putIfAbsent(store.runtimeType.toString(), () => store);
      _subscriptions.add(
        store.channel
          .listen((state) {
            if(this.mounted) setState(() {
              _stateByType.update(
                state.runtimeType.toString(), 
                (_) => state, 
                ifAbsent: () => state
              );
            });
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

}