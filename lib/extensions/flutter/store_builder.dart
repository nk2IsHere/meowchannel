import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meowchannel/core/state_action.dart';
import 'package:meowchannel/core/store.dart';
import 'package:meowchannel/extensions/flutter/store_provider.dart';

///
/// Shoutouts to Flutter Bloc
/// This implementation is purely based on
/// https://github.com/felangel/bloc/blob/master/packages/flutter_bloc/lib/src/bloc_builder.dart
///

typedef StoreWidgetBuilder<S> = Widget Function(BuildContext context, S state, dynamic action);
typedef StoreBuilderCondition<S> = bool Function(StateAction<S, dynamic>? previous, StateAction<S, dynamic> current);

class StoreBuilder<S> extends StoreBuilderBase<S> {

  final StoreWidgetBuilder<S> builder;

  const StoreBuilder({
    Key? key,
    required this.builder,
    required Store<S> store,
    StoreBuilderCondition<S>? condition,
  }): super(key: key, store: store, condition: condition);

  @override
  Widget build(BuildContext context, StateAction<S, dynamic> state) =>
      builder(context, state.state, state.action);
}

abstract class StoreBuilderBase<S> extends StatefulWidget {

  final Store<S> store;
  final StoreBuilderCondition<S>? condition;

  const StoreBuilderBase({
    Key? key,
    required this.store,
    this.condition
  }): super(key: key);

  Widget build(BuildContext context, StateAction<S, dynamic> state);

  @override
  State<StoreBuilderBase<S>> createState() =>
      _StoreBuilderBaseState<S>();
}

class _StoreBuilderBaseState<S> extends State<StoreBuilderBase<S>> {
  StreamSubscription<StateAction<S, dynamic>>? _subscription;
  StateAction<S, dynamic>? _previousState;
  StateAction<S, dynamic>? _state;
  late Store<S> _store;

  @override
  void initState() {
    super.initState();
    _store = widget.store;
    _previousState = _store.getPreviousStateUnsafe();
    _state = _store.getStateUnsafe();
    _subscribe();
  }

  @override
  void didUpdateWidget(StoreBuilderBase<S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldStore = oldWidget.store;
    final currentStore = widget.store;
    if (oldStore != currentStore) {
      if (_subscription != null) {
        _unsubscribe();
        _store = widget.store;
        _previousState = _store.getPreviousStateUnsafe();
        _state = _store.getStateUnsafe();
      }
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) => widget.build(context, _state!);

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
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

  void _unsubscribe() {
    if (_subscription != null) {
      _subscription?.cancel();
      _subscription = null;
    }
  }
}
