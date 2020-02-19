import 'package:meowflux/core/action.dart';
import 'package:meowflux/core/dispatcher.dart';
import 'package:meowflux/core/middleware.dart';
import 'package:meowflux/core/reducer.dart';
import 'package:meowflux/core/store.dart';
import 'package:meowflux/extensions/channel.dart';

import '_actions.dart';

class BaseStore<S> extends Store<S> {
  final Reducer<S> reducer;
  final S initialState;
  final List<Middleware> middleware;

  final StateChannel<S> _stateChannel = StateChannel();

  Dispatcher dispatcher;

  BaseStore({
    this.reducer,
    this.initialState,
    this.middleware = const <Middleware>[]
  }) {
    if(initialState != null)
      _stateChannel.send(initialState);

    dispatcher = middleware.reversed.fold<Dispatcher>((action) async {
      S state = await _stateChannel.receive();
      _stateChannel.send(reducer(action, state));
    }, (previousDispatcher, nextMiddleware) => 
      nextMiddleware(_dispatchRoot, _stateChannel.receive, previousDispatcher)
    );

    stateStream = _stateChannel.asStream();

    dispatch(MeowFluxInit()); 
  }

  void _dispatchRoot(Action action) {
    dispatcher(action);
  }


  @override
  Future dispatch(Action action) async {
    dispatcher(action);
  }

  @override
  Future<S> getState() async {
    S state = await _stateChannel.receive();
    return state;
  }
}