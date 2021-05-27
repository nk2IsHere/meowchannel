import 'package:meowchannel/core/actions.dart';
import 'package:meowchannel/core/dispatcher.dart';
import 'package:meowchannel/core/module.dart';
import 'package:meowchannel/core/reducer.dart';
import 'package:meowchannel/core/state_action.dart';
import 'package:meowchannel/extensions/channel.dart';

import '_store.dart';

class Store<S> extends AbstractStore<S> {
  final Reducer<S> reducer;
  final S initialState;
  final List<Module<S>> modules;
  final Map<String, dynamic> _moduleInitialValues = Map();

  final MutableStateChannel<StateAction<S, dynamic>> _stateChannel = StateChannelImpl();

  late Dispatcher _dispatcher;

  Store({
    required this.reducer,
    required this.initialState,
    this.modules = const []
  }) {
    if(initialState != null)
      _stateChannel.send(StateAction(initialState, null));

    channel = _stateChannel.asStream();

    _dispatcher = modules.reversed.fold<Dispatcher>(
      (action) async => _stateChannel.send(
        StateAction(
          await reducer(action, _stateChannel.valueOrNull()?.state ?? initialState),
          action
        )
      ),
      (previousDispatcher, nextModule) => nextModule(
        _dispatchRoot,
        (registrar) => _registerInitialValueForModule(nextModule, registrar(this.initialState)),
        _stateChannel,
        previousDispatcher
      )
    );

    dispatch(MeowChannelInit()); 
  }

  void _registerInitialValueForModule(Module module, dynamic value) {
    _moduleInitialValues[module.id] = value;
  }

  T getInitialValueForModule<T>(String id) => _moduleInitialValues[id] as T;

  Future<void> _dispatchRoot(dynamic action) async {
    await _dispatcher(action);
  }

  @override
  Future<void> dispatch(dynamic action) async {
    await _dispatcher(action);
  }

  @override
  StateAction<S, dynamic>? getPreviousStateUnsafe() {
    return _stateChannel.previousValueOrNull();
  }

  @override
  StateAction<S, dynamic>? getStateUnsafe() {
    return _stateChannel.valueOrNull();
  }

  @override
  Future<StateAction<S, dynamic>> getState() async {
    return await _stateChannel.receive();
  }

  @override
  Future<void> close() async {
    await this.dispatch(MeowChannelClose());
    _stateChannel.close();
  }
}
