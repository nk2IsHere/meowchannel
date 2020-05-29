import 'package:meowchannel/core/action.dart';
import 'package:meowchannel/core/actions.dart';
import 'package:meowchannel/core/dispatcher.dart';
import 'package:meowchannel/core/middleware.dart';
import 'package:meowchannel/core/reducer.dart';
import 'package:meowchannel/extensions/channel.dart';

import '_store.dart';

class Store<S> extends AbstractStore<S> {
  final Reducer<S> reducer;
  final S initialState;
  final List<Middleware> middleware;

  final StateChannel<S> _stateChannel = StateChannel();

  Dispatcher _dispatcher;

  Store({
    this.reducer,
    this.initialState,
    this.middleware = const <Middleware>[]
  }) {
    if(initialState != null)
      _stateChannel.send(initialState);

    _dispatcher = middleware.reversed.fold<Dispatcher>((action) {
      _stateChannel.send(reducer(action, _stateChannel.valueOrNull()));
    }, (previousDispatcher, nextMiddleware) => 
      nextMiddleware(_dispatchRoot, _stateChannel.valueOrNull, previousDispatcher)
    );

    channel = _stateChannel.asStream();

    dispatch(MeowChannelInit()); 
  }

  void _dispatchRoot(Action action) {
    _dispatcher(action);
  }

  @override
  void dispatch(Action action) {
    _dispatcher(action);
  }

  @override
  S getPreviousStateUnsafe() {
    return _stateChannel.previousValueOrNull();
  }

  @override
  S getStateUnsafe() {
    return _stateChannel.valueOrNull();
  }

  @override
  Future<S> getState() async {
    S state = await _stateChannel.receive();
    return state;
  }

  @override
  void close() {
    this.dispatch(MeowChannelClose());
    _stateChannel.close();
  }
}