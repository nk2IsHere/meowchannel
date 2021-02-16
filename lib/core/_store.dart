import 'package:meowchannel/core/dispatcher.dart';
import 'package:meowchannel/core/state_action.dart';

abstract class AbstractStore<S> extends StoreDispatcher {
  Future<void> close();
  Future<StateAction<S, dynamic>> getState();
  StateAction<S, dynamic> getPreviousStateUnsafe();
  StateAction<S, dynamic> getStateUnsafe();
  Stream<StateAction<S, dynamic>> channel;
}