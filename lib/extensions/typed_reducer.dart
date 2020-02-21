import 'package:meowchannel/core/action.dart';
import 'package:meowchannel/core/reducer.dart';

Reducer<S> TypedReducer<A extends Action, S>(
  S initialState, 
  S Function(A action, S previousState) reducer
) => (Action action, S previousState) {
  final state = previousState ?? initialState;
  return action is A? reducer(action, state) 
    : state;
};