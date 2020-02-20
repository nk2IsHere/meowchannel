import 'package:meowflux/core/action.dart';
import 'package:meowflux/core/actions.dart';
import 'package:meowflux/core/dispatcher.dart';
import 'package:meowflux/core/middleware.dart';
import 'package:meowflux/core/reducer.dart';
import 'package:meowflux/extensions/channel.dart';

import '_store.dart';

class Store<S> extends AbstractStore<S> {
  final Reducer<S> reducer;
  final S initialState;
  final List<Middleware> middleware;

  final StateChannel<S> _stateChannel = StateChannel();

  Stream<S> get channel => _stateChannel.asStream();

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

  @override
  void close() {
    this.dispatch(MeowFluxClose());
    _stateChannel.close();
  }
}