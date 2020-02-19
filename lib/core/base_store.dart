import 'package:meowflux/core/action.dart';
import 'package:meowflux/core/dispatcher.dart';
import 'package:meowflux/core/middleware.dart';
import 'package:meowflux/core/reducer.dart';
import 'package:meowflux/extensions/channel.dart';

import '_actions.dart';
import '_store.dart';

class BaseStore<S> extends Store<S> {
  final Reducer<S> reducer;
  final S initialState;
  final List<Middleware> middleware;

  final StateChannel<S> _stateChannel = StateChannel();

  Dispatcher _dispatcher;

  BaseStore({
    this.reducer,
    this.initialState,
    this.middleware = const <Middleware>[]
  }) {
    if(initialState != null)
      _stateChannel.send(initialState);

    _dispatcher = middleware.reversed.fold<Dispatcher>((action) async {
      _stateChannel.send(reducer(action, _stateChannel.valueOrNull()));
    }, (previousDispatcher, nextMiddleware) => 
      nextMiddleware(_dispatchRoot, _stateChannel.valueOrNull, previousDispatcher)
    );

    stateStream = _stateChannel.asStream();

    dispatch(MeowFluxInit()); 
  }

  void _dispatchRoot(Action action) {
    _dispatcher(action);
  }

  @override
  Future dispatch(Action action) async {
    _dispatcher(action);
  }

  @override
  Future<S> getState() async {
    S state = await _stateChannel.receive();
    return state;
  }
}