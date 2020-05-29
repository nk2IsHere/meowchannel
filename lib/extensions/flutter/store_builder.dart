import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meowchannel/core/store.dart';
import 'package:meowchannel/extensions/flutter/store_provider.dart';

///
/// Shoutouts to Flutter Bloc
/// This implementation is purely based on
/// https://github.com/felangel/bloc/blob/master/packages/flutter_bloc/lib/src/bloc_builder.dart
///

typedef StoreWidgetBuilder<S> = Widget Function(BuildContext context, S state);
typedef StoreBuilderCondition<S> = bool Function(S previous, S current);

class StoreBuilder<S> extends StoreBuilderBase<S> {
  final StoreWidgetBuilder<S> builder;

  const StoreBuilder({
    Key key,
    @required this.builder,
    Store<S> store,
    StoreBuilderCondition<S> condition,
  }): assert(builder != null),
    super(key: key, store: store, condition: condition);

  @override
  Widget build(BuildContext context, S state) => builder(context, state);
}

abstract class StoreBuilderBase<S> extends StatefulWidget {
  const StoreBuilderBase({
    Key key, 
    this.store, 
    this.condition
  }): super(key: key);

  final Store<S> store;
  final StoreBuilderCondition<S> condition;
  Widget build(BuildContext context, S state);

  @override
  State<StoreBuilderBase<S>> createState() => _StoreBuilderBaseState<S>();
}

class _StoreBuilderBaseState<S> extends State<StoreBuilderBase<S>> {
  StreamSubscription<S> _subscription;
  S _previousState;
  S _state;
  Store<S> _store;

  @override
  void initState() {
    super.initState();
    _store = widget.store ?? StoreProvider.of<S>(context);
    _previousState = _store?.getPreviousStateUnsafe();
    _state = _store?.getStateUnsafe();
    _subscribe();
  }

  @override
  void didUpdateWidget(StoreBuilderBase<S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldStore = oldWidget.store ?? StoreProvider.of<S>(context);
    final currentStore = widget.store ?? oldStore;
    if (oldStore != currentStore) {
      if (_subscription != null) {
        _unsubscribe();
        _store = widget.store ?? StoreProvider.of<S>(context);
        _previousState = _store?.getPreviousStateUnsafe();
        _state = _store?.getStateUnsafe();
      }
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) => widget.build(context, _state);

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (_store != null) {
      _subscription = _store.channel.skip(1)
        .listen((state) {
          if (widget.condition?.call(_previousState, state) ?? true) {
            setState(() {
              _state = state;
            });
          }
          _previousState = state;
        });
    }
  }

  void _unsubscribe() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
  }
}